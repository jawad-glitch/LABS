const WebSocket = require("ws");

const APP_ID = "portfolio-broadcaster";
const CHANNEL = "client-workflow";
const socket = new WebSocket(process.env.AGENT_URL || "ws://127.0.0.1:4000");

function send(event, payload = {}) {
  if (socket.readyState === WebSocket.OPEN) {
    socket.send(JSON.stringify({ event, ...payload }));
  }
}

socket.on("open", () => {
  console.log(`[${APP_ID}] Connected to Desktop Agent`);
  send("registerApp", { appId: APP_ID });
});

socket.on("message", raw => {
  let message;
  try {
    message = JSON.parse(raw.toString());
  } catch {
    console.error(`[${APP_ID}] Invalid message from agent`);
    return;
  }

  if (message.event === "registered") {
    console.log(`[${APP_ID}] Registered`);
    send("joinChannel", { channelId: CHANNEL });
  } else if (message.event === "channelJoined") {
    console.log(`[${APP_ID}] Joined ${message.channelId}`);

    if (!globalThis.workflowStarted) {
      globalThis.workflowStarted = true;
      setTimeout(() => {
        const context = {
          type: "fdc3.portfolio",
          id: { portfolio: "P-001" },
          name: "Tech Growth",
          holdings: [
            { symbol: "AAPL", quantity: 1000 },
            { symbol: "MSFT", quantity: 800 }
          ],
          source: APP_ID,
          timestamp: new Date().toISOString()
        };

        send("broadcastContext", { channelId: CHANNEL, context });
        send("raiseIntent", {
          channelId: CHANNEL,
          intentName: "ViewPortfolio",
          context
        });

        // Deliberate fault: no connected app registers this intent.
        send("raiseIntent", {
          channelId: CHANNEL,
          intentName: "AlsoAlsoAlsoUnregisteredIntent",
          context: { portfolioId: "P-001" }
        });

        console.log(`[${APP_ID}] Sent context, valid intent, and deliberate invalid intent`);
      }, 2500);
    }
  } else if (message.event === "contextBroadcast") {
    console.log(`[${APP_ID}] Context broadcast; delivered to ${message.delivered} other app(s)`);
  } else if (message.event === "intentRouted") {
    console.log(`[${APP_ID}] Intent routed: ${message.intentName}`);
  } else if (message.event === "intentFailed") {
    console.log(`[${APP_ID}] Expected routing failure: ${message.intentName} (${message.code})`);
  } else if (message.event === "error") {
    console.error(`[${APP_ID}] Agent error: ${message.code} ${message.message}`);
  }
});

socket.on("error", error => {
  console.error(`[${APP_ID}] WebSocket error: ${error.message}`);
});
socket.on("close", () => console.log(`[${APP_ID}] Disconnected`));
