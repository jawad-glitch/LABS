import {
  makePortfolioContext,
  makeContactContext,
  makeInstrumentContext
} from "/fdc3-context-schema.js";

const CHANNEL = "client-workflow";

const PORTFOLIOS = [
  { id: "P-001", clientId: "C-001", name: "Tech Growth", value: 2450000, holdings: [
    { symbol: "AAPL", quantity: 1000, marketValue: 175000 },
    { symbol: "MSFT", quantity: 800, marketValue: 240000 },
    { symbol: "GOOGL", quantity: 500, marketValue: 125000 }
  ]},
  { id: "P-002", clientId: "C-002", name: "Conservative Income", value: 1850000, holdings: [
    { symbol: "JNJ", quantity: 2000, marketValue: 320000 },
    { symbol: "SPY", quantity: 500, marketValue: 200000 }
  ]},
  { id: "P-003", clientId: "C-003", name: "Balanced Growth", value: 3200000, holdings: [
    { symbol: "SPY", quantity: 5000, marketValue: 2000000 },
    { symbol: "QQQ", quantity: 2000, marketValue: 600000 }
  ]}
];

const CLIENTS = [
  { id: "C-001", name: "John Smith", email: "john.smith@example.com", segment: "High Net Worth" },
  { id: "C-002", name: "Sarah Johnson", email: "sarah.johnson@example.com", segment: "Mass Affluent" },
  { id: "C-003", name: "Michael Brown", email: "michael.brown@example.com", segment: "Institutional" }
];

const INSTRUMENTS = [
  { ticker: "AAPL", name: "Apple Inc.", exchange: "NASDAQ" },
  { ticker: "MSFT", name: "Microsoft Corp.", exchange: "NASDAQ" },
  { ticker: "GOOGL", name: "Alphabet Inc.", exchange: "NASDAQ" },
  { ticker: "JNJ", name: "Johnson & Johnson", exchange: "NYSE" },
  { ticker: "SPY", name: "SPDR S&P 500 ETF", exchange: "NYSE" },
  { ticker: "QQQ", name: "Invesco QQQ Trust", exchange: "NASDAQ" }
];

const appType = document.body.dataset.app;
const records = document.getElementById("records");
const received = document.getElementById("received");
const connection = document.getElementById("connection");
const lastType = document.getElementById("last-type");

function showContext(context) {
  lastType.textContent = context?.type || "None";
  received.textContent = JSON.stringify(context, null, 2);

  if (context?.type === "fdc3.portfolio") {
    if (appType === "crm") {
      document.querySelectorAll("[data-client]").forEach(row => {
        row.classList.toggle("highlight", row.dataset.client === context.clientId);
      });
    }
    if (appType === "market") {
      const symbols = new Set((context.holdings || []).map(item => item.symbol));
      document.querySelectorAll("[data-ticker]").forEach(row => {
        row.classList.toggle("highlight", symbols.has(row.dataset.ticker));
      });
    }
  }
}

function addRow(values, onClick, attributes = {}) {
  const row = document.createElement("tr");
  for (const value of values) {
    const cell = document.createElement("td");
    cell.textContent = String(value);
    row.appendChild(cell);
  }
  for (const [key, value] of Object.entries(attributes)) {
    row.dataset[key] = value;
  }
  row.addEventListener("click", onClick);
  records.appendChild(row);
  return row;
}

if (appType === "portfolio") {
  PORTFOLIOS.forEach(item => {
    addRow(
      [item.name, item.clientId, `$${item.value.toLocaleString("en-US")}`, item.holdings.map(h => h.symbol).join(", ")],
      () => socket.emit("broadcastContext", {
        channelId: CHANNEL,
        context: makePortfolioContext(item.id, item.clientId, item.name, item.holdings)
      })
    );
  });
} else if (appType === "crm") {
  CLIENTS.forEach(item => {
    addRow(
      [item.id, item.name, item.email, item.segment],
      () => socket.emit("broadcastContext", {
        channelId: CHANNEL,
        context: makeContactContext(item.id, item.name, item.email, item.segment)
      }),
      { client: item.id }
    );
  });
} else if (appType === "market") {
  INSTRUMENTS.forEach(item => {
    addRow(
      [item.ticker, item.name, item.exchange],
      () => socket.emit("broadcastContext", {
        channelId: CHANNEL,
        context: makeInstrumentContext(item.ticker, item.name, item.exchange)
      }),
      { ticker: item.ticker }
    );
  });
}

const socket = window.io({
  transports: ["websocket", "polling"],
  reconnection: true
});

socket.on("connect", () => {
  connection.textContent = "Connected";
  connection.className = "connected";
  socket.emit("registerApp", {
    name: `${appType}-app`,
    type: "web",
    version: "1.0.0"
  });
  socket.emit("joinChannel", { channelId: CHANNEL });
});

socket.on("disconnect", () => {
  connection.textContent = "Disconnected";
  connection.className = "disconnected";
});

socket.on("contextReceived", payload => {
  if (payload.channelId === CHANNEL && payload.context) {
    showContext(payload.context);
  }
});

socket.on("currentContext", payload => {
  if (payload.channelId === CHANNEL && payload.context) {
    showContext(payload.context);
  }
});

socket.on("fdc3Error", error => {
  received.textContent = `Broker error: ${error.code} - ${error.message}`;
  console.error("FDC3 broker error:", error);
});
