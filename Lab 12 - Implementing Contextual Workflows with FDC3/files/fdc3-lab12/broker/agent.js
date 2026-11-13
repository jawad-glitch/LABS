const express = require("express");
const cors = require("cors");
const http = require("http");
const WebSocket = require("ws");
const path = require("path");

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, "..")));

const server = http.createServer(app);
const wss = new WebSocket.Server({ server });
const registry = new Map();

function log(event, appId, detail = "") {
  console.log(`${new Date().toISOString()} ${event} appId=${appId || "unknown"} ${detail}`.trim());
}

function send(socket, payload) {
  if (socket && socket.readyState === WebSocket.OPEN) {
    socket.send(JSON.stringify(payload));
    return true;
  }
  return false;
}

function register(socket, message) {
  if (typeof message.appId !== "string" || !message.appId ||
      !Array.isArray(message.intents) || !Array.isArray(message.contextTypes)) {
    send(socket, {
      messageType: "registerError",
      reason: "Registration requires appId, intents[] and contextTypes[]"
    });
    return;
  }

  const record = {
    socket,
    appId: message.appId,
    intents: [...new Set(message.intents)],
    contextTypes: [...new Set(message.contextTypes)]
  };

  registry.set(socket, record);
  send(socket, { messageType: "registered", appId: record.appId });
  log("REGISTER", record.appId,
    `intents=${record.intents.join(",")} contexts=${record.contextTypes.join(",")}`);
}

function getIntentHandler(intentName) {
  const matches = [...registry.values()].filter(record =>
    record.intents.includes(intentName) &&
    record.socket.readyState === WebSocket.OPEN
  );
  return matches.length === 1 ? matches[0] : null;
}

function getContextListeners(contextType) {
  return [...registry.values()].filter(record =>
    record.contextTypes.includes(contextType) &&
    record.socket.readyState === WebSocket.OPEN
  );
}

function validContext(context) {
  return context && typeof context === "object" &&
    typeof context.type === "string" &&
    context.type.length > 0;
}

wss.on("connection", socket => {
  socket.on("message", raw => {
    let message;
    try {
      message = JSON.parse(raw.toString());
    } catch {
      return send(socket, {
        messageType: "protocolError",
        reason: "Message must be valid JSON"
      });
    }

    if (!message || typeof message.messageType !== "string") {
      return send(socket, {
        messageType: "protocolError",
        reason: "messageType is required"
      });
    }

    if (message.messageType === "register") {
      return register(socket, message);
    }

    const sender = registry.get(socket);
    if (!sender) {
      return send(socket, {
        messageType: "protocolError",
        reason: "Register before sending broker messages"
      });
    }

    if (message.messageType === "broadcast") {
      if (!validContext(message.context)) {
        return send(socket, {
          messageType: "protocolError",
          reason: "A context object with a type field is required"
        });
      }

      log("BROADCAST", sender.appId, `contextType=${message.context.type}`);
      const listeners = getContextListeners(message.context.type);
      let delivered = 0;

      for (const listener of listeners) {
        if (listener.socket !== socket &&
            send(listener.socket, {
              messageType: "contextUpdate",
              context: message.context,
              sourceAppId: sender.appId
            })) delivered++;
      }

      send(socket, {
        messageType: "broadcastAck",
        status: "ok",
        delivered
      });
      return;
    }

    if (message.messageType === "raiseIntent") {
      const intent = message.intent;
      if (typeof intent !== "string" || !intent || !validContext(message.context)) {
        return send(socket, {
          messageType: "intentError",
          intent: intent || "",
          reason: "A named intent and valid context object are required"
        });
      }

      log("INTENT_RAISE", sender.appId, `intent=${intent}`);
      const handler = getIntentHandler(intent);

      if (!handler) {
        const registeredCount = [...registry.values()].filter(record =>
          record.intents.includes(intent)
        ).length;
        const reason = registeredCount > 1
          ? "Intent has multiple registered handlers"
          : "No connected application registered this intent";
        log("INTENT_ERROR", sender.appId, `intent=${intent} reason="${reason}"`);
        return send(socket, {
          messageType: "intentError",
          intent,
          reason
        });
      }

      const requestId = message.requestId || "";
      const delivered = send(handler.socket, {
        messageType: "intentDelivery",
        intent,
        context: message.context,
        sourceAppId: sender.appId,
        requestId
      });

      if (!delivered) {
        log("INTENT_ERROR", sender.appId, `intent=${intent} reason="Handler unavailable"`);
        return send(socket, {
          messageType: "intentError",
          intent,
          requestId,
          reason: "Registered intent handler is unavailable"
        });
      }

      send(socket, {
        messageType: "intentAck",
        intent,
        requestId,
        status: "ok",
        handlerAppId: handler.appId
      });
      return;
    }

    send(socket, {
      messageType: "protocolError",
      reason: `Unsupported messageType: ${message.messageType}`
    });
  });

  socket.on("close", () => {
    const record = registry.get(socket);
    if (record) {
      log("UNREGISTER", record.appId);
      registry.delete(socket);
    }
  });

  socket.on("error", error => {
    const record = registry.get(socket);
    log("SOCKET_ERROR", record?.appId, error.message);
    registry.delete(socket);
  });
});

app.get("/health", (req, res) => {
  res.json({
    status: "ok",
    connections: [...registry.values()].filter(r =>
      r.socket.readyState === WebSocket.OPEN
    ).length
  });
});

app.get("/api/registry", (req, res) => {
  res.json([...registry.values()].map(record => ({
    appId: record.appId,
    intents: record.intents,
    contextTypes: record.contextTypes
  })));
});

server.listen(3000, "0.0.0.0", () => {
  log("STARTUP", "broker", "Desktop Agent listening on http://localhost:3000");
});

module.exports = { server, registry, getIntentHandler, getContextListeners };
