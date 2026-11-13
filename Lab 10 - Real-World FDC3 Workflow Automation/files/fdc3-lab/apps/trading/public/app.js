async function refresh() {
  const status = document.getElementById("status");
  const root = document.getElementById("items");

  try {
    const response = await fetch("/api/intent-log");
    if (!response.ok) throw new Error("HTTP " + response.status);
    const entries = await response.json();

    root.replaceChildren();
    status.textContent = entries.length
      ? "Received " + entries.length + " intent(s)"
      : "Waiting for incoming intents...";

    for (const entry of entries) {
      const card = document.createElement("section");
      card.className = "card";

      const title = document.createElement("h2");
      title.textContent = entry.intent;
      card.appendChild(title);

      const type = document.createElement("span");
      type.className = "tag";
      type.textContent = entry.context.type;
      card.appendChild(type);

      const context = entry.context;
      const details = document.createElement("p");

      if (entry.intent === "ViewContact") {
        details.textContent =
          "Name: " + context.name +
          " | Email: " + context.id.email;
      } else {
        details.textContent =
          "Instrument: " + context.name +
          " | Ticker: " + context.id.ticker;
      }
      card.appendChild(details);

      if (entry.intent === "ViewInstrument") {
        const market = document.createElement("p");
        market.className = "price";

        if (entry.marketData) {
          const change = entry.marketData.change;
          market.textContent = "Price: " + entry.marketData.price.toFixed(2) +
            " | Change: " + (change > 0 ? "+" : "") + change.toFixed(2);
        } else {
          market.textContent = "Price unavailable";
        }
        card.appendChild(market);
      }

      const timestamp = document.createElement("small");
      timestamp.textContent = "Received: " + entry.timestamp;
      card.appendChild(timestamp);
      root.appendChild(card);
    }
  } catch (error) {
    status.textContent = "Dashboard error: " + error.message;
  }
}

refresh();
setInterval(refresh, 2000);
