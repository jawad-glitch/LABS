const statusEl = document.getElementById("status");
const symbolEl = document.getElementById("symbol");
const headlinesEl = document.getElementById("headlines");
const viewChartButton = document.getElementById("viewChart");
const messageEl = document.getElementById("message");

const news = {
  AAPL:["Apple shares watched ahead of product and earnings updates.",
        "Analysts assess demand trends across Apple's services business."],
  MSFT:["Microsoft cloud growth remains a focus for market participants.",
        "Investors monitor enterprise AI spending and software demand."],
  GOOGL:["Alphabet faces continued attention on advertising performance.",
         "Investors track cloud growth and AI product developments."],
  TSLA:["Tesla investors monitor delivery trends and vehicle pricing.",
        "Markets assess margins and the company's energy business."],
  AMZN:["Amazon retail demand and operating margins remain in focus.",
        "Investors follow AWS growth and cloud infrastructure spending."]
};

let currentContext = null;

window.addEventListener("fdc3status", event => {
  statusEl.textContent = event.detail.connected ? "Connected" : "Disconnected";
  statusEl.classList.toggle("online", event.detail.connected);
});

async function initApp() {
  await window.fdc3.connect("news-feed", ["ViewNews"], ["fdc3.instrument"]);

  await window.fdc3.addContextListener("fdc3.instrument", context => {
    currentContext = context;
    const ticker = context?.id?.ticker || "Unknown";
    symbolEl.textContent = `${ticker} — ${context.name || "Instrument"}`;
    const stories = news[ticker] || [
      `Market update: ${ticker} is on the instrument watchlist.`,
      `Latest market coverage for ${ticker} is not available in this mock feed.`
    ];
    headlinesEl.innerHTML = "";
    stories.forEach(headline => {
      const li = document.createElement("li");
      li.textContent = headline;
      headlinesEl.appendChild(li);
    });
    viewChartButton.disabled = false;
    messageEl.textContent = "Context received from the Desktop Agent.";
  });

  viewChartButton.addEventListener("click", async () => {
    if (!currentContext) return;
    try {
      const result = await window.fdc3.raiseIntent("ViewChart", currentContext);
      messageEl.textContent = "ViewChart intent routed to " + result.handlerAppId;
    } catch (error) {
      messageEl.textContent = "Intent failed: " + error.message;
    }
  });
}

initApp().catch(error => {
  statusEl.textContent = "Connection failed";
  console.error("News Feed initialization failed:", error);
});
