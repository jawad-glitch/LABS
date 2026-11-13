const $ = (id) => document.getElementById(id);
let channel = null;
let tradeContexts = [];

function receive(context) {
  if (context.type === "fdc3.trade") {
    tradeContexts.push(context);
    const row = document.createElement("tr");
    [context.id?.ticker, context.price, context.quantity, context.timestamp].forEach(value => {
      const cell = document.createElement("td");
      cell.textContent = String(value ?? "");
      row.appendChild(cell);
    });
    $("trades").appendChild(row);
  } else if (context.type === "fdc3.confidential.strategy") {
    const item = document.createElement("p");
    const badge = document.createElement("span");
    badge.className = "restricted";
    badge.textContent = "RESTRICTED";
    item.append(badge, document.createTextNode(" " + context.name + " — " +
      JSON.stringify(context.parameters)));
    $("strategies").appendChild(item);
  } else {
    $("status").textContent = "Received: " + context.type;
  }
}

$("join").onclick = async () => {
  try {
    const id = $("channelId").value.trim();
    if (!id) throw new Error("Enter the channel ID");
    channel = await fdc3.joinPrivateChannel(id);
    await channel.addContextListener(null, receive);
    channel.addOnDisconnectListener(() => {
      $("status").textContent = "Channel participant disconnected";
    });
    $("status").textContent = "Joined private channel: " + id;
  } catch (e) { $("status").textContent = "Join failed: " + e.message; }
};

$("result").onclick = async () => {
  try {
    if (!channel) throw new Error("Join a channel first");
    const totalVolume = tradeContexts.reduce((sum, item) => sum + item.quantity, 0);
    const vwapNumerator = tradeContexts.reduce((sum, item) =>
      sum + item.price * item.quantity, 0);
    const context = {
      type: "fdc3.analytics.result",
      summary: "Analytics processed " + tradeContexts.length + " trades",
      metrics: {
        vwap: totalVolume ? Number((vwapNumerator / totalVolume).toFixed(4)) : 0,
        totalVolume,
        tradeCount: tradeContexts.length
      },
      source: "analytics-app",
      timestamp: new Date().toISOString()
    };
    await channel.broadcast(context);
    $("status").textContent = "Analytics result sent to Trading App";
  } catch (e) { $("status").textContent = e.message; }
};

$("disconnect").onclick = async () => {
  try {
    if (!channel) throw new Error("No active channel");
    await channel.disconnect();
    channel = null;
    tradeContexts = [];
    $("trades").replaceChildren();
    $("strategies").replaceChildren();
    $("status").textContent = "Disconnected; display cleared";
  } catch (e) { $("status").textContent = e.message; }
};

window.addEventListener("fdc3-ready", () => {
  $("status").textContent = "Registered as analytics-app";
});
