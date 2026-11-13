const WebSocket = require("ws");

const APP_ID = "crm-receiver";
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
    send("addIntentListener", { intentName: "ViewPortfolio" });
  } else if (message.event === "channelJoined") {
    console.log(`[${APP_ID}] Joined channel ${message.channelId}`);
  } else if (message.event === "intentListenerAdded") {
    console.log(`[${APP_ID}] Listening for ${message.intentName}`);
  } else if (message.event === "contextReceived") {
    console.log(`[${APP_ID}] Context received: ${message.context.type}`);
  } else if (message.event === "intentReceived") {
    console.log(`[${APP_ID}] Intent received: ${message.intentName}`);
  } else if (message.event === "error") {
    console.error(`[${APP_ID}] Agent error: ${message.code} ${message.message}`);
  }
});

socket.on("error", error => {
  console.error(`[${APP_ID}] WebSocket error: ${error.message}`);
});
socket.on("close", () => console.log(`[${APP_ID}] Disconnected`));
