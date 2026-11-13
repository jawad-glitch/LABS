const express = require("express");
const http = require("http");
const { Server } = require("socket.io");
const crypto = require("crypto");
const path = require("path");
const ChannelRegistry = require("./channel-registry");

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: { origin: "*", methods: ["GET", "POST"] }
});
const registry = new ChannelRegistry();

app.use(express.json({ limit: "1mb" }));
app.use(express.static(path.join(__dirname, "..", "public")));

app.get("/api/channels", (req, res) => {
  res.json(registry.snapshot());
});

app.get("/api/channels/:id", (req, res) => {
  const detail = registry.getChannelDetail(req.params.id);
  if (!detail) return res.status(404).json({ error: "Channel not found" });
  res.json(detail);
});

app.post("/api/test-broadcast", (req, res) => {
  const channelId = req.body?.channelId;
  const context = req.body?.context;
  const testSocketId = `rest-test-${crypto.randomUUID()}`;

  try {
    registry.registerApp(testSocketId, {
      name: "rest-validation",
      type: "test",
      version: "1.0.0"
    });
    registry.joinChannel(testSocketId, channelId);
    registry.broadcastContext(testSocketId, channelId, context);
    registry.deregisterApp(testSocketId);
    return res.json({ ok: true });
  } catch (error) {
    registry.deregisterApp(testSocketId);
    return res.json({
      ok: false,
      error: {
        code: error.code || "BROKER_ERROR",
        message: error.message
      }
    });
  }
});

app.get("/portfolio", (req, res) =>
  res.sendFile(path.join(__dirname, "..", "portfolio-app", "index.html"))
);
app.get("/crm", (req, res) =>
  res.sendFile(path.join(__dirname, "..", "crm-app", "index.html"))
);
app.get("/market-data", (req, res) =>
  res.sendFile(path.join(__dirname, "..", "market-data-app", "index.html"))
);

io.on("connection", socket => {
  socket.on("registerApp", (meta = {}) => {
    try {
      const result = registry.registerApp(socket.id, meta);
      socket.data.appId = result.appId;
      socket.emit("appRegistered", result);
    } catch (error) {
      socket.emit("fdc3Error", {
        code: error.code || "REGISTRATION_FAILED",
        message: error.message
      });
    }
  });

  socket.on("joinChannel", (payload = {}) => {
    try {
      const result = registry.joinChannel(socket.id, payload.channelId);
      socket.emit("channelJoined", result);
      if (result.currentContext) {
        socket.emit("contextReceived", {
          channelId: result.channelId,
          context: result.currentContext,
          senderAppId: "channel-history"
        });
      }
    } catch (error) {
      socket.emit("fdc3Error", {
        code: error.code || "JOIN_FAILED",
        message: error.message
      });
    }
  });

  socket.on("broadcastContext", (payload = {}) => {
    try {
      const targets = registry.broadcastContext(
        socket.id,
        payload.channelId,
        payload.context
      );
      const message = {
        channelId: payload.channelId,
        context: payload.context,
        senderAppId: socket.data.appId || "unknown"
      };
      for (const targetId of targets) {
        io.to(targetId).emit("contextReceived", message);
      }
    } catch (error) {
      socket.emit("fdc3Error", {
        code: error.code || "BROADCAST_FAILED",
        message: error.message
      });
    }
  });

  socket.on("getCurrentContext", (payload = {}) => {
    socket.emit("currentContext", {
      channelId: payload.channelId,
      context: registry.getCurrentContext(payload.channelId)
    });
  });

  socket.on("disconnect", () => registry.deregisterApp(socket.id));
});

const PORT = Number(process.env.PORT || 3000);
server.listen(PORT, "0.0.0.0", () => {
  console.log(`FDC3 workflow broker listening on port ${PORT}`);
});
