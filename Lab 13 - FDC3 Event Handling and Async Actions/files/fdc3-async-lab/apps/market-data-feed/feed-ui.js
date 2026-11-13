window.addEventListener("DOMContentLoaded", async () => {
  const agent = window.fdc3DesktopAgent = new FDC3DesktopAgent(); window.fdc3 = agent;
  await agent.registerApp("market-data-feed", window);
  let feed = null;
  const streams = [
    {symbol:"AAPL",channelId:"red"},
    {symbol:"MSFT",channelId:"green"},
    {symbol:"GOOGL",channelId:"blue"}
  ];
  document.getElementById("start").onclick = async () => {
    if (feed && feed.running) return;
    const interval = Math.max(100, Number(document.getElementById("interval").value) || 200);
    feed = new MarketDataFeed(streams, interval, 24680, agent);
    feed.onTick = context => {
      document.getElementById("ticks").textContent = feed.totalTicks;
      let card = document.getElementById("feed-" + context.id.ticker);
      if (!card) {
        card = document.createElement("div");
        card.className = "card";
        card.id = "feed-" + context.id.ticker;
        document.getElementById("prices").appendChild(card);
      }
      card.innerHTML = `<h3>${context.id.ticker}</h3><div class="price">${context.marketData.price.toFixed(2)}</div><small>${context.marketData.timestamp}</small>`;
    };
    try {
      await feed.start();
      document.getElementById("status").textContent = "Running";
    } catch (error) {
      document.getElementById("status").textContent = "Start failed: " + error.message;
    }
  };
  document.getElementById("stop").onclick = async () => {
    if (feed) await feed.stop();
    document.getElementById("status").textContent = "Stopped";
    document.getElementById("warnings").textContent =
      JSON.stringify(feed ? feed.getBackpressureLog() : [], null, 2);
  };
});
