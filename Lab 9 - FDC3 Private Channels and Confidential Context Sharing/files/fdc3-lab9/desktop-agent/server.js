const express = require("express");
const http = require("http");
const WebSocket = require("ws");
const crypto = require("crypto");
const path = require("path");

const app = express();
const httpServer = http.createServer(app);
const wss = new WebSocket.Server({ port: 3001 });

const connections = new Map(); // appId -> Set<WebSocket>
const privateChannels = new Map(); // channelId -> channel state
const listeners = new Map(); // listenerId -> listener state

app.get("/health", (_req, res) => res.json({ status: "ok" }));

app.use("/trading", express.static(path.join(__dirname, "../apps/trading-app")));
app.use("/analytics", express.static(path.join(__dirname, "../apps/analytics-app")));
app.use("/shared", express.static(path.join(__dirname, "../shared")));

function send(ws, message) {
  if (ws.readyState === WebSocket.OPEN) ws.send(JSON.stringify(message));
}

function respond(ws, msgId, data, error) {
  send(ws, { msgId, ok: !error, ...(data ? { data } : {}), ...(error ? { error } : {}) });
}

function push(ws, event, channelId, payload = {}) {
  send(ws, { event, channelId, payload });
}

function getChannel(channelId) {
  return privateChannels.get(channelId);
}

function removeAppFromChannel(channel, appId, eventName = "participantLeft") {
  if (!channel || !channel.participants.has(appId)) return;
  channel.participants.delete(appId);

  for (const [listenerId, item] of listeners) {
    if (item.channelId === channel.id && item.appId === appId) {
      listeners.delete(listenerId);
    }
  }

  for (const participantId of channel.participants) {
    for (const ws of connections.get(participantId) || []) {
      push(ws, eventName, channel.id, { appId });
    }
  }
}

function removeSocket(ws) {
  const appId = ws.appId;
  if (!appId) return;

  for (const channel of privateChannels.values()) {
    if (channel.participants.has(appId)) {
      removeAppFromChannel(channel, appId);
    }
  }

  const sockets = connections.get(appId);
  if (sockets) {
    sockets.delete(ws);
    if (sockets.size === 0) connections.delete(appId);
  }
}

wss.on("connection", (ws) => {
  ws.on("message", (raw) => {
    let message;
    try {
      message = JSON.parse(raw.toString());
    } catch {
      return respond(ws, "", null, "Invalid JSON");
    }

    const { msgId, action, payload = {} } = message || {};
    if (!msgId || typeof action !== "string") {
      return respond(ws, msgId || "", null, "Invalid message");
    }

    try {
      if (action === "register") {
        const appId = String(payload.appId || "").trim();
        if (!appId) return respond(ws, msgId, null, "appId is required");

        if (ws.appId && ws.appId !== appId) {
          return respond(ws, msgId, null, "Connection already registered");
        }

        ws.appId = appId;
        if (!connections.has(appId)) connections.set(appId, new Set());
        connections.get(appId).add(ws);
        return respond(ws, msgId, { appId });
      }

      if (!ws.appId) return respond(ws, msgId, null, "Register before using the agent");

      if (action === "createPrivateChannel") {
        const channelId = "private-" + crypto.randomUUID();
        privateChannels.set(channelId, {
          id: channelId,
          owner: ws.appId,
          participants: new Set([ws.appId])
        });
        return respond(ws, msgId, { channelId, type: "private" });
      }

      if (action === "addParticipant") {
        const channel = getChannel(payload.channelId);
        if (!channel) return respond(ws, msgId, null, "Private channel not found");
        if (channel.owner !== ws.appId) return respond(ws, msgId, null, "Only channel owner can add participants");

        const targetAppId = String(payload.targetAppId || "").trim();
        if (!targetAppId) return respond(ws, msgId, null, "targetAppId is required");

        channel.participants.add(targetAppId);
        return respond(ws, msgId, { added: targetAppId });
      }

      if (action === "joinPrivateChannel") {
        const channel = getChannel(payload.channelId);
        if (!channel) return respond(ws, msgId, null, "Private channel not found");
        if (!channel.participants.has(ws.appId)) {
          return respond(ws, msgId, null, "App is not on the participant whitelist");
        }
        return respond(ws, msgId, { channelId: channel.id, type: "private" });
      }

      if (action === "addContextListener") {
        const channel = getChannel(payload.channelId);
        if (!channel) return respond(ws, msgId, null, "Private channel not found");

        const listenerId = crypto.randomUUID();
        const allowed = channel.participants.has(ws.appId);

        listeners.set(listenerId, {
          listenerId,
          channelId: channel.id,
          appId: ws.appId,
          ws,
          contextType: payload.contextType ?? null,
          authorized: allowed
        });

        console.log(
          `[LISTENER] app=${ws.appId} channel=${channel.id} authorized=${allowed}`
        );

        return respond(ws, msgId, { listenerId, authorized: allowed });
      }

      if (action === "removeContextListener") {
        const item = listeners.get(payload.listenerId);
        if (item && item.ws === ws) listeners.delete(payload.listenerId);
        return respond(ws, msgId, { removed: true });
      }

      if (action === "broadcast") {
        const channel = getChannel(payload.channelId);
        if (!channel) return respond(ws, msgId, null, "Private channel not found");
        if (!channel.participants.has(ws.appId)) {
          return respond(ws, msgId, null, "Sender is not a channel participant");
        }

        const context = payload.context;
        if (!context || typeof context.type !== "string") {
          return respond(ws, msgId, null, "Context must include a type");
        }

        let delivered = 0;
        for (const item of listeners.values()) {
          const recipientAllowed = channel.participants.has(item.appId);
          const isOtherSender = item.appId !== ws.appId;
          const channelMatches = item.channelId === channel.id;
          const typeMatches = !item.contextType || item.contextType === context.type;

          if (channelMatches && typeMatches && isOtherSender && recipientAllowed &&
              item.authorized && item.ws.readyState === WebSocket.OPEN) {
            push(item.ws, "contextReceived", channel.id, { context, source: ws.appId });
            delivered++;
          }
        }

        console.log(`[BROADCAST] channel=${channel.id} sender=${ws.appId} type=${context.type} delivered=${delivered}`);
        return respond(ws, msgId, { delivered });
      }

      if (action === "disconnect") {
        const channel = getChannel(payload.channelId);
        if (!channel) return respond(ws, msgId, null, "Private channel not found");
        if (!channel.participants.has(ws.appId)) {
          return respond(ws, msgId, null, "App is not a channel participant");
        }

        removeAppFromChannel(channel, ws.appId, "channelDisconnected");
        return respond(ws, msgId, { disconnected: true });
      }

      return respond(ws, msgId, null, "Unsupported action");
    } catch (error) {
      console.error("[DA ERROR]", error);
      respond(ws, msgId, null, "Desktop Agent internal error");
    }
  });

  ws.on("close", () => removeSocket(ws));
  ws.on("error", (error) => console.error("[WS ERROR]", error.message));
});

httpServer.listen(3000, "0.0.0.0", () => {
  console.log("HTTP health server listening on port 3000");
});
console.log("FDC3 WebSocket Desktop Agent listening on port 3001");
