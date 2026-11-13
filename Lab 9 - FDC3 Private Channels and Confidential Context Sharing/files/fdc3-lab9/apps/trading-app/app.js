const $ = (id) => document.getElementById(id);
let channelId = null;

function log(value) {
  $("log").textContent += new Date().toLocaleTimeString() + " " +
    JSON.stringify(value) + "\n";
  $("log").scrollTop = $("log").scrollHeight;
}

$("create").onclick = async () => {
  try {
    const channel = await fdc3.createPrivateChannel();
    channelId = channel.id;
    $("channel").textContent = channelId;
    await channel.addContextListener(null, (context) => log(context));
    channel.addOnDisconnectListener(() => log({ event: "participant disconnected" }));
    log({ status: "Private channel created", channelId });
  } catch (e) { log({ error: e.message }); }
};

$("add").onclick = async () => {
  try {
    if (!channelId) throw new Error("Create a channel first");
    await fdc3.addParticipant(channelId, "analytics-app");
    log({ status: "analytics-app added to whitelist" });
  } catch (e) { log({ error: e.message }); }
};

$("trade").onsubmit = async (event) => {
  event.preventDefault();
  try {
    if (!channelId) throw new Error("Create a channel first");
    const context = {
      type: "fdc3.trade",
      id: { ticker: $("symbol").value.trim().toUpperCase() },
      price: Number($("price").value),
      quantity: Number($("quantity").value),
      side: $("side").value,
      timestamp: new Date().toISOString(),
      source: "trading-app"
    };
    await fdc3.broadcast(channelId, context);
    log({ status: "Trade broadcast sent", context });
  } catch (e) { log({ error: e.message }); }
};

$("strategy").onclick = async () => {
  try {
    if (!channelId) throw new Error("Create a channel first");
    const context = {
      type: "fdc3.confidential.strategy",
      name: "Institutional Momentum Strategy",
      classification: "RESTRICTED",
      parameters: {
        maxPositionUSD: 250000,
        riskLimitUSD: 12000,
        algorithmVersion: "2.1"
      },
      source: "trading-app"
    };
    await fdc3.broadcast(channelId, context);
    log({ status: "Confidential strategy broadcast sent", context });
  } catch (e) { log({ error: e.message }); }
};

window.addEventListener("fdc3-ready", () => log({ status: "Registered as trading-app" }));
