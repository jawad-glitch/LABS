const express = require("express");
const path = require("path");
const validateContext = require("../../shared/validator");

const app = express();
app.use(express.json({ limit: "1mb" }));
app.use(express.static(path.join(__dirname, "public")));

const MARKET_DATA = {
  AAPL:  { price: 189.30, change: 1.45 },
  MSFT:  { price: 415.20, change: -0.87 },
  GOOGL: { price: 175.84, change: 2.10 },
  TSLA:  { price: 177.58, change: -3.22 },
  NVDA:  { price: 950.02, change: 18.40 },
  AMD:   { price: 158.67, change: 0.95 }
};

const intentLog = [];

function handleIntent(intentName, req, res) {
  const context = req.body?.context;
  const validation = validateContext(intentName, context);

  if (!validation.valid) {
    console.warn(`[REJECT] ${intentName}: ${validation.reason}`);
    return res.status(400).json({
      accepted: false,
      reason: validation.reason
    });
  }

  const entry = {
    intent: intentName,
    context: JSON.parse(JSON.stringify(context)),
    timestamp: new Date().toISOString()
  };

  if (intentName === "ViewInstrument") {
    entry.marketData = MARKET_DATA[context.id.ticker] || null;
  }

  intentLog.unshift(entry);
  intentLog.splice(10);

  console.log(`[ACCEPT] ${intentName} type=${context.type} name=${context.name}`);
  res.json({ accepted: true });
}

app.post("/handle/ViewContact", (req, res) =>
  handleIntent("ViewContact", req, res));

app.post("/handle/ViewInstrument", (req, res) =>
  handleIntent("ViewInstrument", req, res));

app.get("/api/intent-log", (_req, res) => res.json(intentLog));

app.get("/health", (_req, res) => res.json({ status: "ok" }));

app.listen(3002, "0.0.0.0", async () => {
  console.log("Trading platform listening on port 3002");

  try {
    const response = await fetch("http://localhost:3000/register-intent", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        appId: "trading-app",
        handlerUrl: "http://localhost:3002",
        intents: ["ViewContact", "ViewInstrument"]
      })
    });

    const result = await response.json();
    if (!response.ok) throw new Error(JSON.stringify(result));
    console.log("[REGISTERED WITH DA]", JSON.stringify(result));
  } catch (error) {
    console.error("[DA REGISTRATION FAILED]", error.message);
  }
});
