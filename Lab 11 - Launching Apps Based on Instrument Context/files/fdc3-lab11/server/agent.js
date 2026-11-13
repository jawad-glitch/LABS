const express = require("express");
const http = require("http");
const cors = require("cors");
const WebSocket = require("ws");
const crypto = require("crypto");
const fs = require("fs");
const path = require("path");

const app = express();
app.use(cors());
app.use(express.json());

const manifestPath = path.join(__dirname, "app-directory.json");
const manifest = JSON.parse(fs.readFileSync(manifestPath, "utf8"));
const apps = new Map(manifest.applications.map(entry => [entry.appId, entry]));
const connections = new Map();
const lastContext = new Map();
const pendingIntents = new Map();

const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

app.get("/health", (req, res) => {
  res.json({
    status: "ok",
    connections: [...connections.values()].filter(c => c.readyState === WebSocket.OPEN).length
  });
});

app.get("/api/app-directory", (req, res) => res.json(manifest));

function send(socket, message) {
  if (socket.readyState === WebSocket.OPEN) {
    socket.send(JSON.stringify(message));
  }
}

function ack(socket, messageId, status, reason, launches) {
  const response = { type: "ack", messageId, status };
  if (reason) response.reason = reason;
  if (launches && launches.length) response.reason = JSON.stringify({ launches });
  send(socket, response);
}

function validContext(context) {
  return !!context &&
    context.type === "fdc3.instrument" &&
    typeof context.name === "string" &&
    typeof context.id?.ticker === "string" &&
    context.id.ticker.length > 0;
}

function channelHasApp(appId, channelId) {
  return [...connections.values()].some(c =>
    c.appId === appId && c.channelId === channelId &&
    c.readyState === WebSocket.OPEN
  );
}

function launchInfo(appId, channelId) {
  const entry = apps.get(appId);
  if (!entry) return null;
  const url = entry.details.url + "?channel=" + encodeURIComponent(channelId);
  return { appId, url };
}

function deliverIntent(target, intent, sourceAppId, context) {
  send(target, {
    type: "intentDelivery",
    intent,
    sourceAppId,
    context
  });
}

wss.on("connection", socket => {
  socket.appId = null;
  socket.channelId = null;

  socket.on("message", raw => {
    let message;
    try {
      message = JSON.parse(raw.toString());
    } catch {
      return ack(socket, "", "error", "Invalid JSON");
    }

    const { type, messageId, appId } = message;
    if (!messageId || !appId || !apps.has(appId)) {
      return ack(socket, messageId || "", "error", "Missing messageId or unknown appId");
    }

    if (type === "joinChannel") {
      if (typeof message.channelId !== "string" || !message.channelId) {
        return ack(socket, messageId, "error", "channelId is required");
      }

      socket.appId = appId;
      socket.channelId = message.channelId;
      connections.set(socket, socket);
      ack(socket, messageId, "ok");

      const previous = lastContext.get(socket.channelId);
      if (previous && appId !== previous.sourceAppId) {
        send(socket, {
          type: "contextDelivery",
          sourceAppId: previous.sourceAppId,
          context: previous.context
        });
      }

      const pendingKey = appId + ":" + socket.channelId;
      const queued = pendingIntents.get(pendingKey) || [];
      queued.forEach(item =>
        deliverIntent(socket, item.intent, item.sourceAppId, item.context)
      );
      pendingIntents.delete(pendingKey);
      return;
    }

    if (socket.appId !== appId || !socket.channelId) {
      return ack(socket, messageId, "error", "Join a channel before sending messages");
    }

    if (type === "broadcast") {
      if (message.channelId !== socket.channelId || !validContext(message.context)) {
        return ack(socket, messageId, "error", "Invalid channel or fdc3.instrument context");
      }

      const context = message.context;
      lastContext.set(socket.channelId, { sourceAppId: appId, context });

      for (const target of connections.values()) {
        if (target !== socket && target.channelId === socket.channelId &&
            target.readyState === WebSocket.OPEN) {
          send(target, { type: "contextDelivery", sourceAppId: appId, context });
        }
      }

      const launches = [];
      for (const entry of manifest.applications) {
        if (entry.autoLaunch && !channelHasApp(entry.appId, socket.channelId)) {
          const info = launchInfo(entry.appId, socket.channelId);
          if (info) launches.push(info);
        }
      }
      return ack(socket, messageId, "ok", null, launches);
    }

    if (type === "raiseIntent") {
      if (!validContext(message.context) || typeof message.intent !== "string") {
        return ack(socket, messageId, "error", "Invalid intent or instrument context");
      }

      const targetEntry = manifest.applications.find(entry =>
        entry.intents.some(intent =>
          intent.name === message.intent &&
          intent.contexts.includes(message.context.type)
        )
      );

      if (!targetEntry) {
        return ack(socket, messageId, "error", "No manifest handler for " + message.intent);
      }

      const targets = [...connections.values()].filter(target =>
        target.appId === targetEntry.appId &&
        target.channelId === socket.channelId &&
        target.readyState === WebSocket.OPEN
      );

      if (targets.length) {
        targets.forEach(target =>
          deliverIntent(target, message.intent, appId, message.context)
        );
        return ack(socket, messageId, "ok");
      }

      const key = targetEntry.appId + ":" + socket.channelId;
      if (!pendingIntents.has(key)) pendingIntents.set(key, []);
      pendingIntents.get(key).push({
        intent: message.intent,
        sourceAppId: appId,
        context: message.context
      });

      const info = launchInfo(targetEntry.appId, socket.channelId);
      return ack(socket, messageId, "ok", null, info ? [info] : []);
    }

    ack(socket, messageId, "error", "Unsupported message type");
  });

  socket.on("close", () => connections.delete(socket));
  socket.on("error", () => connections.delete(socket));
});

server.app = app;
server.wss = wss;
module.exports = server;
