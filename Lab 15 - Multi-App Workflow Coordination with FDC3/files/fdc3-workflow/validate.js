const { io } = require("socket.io-client");

const BASE = "http://127.0.0.1:3000";
const CHANNEL = "client-workflow";

function wait(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function once(socket, event, timeout = 2500) {
  return new Promise((resolve, reject) => {
    const timer = setTimeout(() => {
      socket.off(event, handler);
      reject(new Error(`Timed out waiting for ${event}`));
    }, timeout);
    function handler(payload) {
      clearTimeout(timer);
      resolve(payload);
    }
    socket.once(event, handler);
  });
}

async function main() {
  const clients = ["portfolio-test", "crm-test", "market-test"].map(name => {
    const socket = io(BASE, { transports: ["websocket"] });
    socket.on("connect_error", error => console.error(`${name} connection:`, error.message));
    return { name, socket };
  });

  try {
    for (const client of clients) {
      await once(client.socket, "connect");
      const registered = once(client.socket, "appRegistered");
      client.socket.emit("registerApp", { name: client.name, type: "test", version: "1.0" });
      const result = await registered;
      if (result.status !== "registered") throw new Error("Registration failed");

      const joined = once(client.socket, "channelJoined");
      client.socket.emit("joinChannel", { channelId: CHANNEL });
      await joined;
    }

    const portfolioContext = {
      type: "fdc3.portfolio",
      id: { portfolio: "P-001", client: "C-001" },
      portfolioId: "P-001",
      clientId: "C-001",
      name: "Tech Growth",
      holdings: [{ symbol: "AAPL" }, { symbol: "MSFT" }, { symbol: "GOOGL" }],
      source: "portfolio-test",
      timestamp: new Date().toISOString()
    };

    const crmReceived = once(clients[1].socket, "contextReceived");
    const marketReceived = once(clients[2].socket, "contextReceived");
    let senderEcho = false;
    const echoHandler = () => { senderEcho = true; };
    clients[0].socket.on("contextReceived", echoHandler);

    clients[0].socket.emit("broadcastContext", {
      channelId: CHANNEL,
      context: portfolioContext
    });

    const crmMessage = await crmReceived;
    const marketMessage = await marketReceived;
    await wait(250);
    clients[0].socket.off("contextReceived", echoHandler);

    if (crmMessage.context.type !== "fdc3.portfolio" ||
        crmMessage.context.clientId !== "C-001") {
      throw new Error("CRM did not receive the expected portfolio context");
    }
    if (marketMessage.context.holdings.length !== 3) {
      throw new Error("Market app did not receive the portfolio holdings");
    }
    if (senderEcho) throw new Error("Broker echoed context to its sender");

    const contactContext = {
      type: "fdc3.contact",
      id: { client: "C-002" },
      clientId: "C-002",
      name: "Sarah Johnson",
      source: "crm-test",
      timestamp: new Date().toISOString()
    };

    const portfolioReceived = once(clients[0].socket, "contextReceived");
    const marketContactReceived = once(clients[2].socket, "contextReceived");
    clients[1].socket.emit("broadcastContext", {
      channelId: CHANNEL,
      context: contactContext
    });

    const portfolioMessage = await portfolioReceived;
    await marketContactReceived;
    if (portfolioMessage.context.type !== "fdc3.contact") {
      throw new Error("Portfolio app did not receive contact context");
    }

    const snapshotResponse = await fetch(`${BASE}/api/channels`);
    const snapshot = await snapshotResponse.json();
    if (snapshot[CHANNEL]?.memberCount !== 3 ||
        snapshot[CHANNEL]?.contextType !== "fdc3.contact") {
      throw new Error("REST channel snapshot did not match expected state");
    }

    const rejectionResponse = await fetch(`${BASE}/api/test-broadcast`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        channelId: CHANNEL,
        context: { id: { portfolio: "P-001" } }
      })
    });
    const rejection = await rejectionResponse.json();
    if (rejection.error?.code !== "MISSING_TYPE") {
      throw new Error("Broker did not reject context missing its type");
    }

    console.log("PASS: Three clients registered and joined client-workflow.");
    console.log("PASS: Portfolio context reached CRM and Market Data.");
    console.log("PASS: Contact context reached Portfolio and Market Data.");
    console.log("PASS: Sender-excluded fan-out verified.");
    console.log("PASS: REST snapshot reports three channel members.");
    console.log("PASS: Missing context type rejected with MISSING_TYPE.");
  } finally {
    for (const client of clients) client.socket.disconnect();
  }
}

main().catch(error => {
  console.error("VALIDATION FAILED:", error.message);
  process.exitCode = 1;
});
