const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const WebSocket = require("ws");
const crypto = require("crypto");

const app = express();
app.use(cors());
app.use(bodyParser.json({ limit: "1mb" }));

const quotes = {
  AAPL: { symbol: "AAPL", price: 150.00, change: 1.25, volume: 52000000 },
  MSFT: { symbol: "MSFT", price: 420.00, change: 2.10, volume: 23000000 },
  GOOGL: { symbol: "GOOGL", price: 175.00, change: -0.65, volume: 18000000 },
  AMZN: { symbol: "AMZN", price: 185.00, change: 0.85, volume: 31000000 },
  TSLA: { symbol: "TSLA", price: 240.00, change: -1.40, volume: 41000000 }
};

let portfolio = [
  { symbol: "AAPL", quantity: 25, avgPrice: 145.00 }
];
const trades = [];

function validSymbol(value) {
  return typeof value === "string" && /^[A-Za-z0-9.-]{1,15}$/.test(value);
}

function jsonError(res, status, message) {
  return res.status(status).json({ success: false, message });
}

app.get("/health", (req, res) => {
  res.json({ status: "ok", service: "fdc3-rest-api" });
});

app.get("/api/market", (req, res) => res.json(quotes));

app.get("/api/market/:symbol", (req, res) => {
  const symbol = req.params.symbol.toUpperCase();
  if (!quotes[symbol]) return jsonError(res, 404, "Symbol not found");
  res.json(quotes[symbol]);
});

app.get("/api/portfolio", (req, res) => res.json(portfolio));

app.post("/api/portfolio", (req, res) => {
  const positions = req.body && req.body.portfolio;
  if (!Array.isArray(positions)) return jsonError(res, 400, "Expected a portfolio array");
  for (const p of positions) {
    if (!p || !validSymbol(p.symbol) || !Number.isFinite(Number(p.quantity)) ||
        !Number.isFinite(Number(p.avgPrice)) || Number(p.quantity) < 0 || Number(p.avgPrice) < 0) {
      return jsonError(res, 400, "Invalid portfolio position");
    }
  }
  portfolio = positions.map(p => ({
    symbol: p.symbol.toUpperCase(),
    quantity: Number(p.quantity),
    avgPrice: Number(p.avgPrice)
  }));
  res.json({ success: true, portfolio });
});

app.post("/api/trade", (req, res) => {
  const body = req.body || {};
  const symbol = typeof body.symbol === "string" ? body.symbol.toUpperCase() : "";
  const side = body.side;
  const quantity = Number(body.quantity);
  const suppliedPrice = body.price === undefined ? undefined : Number(body.price);

  if (!validSymbol(symbol) || !["buy", "sell"].includes(side) ||
      !Number.isFinite(quantity) || quantity <= 0 ||
      (suppliedPrice !== undefined && (!Number.isFinite(suppliedPrice) || suppliedPrice <= 0))) {
    return jsonError(res, 400, "Provide a valid symbol, buy/sell side and positive quantity/price");
  }

  const quote = quotes[symbol];
  if (!quote) return jsonError(res, 404, "Symbol not found in market data");

  const trade = {
    id: crypto.randomUUID(),
    symbol,
    side,
    quantity,
    price: suppliedPrice === undefined ? quote.price : suppliedPrice,
    timestamp: new Date().toISOString(),
    status: "executed"
  };

  trades.push(trade);
  const existing = portfolio.find(p => p.symbol === symbol);
  if (side === "buy") {
    if (existing) {
      const total = existing.quantity + quantity;
      existing.avgPrice = ((existing.quantity * existing.avgPrice) + (quantity * trade.price)) / total;
      existing.quantity = total;
    } else {
      portfolio.push({ symbol, quantity, avgPrice: trade.price });
    }
  } else if (existing) {
    existing.quantity = Math.max(0, existing.quantity - quantity);
  }
  res.status(201).json(trade);
});

app.get("/api/trades", (req, res) => res.json(trades));

app.post("/api/fdc3/context", (req, res) => {
  const context = req.body && req.body.context ? req.body.context : req.body;
  if (!context || typeof context.type !== "string" || typeof context.name !== "string") {
    return jsonError(res, 400, "Expected an FDC3 context with type and name");
  }
  const symbol = context.id && context.id.ticker
    ? String(context.id.ticker).toUpperCase()
    : context.name.toUpperCase();
  res.json({
    success: true,
    data: quotes[symbol] || null,
    message: "FDC3 context received"
  });
});

app.post("/api/fdc3/intent", (req, res) => {
  const body = req.body || {};
  const intent = body.intent;
  const context = body.context;
  if (typeof intent !== "string" || !context || typeof context.name !== "string") {
    return jsonError(res, 400, "Expected intent and context");
  }
  const symbol = context.id && context.id.ticker
    ? String(context.id.ticker).toUpperCase()
    : context.name.toUpperCase();

  if (intent === "ViewQuote") {
    if (!quotes[symbol]) return jsonError(res, 404, "Quote not found");
    return res.json({ success: true, data: quotes[symbol], intent });
  }
  if (intent === "StartTrade") {
    return res.json({
      success: true,
      data: {
        symbol,
        availableActions: ["buy", "sell"],
        currentPrice: quotes[symbol] ? quotes[symbol].price : undefined
      },
      intent
    });
  }
  return res.status(400).json({ success: false, data: {}, intent, message: "Unsupported intent" });
});

app.use((err, req, res, next) => {
  console.error("HTTP error:", err.message);
  if (res.headersSent) return next(err);
  res.status(400).json({ success: false, message: "Invalid request" });
});

const httpServer = app.listen(3001, "0.0.0.0", () => {
  console.log("REST API listening on http://0.0.0.0:3001");
});

const wss = new WebSocket.Server({ port: 8080, host: "0.0.0.0" });
wss.on("listening", () => console.log("Market WebSocket listening on ws://0.0.0.0:8080"));
wss.on("connection", socket => {
  console.log("WebSocket client connected");
  socket.send(JSON.stringify({ type: "marketData", data: quotes }));
  socket.on("error", err => console.error("WebSocket client error:", err.message));
});

const marketTimer = setInterval(() => {
  try {
    for (const quote of Object.values(quotes)) {
      const delta = (Math.random() - 0.5) * quote.price * 0.004;
      quote.price = Math.max(0.01, Number((quote.price + delta).toFixed(2)));
      quote.change = Number((quote.change + delta).toFixed(2));
      quote.volume += Math.floor(Math.random() * 10000);
    }
    const message = JSON.stringify({ type: "marketData", data: quotes });
    for (const client of wss.clients) {
      if (client.readyState === WebSocket.OPEN) client.send(message);
    }
  } catch (err) {
    console.error("Market broadcast interval error:", err.stack || err.message);
  }
}, 5000);

function shutdown() {
  clearInterval(marketTimer);
  wss.close();
  httpServer.close(() => process.exit(0));
  setTimeout(() => process.exit(0), 3000).unref();
}
process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);
