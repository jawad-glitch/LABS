const prices = {
  AAPL:{name:"Apple Inc.",price:228.35},
  MSFT:{name:"Microsoft Corporation",price:415.20},
  GOOGL:{name:"Alphabet Inc.",price:175.84},
  TSLA:{name:"Tesla Inc.",price:177.58},
  AMZN:{name:"Amazon.com Inc.",price:189.07}
};

const statusEl = document.getElementById("status");
const resultEl = document.getElementById("result");
let currentContext = null;

window.addEventListener("fdc3status", event => {
  statusEl.textContent = event.detail.connected ? "Connected" : "Disconnected";
  statusEl.classList.toggle("online", event.detail.connected);
});

async function initApp() {
  await window.fdc3.connect("stock-quote", ["ViewQuote"], ["fdc3.instrument"]);

  await window.fdc3.addIntentListener("ViewQuote", async context => {
    const ticker = context?.id?.ticker;
    if (ticker) {
      document.getElementById("ticker").value = ticker;
      await showQuote(ticker);
    }
  });

  document.getElementById("search").addEventListener("click", async () => {
    await showQuote(document.getElementById("ticker").value);
  });
}

async function showQuote(input) {
  const ticker = String(input || "").trim().toUpperCase();
  const quote = prices[ticker];

  if (!quote) {
    resultEl.textContent = "No mock quote available for " + ticker +
      ". Available: " + Object.keys(prices).join(", ");
    return;
  }

  currentContext = {
    type:"fdc3.instrument",
    name:quote.name,
    id:{ticker}
  };

  resultEl.textContent = `${quote.name} (${ticker})\nMock price: $${quote.price.toFixed(2)}\nBroadcasting instrument context…`;

  try {
    await window.fdc3.broadcast(currentContext);
    resultEl.textContent = `${quote.name} (${ticker})\nMock price: $${quote.price.toFixed(2)}\nContext broadcast sent successfully.`;
  } catch (error) {
    resultEl.textContent = "Broadcast failed: " + error.message;
  }
}

initApp().catch(error => {
  statusEl.textContent = "Connection failed";
  console.error("Stock Quote initialization failed:", error);
});
