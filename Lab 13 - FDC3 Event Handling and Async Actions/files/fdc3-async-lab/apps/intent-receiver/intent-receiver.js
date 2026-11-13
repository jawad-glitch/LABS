class IntentReceiverApp {
  constructor() {
    this.agent = window.fdc3DesktopAgent;
    this.listeners = new Map();
    this.delays = new Map();
    this.log = document.getElementById("log");
    this.controls = document.getElementById("listenerControls");
  }
  async registerIntentHandler(intentType, processingDelayMs) {
    if (this.listeners.has(intentType)) return this.listeners.get(intentType);
    this.delays.set(intentType, processingDelayMs);
    const listener = await this.agent.addIntentListener(intentType, async context => {
      await new Promise(resolve => setTimeout(resolve, this.delays.get(intentType) || 0));
      this.log.textContent += `\n${intentType} received: ${JSON.stringify(context)}`;
    });
    this.listeners.set(intentType, listener);
    this.renderControls();
    return listener;
  }
  unregisterIntentHandler(intentType) {
    const listener = this.listeners.get(intentType);
    if (listener) listener.unsubscribe();
    this.listeners.delete(intentType);
    this.renderControls();
  }
  getActiveListeners() { return this.listeners; }
  renderControls() {
    this.controls.innerHTML = "";
    ["ViewChart","ViewInstrument"].forEach(intent => {
      const button = document.createElement("button");
      button.textContent = this.listeners.has(intent) ? "Unsubscribe " + intent : "Subscribe " + intent;
      button.className = this.listeners.has(intent) ? "secondary" : "";
      button.onclick = async () => {
        if (this.listeners.has(intent)) this.unregisterIntentHandler(intent);
        else await this.registerIntentHandler(intent, Number(document.getElementById("delay").value));
      };
      this.controls.appendChild(button);
    });
  }
}
window.addEventListener("DOMContentLoaded", async () => {
  const agent = window.fdc3DesktopAgent = new FDC3DesktopAgent(); window.fdc3 = agent;
  await agent.registerApp("intent-receiver", window);
  const app = window.receiverApp = new IntentReceiverApp();
  document.getElementById("agentStatus").textContent = "Registered";
  document.getElementById("delay").oninput = event =>
    document.getElementById("delayValue").textContent = event.target.value;
  await app.registerIntentHandler("ViewChart", 500);
  await app.registerIntentHandler("ViewInstrument", 500);

  const feedListeners = [];
  document.getElementById("subscribeFeed").onclick = async () => {
    try {
      for (const channel of ["red","green","blue"]) await agent.joinChannel(channel);
      if (!feedListeners.length) {
        feedListeners.push(await agent.addContextListener("fdc3.instrument", context => {
          if (!context.marketData) return;
          const received = Date.now();
          const lag = Math.max(0, received - Date.parse(context.marketData.timestamp));
          const symbol = context.id.ticker;
          let card = document.getElementById("price-" + symbol);
          if (!card) {
            card = document.createElement("div");
            card.className = "card";
            card.id = "price-" + symbol;
            document.getElementById("prices").appendChild(card);
          }
          const change = Number(context.marketData.change);
          card.innerHTML = `<h3>${symbol}</h3><div class="price">${Number(context.marketData.price).toFixed(2)}</div><div class="${change >= 0 ? "positive" : "negative"}">Change: ${change.toFixed(2)}</div><small>Delivery lag: ${lag} ms</small>`;
        }));
      }
      app.log.textContent += "\nSubscribed to red, green and blue feed channels.";
    } catch (error) { app.log.textContent += "\nFeed subscription error: " + error.message; }
  };
  document.getElementById("unsubscribeFeed").onclick = async () => {
    feedListeners.forEach(listener => listener.unsubscribe());
    feedListeners.length = 0;
    for (const channel of ["red","green","blue"]) {
      if (agent.channels.has(channel)) await agent.joinChannel(channel);
    }
    await agent.leaveCurrentChannel();
    app.log.textContent += "\nFeed listener unsubscribed.";
  };
});
