const express = require("express");
const cors = require("cors");
const WebSocket = require("ws");
const path = require("path");

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

const PORT = 3002;
const DA = process.env.FDC3_DA_URL || "ws://127.0.0.1:8080";
const clients = new Set();
const positions = [
  { symbol: "AAPL", name: "Apple Inc.", quantity: 40, averageCost: 190, currentPrice: 225 },
  { symbol: "MSFT", name: "Microsoft", quantity: 20, averageCost: 420, currentPrice: 510 },
  { symbol: "NVDA", name: "NVIDIA", quantity: 30, averageCost: 140, currentPrice: 185 },
  { symbol: "AMZN", name: "Amazon", quantity: 15, averageCost: 205, currentPrice: 235 },
  { symbol: "TSLA", name: "Tesla", quantity: 10, averageCost: 320, currentPrice: 350 }
];

let da;
let connected = false;

function emit(event) {
  const data = `data: ${JSON.stringify(event)}\n\n`;
  for (const client of clients) client.write(data);
}

function connectDA() {
  da = new WebSocket(DA);
  da.on("open", () => {
    connected = true;
    da.send(JSON.stringify({ type: "register", appName: "PortfolioApp", intentHandlers: ["ViewInstrument"] }));
    emit({ type: "agentStatus", connected: true });
    console.log("PortfolioApp connected and registered with ViewInstrument handler");
  });
  da.on("message", raw => {
    try {
      const message = JSON.parse(raw.toString());
      if (message.type === "context" && message.context?.type === "fdc3.instrument") {
        emit(message);
      } else if (message.type === "intent" && message.intent === "ViewInstrument") {
        emit(message);
      }
    } catch (error) {
      console.error("PortfolioApp message error:", error.message);
    }
  });
  da.on("close", () => {
    connected = false;
    emit({ type: "agentStatus", connected: false });
    setTimeout(connectDA, 2000);
  });
  da.on("error", error => console.error("PortfolioApp WebSocket:", error.message));
}
connectDA();

app.get("/api/portfolio", (req, res) => {
  const enriched = positions.map(p => ({
    ...p,
    unrealizedPnL: +((p.currentPrice - p.averageCost) * p.quantity).toFixed(2)
  }));
  res.json({
    positions: enriched,
    totalValue: +enriched.reduce((s, p) => s + p.currentPrice * p.quantity, 0).toFixed(2),
    totalUnrealizedPnL: +enriched.reduce((s, p) => s + p.unrealizedPnL, 0).toFixed(2),
    asOf: new Date().toISOString()
  });
});

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
  if (!da || da.readyState !== WebSocket.OPEN) return res.status(503).json({ error: "Desktop Agent is not connected" });
  da.send(JSON.stringify({ type: "joinChannel", channelId: req.body.channelId }));
  res.json({ success: true, channelId: req.body.channelId });
});

app.listen(PORT, "0.0.0.0", () => console.log(`PortfolioApp HTTP: http://0.0.0.0:${PORT}`));
