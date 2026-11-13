class ReceiverApp {
  constructor() {
    this.listener = null;
    this.history = [];
    this.retryTimer = null;
  }

  init() {
    this.status = document.getElementById("listener-status");
    this.historyElement = document.getElementById("history");
    this.count = document.getElementById("count");
    document.getElementById("stop").addEventListener("click", () => this.stopListening());
    document.getElementById("clear").addEventListener("click", () => this.clearHistory());
    this.startListening();
  }

  startListening() {
    if (this.listener) return;
    if (!window.fdc3) {
      this.status.textContent = "Waiting for Desktop Agent; retrying…";
      this.retryTimer = setTimeout(() => this.startListening(), 500);
      return;
    }
    try {
      this.listener = window.fdc3.addContextListener(null, context => {
        console.log("Raw FDC3 context received:", context);
        this.renderContextCard(context, new Date().toISOString());
      });
      this.status.textContent = "Listening — context listener active";
    } catch (error) {
      this.status.textContent = `Listener error: ${error.message}`;
      this.retryTimer = setTimeout(() => this.startListening(), 500);
    }
  }

  stopListening() {
    if (this.retryTimer) clearTimeout(this.retryTimer);
    this.retryTimer = null;
    if (this.listener) this.listener.unsubscribe();
    this.listener = null;
    this.status.textContent = "Stopped — not receiving contexts";
  }

  renderContextCard(context, isoTimestamp) {
    const card = document.createElement("article");
    card.className = "card";
    const heading = document.createElement("h3");
    heading.textContent = context.name || "Unnamed instrument";
    card.appendChild(heading);
    const values = [
      ["Ticker", context.id?.ticker],
      ["ISIN", context.id?.ISIN],
      ["RIC", context.id?.RIC],
      ["MIC", context.id?.MIC],
      ["Context type", context.type],
      ["Received at", isoTimestamp]
    ];
    const dl = document.createElement("dl");
    for (const [label, value] of values) {
      const dt = document.createElement("dt");
      const dd = document.createElement("dd");
      dt.textContent = label;
      dd.textContent = value || "Not supplied";
      dl.append(dt, dd);
    }
    card.appendChild(dl);
    this.history.unshift({ context, timestamp: isoTimestamp });
    this.historyElement.prepend(card);
    this.count.textContent = `Received contexts: ${this.history.length}`;
  }

  clearHistory() {
    this.history = [];
    this.historyElement.replaceChildren();
    this.count.textContent = "Received contexts: 0";
  }
}
window.addEventListener("DOMContentLoaded", () => new ReceiverApp().init());
