import express from "express";
import cors from "cors";
import http from "http";
import path from "path";
import fs from "fs";
import { randomUUID } from "crypto";
import { WebSocket, WebSocketServer } from "ws";

type FDC3Context = {
  type: string;
  id?: Record<string, string>;
  [key: string]: unknown;
};

type ClientState = {
  instanceId: string;
  appId: string;
  intents: Set<string>;
  channels: Set<string>;
  socket: WebSocket;
};

type ChannelState = {
  id: string;
  displayMetadata: { name: string; color: string };
  members: Set<string>;
  lastContext: FDC3Context | null;
};

const PORT = 3000;
const ROOT = path.resolve(__dirname, "../..");
const PUBLIC = path.join(ROOT, "public");
const LOG_DIR = path.join(ROOT, "logs");
const LOG_FILE = path.join(LOG_DIR, "agent-activity.log");

fs.mkdirSync(LOG_DIR, { recursive: true });

const channelColors: Record<string, string> = {
  red: "#e74c3c",
  orange: "#e67e22",
  yellow: "#f1c40f",
  green: "#27ae60",
  blue: "#3498db",
  purple: "#9b59b6"
};

const channels = new Map<string, ChannelState>(
  Object.entries(channelColors).map(([id, color]) => [
    id,
    {
      id,
      displayMetadata: { name: id[0].toUpperCase() + id.slice(1), color },
      members: new Set<string>(),
      lastContext: null
    }
  ])
);

const clients = new Map<string, ClientState>();

function log(event: Record<string, unknown>) {
  const entry = { timestamp: new Date().toISOString(), ...event };
  const line = JSON.stringify(entry);
  fs.appendFileSync(LOG_FILE, line + "\n");
  console.log(line);
}

function send(socket: WebSocket, message: object) {
  if (socket.readyState === WebSocket.OPEN) {
    socket.send(JSON.stringify(message));
    return true;
  }
  return false;
}

function validContext(context: any): context is FDC3Context {
  if (!context || typeof context !== "object" || Array.isArray(context)) return false;
  if (typeof context.type !== "string" || !context.type.trim()) return false;
  if (context.id !== undefined) {
    if (!context.id || typeof context.id !== "object" || Array.isArray(context.id)) return false;
    if (!Object.values(context.id).every(value => typeof value === "string")) return false;
  }
  return true;
}

function removeInstance(instanceId: string) {
  const client = clients.get(instanceId);
  if (!client) return;

  for (const channelId of client.channels) {
    channels.get(channelId)?.members.delete(instanceId);
  }

  clients.delete(instanceId);
  log({
    event: "INSTANCE_DISCONNECTED",
    instanceId,
    appId: client.appId
  });
}

function getConnectedRecipients(channelId: string, senderId: string): ClientState[] {
  const channel = channels.get(channelId);
  if (!channel) return [];

  const recipients: ClientState[] = [];
  for (const instanceId of channel.members) {
    if (instanceId === senderId) continue;
    const client = clients.get(instanceId);
    if (client && client.socket.readyState === WebSocket.OPEN) recipients.push(client);
  }
  return recipients;
}

function broadcastContext(sender: ClientState, channelId: string, context: FDC3Context) {
  const channel = channels.get(channelId);
  if (!channel) {
    send(sender.socket, { type: "error", message: "Unknown channel" });
    return;
  }

  if (!sender.channels.has(channelId)) {
    send(sender.socket, { type: "error", message: "Join the channel before broadcasting" });
    return;
  }

  if (!validContext(context)) {
    send(sender.socket, { type: "error", message: "Invalid FDC3 context" });
    return;
  }

  channel.lastContext = context;
  const recipients = getConnectedRecipients(channelId, sender.instanceId);

  const delivery = {
    type: "context",
    channelId,
    context,
    source: sender.appId,
    sourceInstanceId: sender.instanceId,
    timestamp: new Date().toISOString()
  };

  log({
    event: "CONTEXT_BROADCAST",
    source: sender.appId,
    sourceInstanceId: sender.instanceId,
    channelId,
    context,
    recipientCount: recipients.length
  });

  let delivered = 0;
  for (const recipient of recipients) {
    if (send(recipient.socket, delivery)) delivered++;
  }

  send(sender.socket, {
    type: "broadcastComplete",
    channelId,
    recipientCount: delivered,
    contextType: context.type
  });
}

function raiseIntent(sender: ClientState, intent: string, context: FDC3Context) {
  if (typeof intent !== "string" || !intent.trim() || !validContext(context)) {
    send(sender.socket, { type: "intentError", intent, message: "Invalid intent or context" });
    return;
  }

  const handlers = [...clients.values()].filter(client =>
    client.instanceId !== sender.instanceId &&
    client.intents.has(intent) &&
    client.socket.readyState === WebSocket.OPEN
  );

  if (handlers.length === 0) {
    log({ event: "INTENT_UNHANDLED", source: sender.appId, intent, context });
    send(sender.socket, {
      type: "intentError",
      intent,
      message: `No connected application is registered for intent '${intent}'`
    });
    return;
  }

  const delivery = {
    type: "intent",
    intent,
    context,
    source: sender.appId,
    sourceInstanceId: sender.instanceId,
    timestamp: new Date().toISOString()
  };

  log({
    event: "INTENT_RAISED",
    source: sender.appId,
    sourceInstanceId: sender.instanceId,
    intent,
    context,
    targets: handlers.map(handler => handler.appId)
  });

  let delivered = 0;
  for (const handler of handlers) {
    if (send(handler.socket, delivery)) delivered++;
  }

  send(sender.socket, {
    type: "intentResolution",
    intent,
    success: delivered > 0,
    delivered,
    message: `Intent '${intent}' delivered to ${delivered} handler(s)`
  });
}

const app = express();
app.use(cors());
app.use(express.json({ limit: "1mb" }));
app.use(express.static(PUBLIC));

app.get("/api/channels", (_req, res) => {
  res.json([...channels.values()].map(channel => ({
    id: channel.id,
    displayMetadata: channel.displayMetadata,
    lastContext: channel.lastContext,
    memberCount: channel.members.size
  })));
});

app.get("/api/apps", (_req, res) => {
  const directory = new Map<string, { appId: string; instances: number; intents: string[] }>();

  for (const client of clients.values()) {
    const existing = directory.get(client.appId) || {
      appId: client.appId,
      instances: 0,
      intents: []
    };
    existing.instances++;
    existing.intents = [...new Set([...existing.intents, ...client.intents])];
    directory.set(client.appId, existing);
  }

  res.json([...directory.values()]);
});

app.get("/api/instances", (_req, res) => {
  res.json([...clients.values()].map(client => ({
    instanceId: client.instanceId,
    appId: client.appId,
    channels: [...client.channels],
    intentHandlers: [...client.intents],
    connected: client.socket.readyState === WebSocket.OPEN
  })));
});

app.get("/health", (_req, res) => {
  res.json({ status: "ok", port: PORT, connectedInstances: clients.size });
});

const server = http.createServer(app);
const wss = new WebSocketServer({ server });

wss.on("connection", socket => {
  const instanceId = randomUUID();
  let client: ClientState | null = null;

  send(socket, { type: "connection", instanceId });

  socket.on("message", raw => {
    try {
      const message = JSON.parse(raw.toString());

      if (message.type === "register") {
        if (client) {
          send(socket, { type: "error", message: "This connection is already registered" });
          return;
        }

        if (typeof message.appId !== "string" || !message.appId.trim()) {
          send(socket, { type: "error", message: "register requires a non-empty appId" });
          return;
        }

        const intents = Array.isArray(message.intents)
          ? message.intents.filter((item: unknown) => typeof item === "string")
          : [];

        client = {
          instanceId,
          appId: message.appId,
          intents: new Set(intents),
          channels: new Set(),
          socket
        };

        clients.set(instanceId, client);
        log({ event: "INSTANCE_REGISTERED", instanceId, appId: client.appId, intents });
        send(socket, { type: "registered", instanceId, appId: client.appId, intents });
        return;
      }

      if (!client) {
        send(socket, { type: "error", message: "Register before sending commands" });
        return;
      }

      if (message.type === "joinChannel") {
        const channel = channels.get(message.channelId);
        if (!channel) {
          send(socket, { type: "error", message: "Unknown channel" });
          return;
        }

        channel.members.add(instanceId);
        client.channels.add(channel.id);
        log({ event: "CHANNEL_JOINED", instanceId, appId: client.appId, channelId: channel.id });
        send(socket, {
          type: "channelJoined",
          channelId: channel.id,
          displayMetadata: channel.displayMetadata
        });
        return;
      }

      if (message.type === "broadcastContext") {
        broadcastContext(client, message.channelId, message.context);
        return;
      }

      if (message.type === "raiseIntent") {
        raiseIntent(client, message.intent, message.context);
        return;
      }

      send(socket, { type: "error", message: "Unsupported message type" });
    } catch (error) {
      const detail = error instanceof Error ? error.message : String(error);
      log({ event: "MESSAGE_ERROR", instanceId, error: detail });
      send(socket, { type: "error", message: "Invalid message or processing error", detail });
    }
  });

  socket.on("error", error => {
    log({ event: "WEBSOCKET_ERROR", instanceId, error: error.message });
  });

  socket.on("close", () => {
    removeInstance(instanceId);
  });
});

server.listen(PORT, "0.0.0.0", () => {
  console.log(`FDC3 Desktop Agent listening on HTTP and WebSocket port ${PORT}`);
  console.log(`Static applications: ${PUBLIC}`);
  console.log(`Pre-seeded channels: ${[...channels.keys()].join(", ")}`);
});

function shutdown() {
  console.log("Stopping FDC3 Desktop Agent...");
  for (const socket of wss.clients) socket.close();
  wss.close();
  server.close(() => process.exit(0));
}
process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);
