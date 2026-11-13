class IntentSenderApp {
  constructor() {
    this.pending = 0;
    this.agent = window.fdc3DesktopAgent;
    this.log = document.getElementById("log");
    this.counter = document.getElementById("pending");
  }
  _changePending(delta) {
    this.pending = Math.max(0, this.pending + delta);
    this.counter.textContent = this.pending;
  }
  _context() {
    const raw = document.getElementById("context").value.trim();
    if (raw) return JSON.parse(raw);
    const ticker = document.getElementById("ticker").value.trim().toUpperCase();
    return {type:"fdc3.instrument",name:ticker,id:{ticker}};
  }
  async sendIntent(intentType, context, targetAppId) {
    this._changePending(1);
    const started = performance.now();
    try {
      const result = await this.agent.raiseIntent(intentType, context, targetAppId || undefined);
      const ms = (performance.now() - started).toFixed(0);
      this.log.textContent += `\n${intentType}: resolved by ${result.source} in ${ms} ms`;
      return result;
    } catch (error) {
      this.log.textContent += `\n${intentType}: ${error.type || "Error"} - ${error.message}`;
      throw error;
    } finally {
      this._changePending(-1);
    }
  }
  async sendBatch(intents) {
    return Promise.allSettled(intents.map(item =>
      this.sendIntent(item.intent, item.context, item.target)));
  }
  getPendingCount() { return this.pending; }
}
window.addEventListener("DOMContentLoaded", async () => {
  const agent = window.fdc3DesktopAgent = new FDC3DesktopAgent(); window.fdc3 = agent;
  await agent.registerApp("intent-sender", window);
  const app = window.senderApp = new IntentSenderApp();
  document.getElementById("agentStatus").textContent = "Registered";
  document.getElementById("send").onclick = async () => {
    try {
      await app.sendIntent(document.getElementById("intent").value, app._context(),
        document.getElementById("target").value.trim());
    } catch (_) {}
  };
  document.getElementById("batch").onclick = async () => {
    let context;
    try { context = app._context(); } catch (error) {
      app.log.textContent = "Invalid context JSON: " + error.message; return;
    }
    const target = document.getElementById("target").value.trim();
    const intents = ["ViewChart","ViewInstrument","ViewNews"].map(intent =>
      ({intent, context, target}));
    await app.sendBatch(intents);
    app.log.textContent += `\nBatch complete. Pending count: ${app.getPendingCount()}`;
  };
});
