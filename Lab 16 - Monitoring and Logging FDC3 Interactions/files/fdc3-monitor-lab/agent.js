const WebSocket = require("ws");
const { logEvent } = require("./config/logger");

const PORT = Number(process.env.AGENT_PORT || 4000);
const wss = new WebSocket.Server({ host: "0.0.0.0", port: PORT });

const clients = new Map();
const channels = new Map();
const intentHandlers = new Map();

function send(socket, event, payload = {}) {
  if (socket.readyState === WebSocket.OPEN) {
    socket.send(JSON.stringify({ event, ...payload }));
  }
}

function removeFromSetMap(map, key, socket) {
  const set = map.get(key);
  if (!set) return;
  set.delete(socket);
  if (set.size === 0) map.delete(key);
}

function deregister(socket) {
  const appId = clients.get(socket) || "unknown";

  for (const [channelId, members] of channels.entries()) {
    if (members.has(socket)) {
      members.delete(socket);
      logEvent("channel_left", appId, { channelId });
      if (members.size === 0) channels.delete(channelId);
    }
  }

  for (const [intentName, handlers] of intentHandlers.entries()) {
    removeFromSetMap(intentHandlers, intentName, socket);
  }

  clients.delete(socket);
  logEvent("app_disconnected", appId, {});
}

wss.on("connection", socket => {
  socket.isAlive = true;

  socket.on("pong", () => {
    socket.isAlive = true;
  });

  socket.on("message", raw => {
    let message;
    try {
      message = JSON.parse(raw.toString());
    } catch {
      send(socket, "error", { code: "INVALID_JSON", message: "Message must be valid JSON" });
      logEvent("error", clients.get(socket), { code: "INVALID_JSON" });
      return;
    }

    const appId = clients.get(socket) || "unregistered";

    if (message.event === "registerApp") {
      const requestedId = String(message.appId || "").trim();
      if (!requestedId) {
        send(socket, "error", { code: "APP_ID_REQUIRED", message: "appId is required" });
        return;
      }
      if (clients.has(socket)) {
        send(socket, "error", { code: "ALREADY_REGISTERED", message: "Socket already registered" });
        return;
      }

      clients.set(socket, requestedId);
      logEvent("app_connected", requestedId, {
        appId: requestedId,
        userAgent: message.userAgent || "node-websocket-client"
      });
      send(socket, "registered", { appId: requestedId });
      return;
    }

    if (!clients.has(socket)) {
      send(socket, "error", { code: "NOT_REGISTERED", message: "Register before sending events" });
      logEvent("error", "unregistered", { code: "NOT_REGISTERED" });
      return;
    }

    if (message.event === "joinChannel") {
      const channelId = String(message.channelId || "").trim();
      if (!channelId) {
        send(socket, "error", { code: "CHANNEL_REQUIRED", message: "channelId is required" });
        return;
      }
      if (!channels.has(channelId)) channels.set(channelId, new Set());
      channels.get(channelId).add(socket);
      logEvent("channel_joined", appId, { channelId, memberCount: channels.get(channelId).size });
      send(socket, "channelJoined", { channelId });
      return;
    }

    if (message.event === "broadcastContext") {
      const channelId = String(message.channelId || "");
      const members = channels.get(channelId);
      if (!members || !members.has(socket)) {
        send(socket, "error", { code: "NOT_IN_CHANNEL", message: "Join channel before broadcasting" });
        logEvent("error", appId, { code: "NOT_IN_CHANNEL", channelId });
        return;
      }
      if (!message.context || typeof message.context.type !== "string" ||
          !message.context.type.startsWith("fdc3.")) {
        send(socket, "error", { code: "MISSING_TYPE", message: "Context must have an fdc3. type" });
        logEvent("error", appId, { code: "MISSING_TYPE", channelId });
        return;
      }

      let delivered = 0;
      for (const member of members) {
        if (member !== socket && member.readyState === WebSocket.OPEN) {
          send(member, "contextReceived", {
            channelId,
            context: message.context,
            sourceAppId: appId
          });
          delivered++;
        }
      }

      logEvent("context_broadcast", appId, {
        channelId,
        contextType: message.context.type,
        delivered,
        context: message.context
      });
      send(socket, "contextBroadcast", { channelId, delivered });
      return;
    }

    if (message.event === "addIntentListener") {
      const intentName = String(message.intentName || "").trim();
      if (!intentName) {
        send(socket, "error", { code: "INTENT_REQUIRED", message: "intentName is required" });
        return;
      }
      if (!intentHandlers.has(intentName)) intentHandlers.set(intentName, new Set());
      intentHandlers.get(intentName).add(socket);
      logEvent("intent_listener_registered", appId, { intentName });
      send(socket, "intentListenerAdded", { intentName });
      return;
    }

    if (message.event === "raiseIntent") {
      const intentName = String(message.intentName || "").trim();
      const handlers = intentHandlers.get(intentName);
      const targets = handlers
        ? [...handlers].filter(target => target !== socket && target.readyState === WebSocket.OPEN)
        : [];

      if (targets.length === 0) {
        const failure = {
          intentName,
          channelId: message.channelId || null,
          reason: "NO_REGISTERED_HANDLER"
        };
        logEvent("intent_routing_failed", appId, failure);
        logEvent("error", appId, failure);
        send(socket, "intentFailed", {
          code: "NO_HANDLER",
          intentName,
          message: `No handler registered for ${intentName}`
        });
        return;
      }

      const payload = {
        intentName,
        context: message.context || {},
        sourceAppId: appId
      };

      for (const target of targets) {
        send(target, "intentReceived", payload);
      }

      logEvent("intent_routed", appId, {
        intentName,
        targetCount: targets.length
      });
      send(socket, "intentRouted", {
        intentName,
        targetCount: targets.length
      });
      return;
    }

    send(socket, "error", { code: "UNKNOWN_EVENT", message: "Unsupported event" });
    logEvent("error", appId, { code: "UNKNOWN_EVENT", event: message.event });
  });

  socket.on("close", () => deregister(socket));
  socket.on("error", error => {
    logEvent("error", clients.get(socket), { message: error.message });
  });
});

const heartbeat = setInterval(() => {
  for (const socket of wss.clients) {
    if (!socket.isAlive) {
      socket.terminate();
      continue;
    }
    socket.isAlive = false;
    socket.ping();
  }
}, 15000);

wss.on("close", () => clearInterval(heartbeat));

console.log(`FDC3 Desktop Agent listening on ws://0.0.0.0:${PORT}`);
