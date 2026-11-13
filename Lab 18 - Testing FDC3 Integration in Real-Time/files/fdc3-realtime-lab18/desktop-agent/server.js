const express = require("express");
const cors = require("cors");
const WebSocket = require("ws");
const fs = require("fs");
const path = require("path");

const ROOT = path.resolve(__dirname, "..");
const LOG = path.join(ROOT, "logs/fdc3-activity.log");
const PORT = 3000;
const WSPORT = 8080;
const channelNames = ["red", "orange", "yellow", "green", "blue", "purple"];

fs.mkdirSync(path.dirname(LOG), { recursive: true });
if (!fs.existsSync(LOG)) fs.writeFileSync(LOG, "");

const channels = new Map(channelNames.map(id => [id, { id, context: null, members: new Set() }]));
const clients = new Map();

function record(entry) {
  const line = JSON.stringify({ timestamp: new Date().toISOString(), ...entry });
  fs.appendFileSync(LOG, line + "\n");
  process.stdout.write(line + "\n");
}

function send(socket, message) {
  if (socket.readyState === WebSocket.OPEN) socket.send(JSON.stringify(message));
}

function removeClient(socket) {
  const client = clients.get(socket);
  if (!client) return;
  for (const channel of channels.values()) channel.members.delete(socket);
  clients.delete(socket);
  record({ type: "APP_DISCONNECTED", appName: client.appName });
}

const wss = new WebSocket.Server({ port: WSPORT, host: "0.0.0.0" });

wss.on("connection", socket => {
  clients.set(socket, { appName: "Unregistered", intentHandlers: [], joined: new Set() });

  socket.on("message", raw => {
    try {
      const message = JSON.parse(raw.toString());
      const client = clients.get(socket);
      if (!client) return;

      if (message.type === "register") {
        if (typeof message.appName !== "string" || !message.appName.trim()) return;
        client.appName = message.appName;
        client.intentHandlers = Array.isArray(message.intentHandlers) ? message.intentHandlers.filter(x => typeof x === "string") : [];
        record({ type: "APP_REGISTERED", appName: client.appName, intentHandlers: client.intentHandlers });
        send(socket, { type: "registered", appName: client.appName });
        return;
      }

      if (message.type === "joinChannel") {
        const channel = channels.get(message.channelId);
        if (!channel) return send(socket, { type: "error", message: "Unknown channel" });
        channel.members.add(socket);
        client.joined.add(channel.id);
        record({ type: "CHANNEL_JOINED", appName: client.appName, channelId: channel.id });
        send(socket, { type: "channelJoined", channelId: channel.id });
        return;
      }

      if (message.type === "broadcast") {
        const channel = channels.get(message.channelId);
        const context = message.context;
        if (!channel || !context || typeof context.type !== "string" || typeof context.name !== "string" || !context.id || typeof context.id !== "object") {
          return send(socket, { type: "error", message: "Invalid broadcast or channel" });
        }
        if (!client.joined.has(channel.id)) return send(socket, { type: "error", message: "Join the channel before broadcasting" });

        channel.context = context;
        const delivery = {
          type: "context",
          channelId: channel.id,
          context,
          source: client.appName,
          timestamp: new Date().toISOString()
        };

        record({ type: "CONTEXT_BROADCAST", source: client.appName, channelId: channel.id, context });
        for (const target of channel.members) {
          if (target !== socket) send(target, delivery);
        }
        return;
      }

      if (message.type === "raiseIntent") {
        if (typeof message.intent !== "string" || !message.context || typeof message.context.type !== "string") {
          return send(socket, { type: "error", message: "Invalid intent request" });
        }

        const delivery = {
          type: "intent",
          intent: message.intent,
          context: message.context,
          source: client.appName,
          timestamp: new Date().toISOString()
        };

        record({ type: "INTENT_RAISED", source: client.appName, intent: message.intent, context: message.context });
        let delivered = 0;
        for (const [target, targetInfo] of clients.entries()) {
          if (target !== socket && targetInfo.intentHandlers.includes(message.intent)) {
            send(target, delivery);
            delivered++;
          }
        }
        send(socket, { type: "intentResult", intent: message.intent, delivered });
        return;
      }

      send(socket, { type: "error", message: "Unsupported message type" });
    } catch (error) {
      record({ type: "CLIENT_MESSAGE_ERROR", error: error.message });
      send(socket, { type: "error", message: "Message processing failed" });
    }
  });

  socket.on("error", error => record({ type: "WEBSOCKET_ERROR", error: error.message }));
  socket.on("close", () => removeClient(socket));
});

const app = express();
app.use(cors());
app.use(express.json({ limit: "1mb" }));
app.use(express.static(path.join(__dirname, "public")));

app.get("/api/apps", (req, res) => {
  res.json([...clients.values()].map(c => ({
    appName: c.appName,
    joinedChannels: [...c.joined],
    intentHandlers: c.intentHandlers
  })));
});

app.get("/api/channels", (req, res) => {
  res.json([...channels.values()].map(c => ({
    id: c.id,
    context: c.context,
    members: c.members.size
  })));
});

app.get("/api/logs", (req, res) => {
  try {
    const lines = fs.readFileSync(LOG, "utf8").split("\n").filter(Boolean);
    res.json(lines.slice(-100).map(line => {
      try { return JSON.parse(line); } catch { return { malformed: line }; }
    }));
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get("/health", (req, res) => res.json({ status: "ok", websocketPort: WSPORT }));

const httpServer = app.listen(PORT, "0.0.0.0", () => {
  console.log(`Desktop Agent HTTP: http://0.0.0.0:${PORT}`);
});
console.log(`Desktop Agent WebSocket: ws://0.0.0.0:${WSPORT}`);

function shutdown() {
  console.log("Shutting down Desktop Agent...");
  for (const socket of wss.clients) socket.close();
  wss.close();
  httpServer.close(() => process.exit(0));
}
process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);
