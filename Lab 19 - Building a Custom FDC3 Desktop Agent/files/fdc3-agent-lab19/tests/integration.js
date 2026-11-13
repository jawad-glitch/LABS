const WebSocket = require("ws");
const URL = "ws://127.0.0.1:3000";

function connect() {
  return new Promise((resolve, reject) => {
    const ws = new WebSocket(URL);
    const timer = setTimeout(() => reject(new Error("WebSocket connection timeout")), 3000);
    ws.once("open", () => { clearTimeout(timer); resolve(ws); });
    ws.once("error", reject);
  });
}

function waitFor(ws, predicate, timeout = 2000) {
  return new Promise((resolve, reject) => {
    const timer = setTimeout(() => {
      ws.off("message", listener);
      reject(new Error("Timed out waiting for expected WebSocket message"));
    }, timeout);

    function listener(raw) {
      let message;
      try { message = JSON.parse(raw.toString()); } catch { return; }
      if (!predicate(message)) return;
      clearTimeout(timer);
      ws.off("message", listener);
      resolve(message);
    }

    ws.on("message", listener);
  });
}

function send(ws, message) {
  ws.send(JSON.stringify(message));
}

async function register(ws, appId, intents) {
  const response = waitFor(ws, m => m.type === "registered");
  send(ws, { type: "register", appId, intents });
  return response;
}

async function join(ws, channelId) {
  const response = waitFor(ws, m => m.type === "channelJoined" && m.channelId === channelId);
  send(ws, { type: "joinChannel", channelId });
  return response;
}

async function run() {
  let app1, app2;
  try {
    app1 = await connect();
    app2 = await connect();

    await Promise.all([
      register(app1, "Lab19-Test-App1", []),
      register(app2, "Lab19-Test-App2", ["ViewChart"])
    ]);
    console.log("PASS: Both test applications registered");

    await join(app1, "blue");
    await join(app2, "red");

    let app2ContextCount = 0;
    app2.on("message", raw => {
      try {
        if (JSON.parse(raw.toString()).type === "context") app2ContextCount++;
      } catch {}
    });

    const context = {
      type: "fdc3.instrument",
      name: "Apple Inc.",
      id: { ticker: "AAPL" }
    };

    let completion = waitFor(app1, m => m.type === "broadcastComplete");
    send(app1, { type: "broadcastContext", channelId: "blue", context });
    const isolated = await completion;
    await new Promise(resolve => setTimeout(resolve, 300));

    if (isolated.recipientCount !== 0 || app2ContextCount !== 0) {
      throw new Error("Channel isolation failed: App 2 received a blue-channel context");
    }
    console.log("PASS: Blue-to-red broadcast isolated; recipient count 0");

    await join(app2, "blue");
    const started = Date.now();
    completion = waitFor(app1, m => m.type === "broadcastComplete");
    const deliveredContext = waitFor(app2, m => m.type === "context" && m.context?.id?.ticker === "AAPL");
    send(app1, { type: "broadcastContext", channelId: "blue", context });
    const [sameChannelResult, received] = await Promise.all([completion, deliveredContext]);
    const elapsed = Date.now() - started;

    if (sameChannelResult.recipientCount !== 1 || elapsed >= 500) {
      throw new Error(`Same-channel delivery failed: recipients=${sameChannelResult.recipientCount}, elapsed=${elapsed}ms`);
    }
    console.log(`PASS: Same-channel context delivered to App 2 in ${elapsed}ms`);

    const intentDelivery = waitFor(app2, m => m.type === "intent" && m.intent === "ViewChart");
    const intentResolution = waitFor(app1, m => m.type === "intentResolution" && m.intent === "ViewChart");
    send(app1, { type: "raiseIntent", intent: "ViewChart", context });
    const [intent, resolution] = await Promise.all([intentDelivery, intentResolution]);

    if (!resolution.success || resolution.delivered !== 1) {
      throw new Error("ViewChart intent was not routed to exactly one handler");
    }
    console.log("PASS: ViewChart delivered to registered handler");

    const closed = new Promise(resolve => app2.once("close", resolve));
    app2.close();
    await closed;

    const noHandler = waitFor(app1, m => m.type === "intentError" && m.intent === "ViewChart");
    send(app1, { type: "raiseIntent", intent: "ViewChart", context });
    const error = await noHandler;

    if (!error.message.includes("No connected application")) {
      throw new Error("Unexpected no-handler error response");
    }
    console.log("PASS: Disconnected handler removed; intentError returned");
    console.log("ALL AUTOMATED LAB 19 TESTS PASSED");
  } finally {
    if (app1 && app1.readyState !== WebSocket.CLOSED) app1.close();
    if (app2 && app2.readyState !== WebSocket.CLOSED) app2.close();
  }
}

run().catch(error => {
  console.error("TEST FAILED:", error.message);
  process.exitCode = 1;
});
