const WebSocket = require("ws");
const crypto = require("crypto");

const URL = "ws://127.0.0.1:3001";

function connect(appId) {
  return new Promise((resolve, reject) => {
    const ws = new WebSocket(URL);
    const pending = new Map();
    const received = [];

    const timer = setTimeout(() => reject(new Error("Connection timeout: " + appId)), 8000);

    ws.on("open", async () => {
      clearTimeout(timer);
      ws.on("message", (raw) => {
        let message;
        try { message = JSON.parse(raw.toString()); } catch { return; }

        if (message.msgId && pending.has(message.msgId)) {
          const item = pending.get(message.msgId);
          pending.delete(message.msgId);
          message.ok ? item.resolve(message.data || {}) :
            item.reject(new Error(message.error || "Request failed"));
        } else if (message.event === "contextReceived") {
          received.push(message);
        }
      });

      const client = {
        ws, appId, received,
        request(action, payload = {}) {
          return new Promise((res, rej) => {
            const msgId = crypto.randomUUID();
            pending.set(msgId, { resolve: res, reject: rej });
            ws.send(JSON.stringify({ msgId, action, payload }));
            setTimeout(() => {
              if (pending.has(msgId)) {
                pending.delete(msgId);
                rej(new Error("Request timeout: " + action));
              }
            }, 5000);
          });
        }
      };

      try {
        await client.request("register", { appId });
        resolve(client);
      } catch (error) { reject(error); }
    });

    ws.on("error", reject);
  });
}

const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

async function run() {
  const clients = [];
  try {
    const trading = await connect("trading-app");
    clients.push(trading);
    const analytics = await connect("analytics-app");
    clients.push(analytics);
    const eavesdropper = await connect("eavesdropper-app");
    clients.push(eavesdropper);

    const created = await trading.request("createPrivateChannel");
    const channelId = created.channelId;

    await trading.request("addParticipant", {
      channelId, targetAppId: "analytics-app"
    });

    await analytics.request("joinPrivateChannel", { channelId });

    await analytics.request("addContextListener", {
      channelId, contextType: "fdc3.trade"
    });

    await eavesdropper.request("addContextListener", {
      channelId, contextType: null
    });

    for (let i = 1; i <= 5; i++) {
      await trading.request("broadcast", {
        channelId,
        context: {
          type: "fdc3.trade",
          id: { ticker: "TEST" + i },
          price: 100 + i,
          quantity: i * 10,
          side: "BUY",
          timestamp: new Date().toISOString(),
          source: "trading-app",
          testMessage: i
        }
      });
    }

    await sleep(2000);

    const analyticsCount = analytics.received.filter(
      item => item.payload?.context?.type === "fdc3.trade"
    ).length;
    const eavesdropperCount = eavesdropper.received.length;
    const tradingCount = trading.received.length;

    const results = [
      ["analytics-app received exactly 5 trade contexts", 5, analyticsCount],
      ["eavesdropper-app received exactly 0 contexts", 0, eavesdropperCount],
      ["trading-app received exactly 0 contexts (sender exclusion)", 0, tradingCount]
    ];

    let failed = false;
    for (const [label, expected, actual] of results) {
      const pass = expected === actual;
      console.log(`${pass ? "PASS" : "FAIL"}: ${label} (expected ${expected}, got ${actual})`);
      if (!pass) failed = true;
    }

    for (const client of clients) client.ws.close();
    process.exitCode = failed ? 1 : 0;
  } catch (error) {
    console.error("Isolation test error:", error.message);
    for (const client of clients) {
      try { client.ws.close(); } catch {}
    }
    process.exitCode = 1;
  }
}

run();
