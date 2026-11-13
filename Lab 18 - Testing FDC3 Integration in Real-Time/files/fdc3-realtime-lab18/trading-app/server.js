const express = require("express");
const cors = require("cors");
const WebSocket = require("ws");
const { v4: uuid } = require("uuid");
const path = require("path");

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

const PORT = 3001;
const DA = process.env.FDC3_DA_URL || "ws://127.0.0.1:8080";
const clients = new Set();
const instruments = [
  { symbol: "AAPL", name: "Apple Inc.", price: 225, change: 0, changePercent: 0 },
  { symbol: "MSFT", name: "Microsoft", price: 510, change: 0, changePercent: 0 },
  { symbol: "NVDA", name: "NVIDIA", price: 185, change: 0, changePercent: 0 },
  { symbol: "AMZN", name: "Amazon", price: 235, change: 0, changePercent: 0 },
  { symbol: "TSLA", name: "Tesla", price: 350, change: 0, changePercent: 0 }
];

let da;
let connected = false;

function emit(event) {
  const data = `data: ${JSON.stringify(event)}\n\n`;
  for (const client of clients) client.write(data);
}

function sendDA(message) {
  if (!da || da.readyState !== WebSocket.OPEN) throw new Error("Desktop Agent is not connected");
  da.send(JSON.stringify(message));
}

function connectDA() {
  da = new WebSocket(DA);
  da.on("open", () => {
    connected = true;
    da.send(JSON.stringify({ type: "register", appName: "TradingApp", intentHandlers: [] }));
    emit({ type: "agentStatus", connected: true });
    console.log("TradingApp connected and registered with Desktop Agent");
  });
  da.on("message", raw => {
    try {
      const message = JSON.parse(raw.toString());
      emit(message);
    } catch (error) {
      console.error("TradingApp message error:", error.message);
    }
  });
  da.on("close", () => {
    connected = false;
    emit({ type: "agentStatus", connected: false });
    setTimeout(connectDA, 2000);
  });
  da.on("error", error => console.error("TradingApp WebSocket:", error.message));
}
connectDA();

setInterval(() => {
  for (const item of instruments) {
    const old = item.price;
    item.price = Math.max(1, +(old + (Math.random() - 0.5) * old * 0.006).toFixed(2));
    item.change = +(item.price - old).toFixed(2);
    item.changePercent = +((item.change / old) * 100).toFixed(2);
  }
  emit({ type: "stockTick", data: instruments });
}, 2000);

app.get("/api/stocks", (req, res) => res.json(instruments));

app.get("/api/status", (req, res) => res.json({ connected }));

app.get("/events", (req, res) => {
  res.setHeader("Content-Type", "text/event-stream");
  res.setHeader("Cache-Control", "no-cache");
  res.setHeader("Connection", "keep-alive");
  res.flushHeaders();
  clients.add(res);
  res.write(`data: ${JSON.stringify({ type: "agentStatus", connected })}\n\n`);
  req.on("close", () => clients.delete(res));
});

app.post("/api/join", (req, res) => {
  try {
    sendDA({ type: "joinChannel", channelId: req.body.channelId });
    res.json({ success: true, channelId: req.body.channelId });
  } catch (e) { res.status(503).json({ error: e.message }); }
});

app.post("/api/broadcast", (req, res) => {
  try {
    sendDA({ type: "broadcast", channelId: req.body.channelId, context: req.body.context });
    res.json({ success: true });
  } catch (e) { res.status(503).json({ error: e.message }); }
});

app.post("/api/intent", (req, res) => {
  try {
    sendDA({ type: "raiseIntent", intent: req.body.intent, context: req.body.context });
    res.json({ success: true });
  } catch (e) { res.status(503).json({ error: e.message }); }
});

app.post("/api/order", (req, res) => {
  const { symbol, quantity, side } = req.body || {};
  const stock = instruments.find(x => x.symbol === symbol);
  if (!stock || !Number.isInteger(quantity) || quantity < 1 || !["buy", "sell"].includes(side)) {
    return res.status(400).json({ error: "Valid symbol, positive integer quantity, and buy/sell side required" });
  }
  res.json({
    orderId: uuid(),
    symbol,
    quantity,
    side,
    executedPrice: stock.price,
    timestamp: new Date().toISOString(),
    status: "filled"
  });
});

app.listen(PORT, "0.0.0.0", () => console.log(`TradingApp HTTP: http://0.0.0.0:${PORT}`));
