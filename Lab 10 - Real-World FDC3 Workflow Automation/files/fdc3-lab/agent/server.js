const express = require("express");
const cors = require("cors");
const path = require("path");
const IntentRegistry = require("../shared/registry");

const app = express();
const registry = new IntentRegistry();
const dispatchLog = [];

app.use(cors());
app.use(express.json({ limit: "1mb" }));
app.use(express.static(path.join(__dirname, "public")));

app.get("/health", (_req, res) => res.json({ status: "ok" }));

app.post("/register-intent", (req, res) => {
  try {
    const { appId, handlerUrl, intents } = req.body || {};
    if (!appId || typeof appId !== "string" ||
        !handlerUrl || typeof handlerUrl !== "string" ||
        !Array.isArray(intents)) {
      return res.status(400).json({
        registered: false,
        reason: "appId, handlerUrl and intents array are required"
      });
    }

    const parsed = new URL(handlerUrl);
    if (!["http:", "https:"].includes(parsed.protocol)) {
      return res.status(400).json({ registered: false, reason: "Invalid handler URL protocol" });
    }

    for (const intent of intents) {
      if (typeof intent !== "string" || !intent.trim()) {
        return res.status(400).json({ registered: false, reason: "Intent names must be non-empty strings" });
      }
    }

    registry.clear(appId);
    for (const intent of intents) registry.register(appId, intent, handlerUrl);

    console.log(`[REGISTER] app=${appId} intents=${intents.join(",") || "(none)"} url=${handlerUrl}`);
    res.json({ registered: true, appId, intents });
  } catch (error) {
    res.status(400).json({ registered: false, reason: error.message });
  }
});

app.post("/raise-intent", async (req, res) => {
  const { intent, context } = req.body || {};
  if (!intent || !context || typeof context !== "object") {
    return res.status(400).json({ success: false, reason: "intent and context object are required" });
  }

  const handlers = registry.resolve(intent);
  if (!handlers.length) {
    const record = {
      timestamp: new Date().toISOString(),
      intent,
      contextType: context.type || null,
      status: "no-handler",
      recipients: []
    };
    dispatchLog.unshift(record);
    dispatchLog.splice(50);
    console.log(`[DISPATCH] no handler registered for ${intent}`);
    return res.status(404).json({ success: false, reason: "No handler registered for " + intent });
  }

  const results = await Promise.all(handlers.map(async handler => {
    const target = handler.handlerUrl.replace(/\/$/, "") +
      "/handle/" + encodeURIComponent(intent);

    try {
      console.log(`[FORWARD] intent=${intent} app=${handler.appId} url=${target}`);
      const response = await fetch(target, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ intent, context })
      });
      const body = await response.json().catch(() => ({}));
      console.log(`[FORWARD RESULT] app=${handler.appId} status=${response.status} body=${JSON.stringify(body)}`);
      return {
        appId: handler.appId,
        status: response.status,
        accepted: response.ok && body.accepted === true,
        response: body
      };
    } catch (error) {
      console.error(`[FORWARD ERROR] app=${handler.appId} ${error.message}`);
      return { appId: handler.appId, status: 0, accepted: false, error: error.message };
    }
  }));

  const record = {
    timestamp: new Date().toISOString(),
    intent,
    contextType: context.type || null,
    status: results.every(item => item.accepted) ? "dispatched" : "failed",
    recipients: results
  };
  dispatchLog.unshift(record);
  dispatchLog.splice(50);

  const success = results.some(item => item.accepted);
  res.status(success ? 200 : 502).json({
    success,
    intent,
    dispatched: results.length,
    results
  });
});

app.get("/api/registry", (_req, res) => res.json(registry.list()));
app.get("/api/dispatch-log", (_req, res) => res.json(dispatchLog));

app.listen(3000, "0.0.0.0", () => {
  console.log("FDC3 Desktop Agent listening on port 3000");
});
