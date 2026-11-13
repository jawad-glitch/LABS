class FDC3Client {
  constructor(url = "ws://localhost:4200") {
    this.ws = new WebSocket(url);
    this.pending = new Map();
    this.counter = 0;
    this.ready = new Promise((resolve, reject) => {
      this.ws.addEventListener("message", event => {
        const msg = JSON.parse(event.data);
        if (msg.event === "ready") { this.id = msg.id; resolve(msg); }
        if (msg.requestId && this.pending.has(msg.requestId)) {
          const p = this.pending.get(msg.requestId);
          this.pending.delete(msg.requestId);
          msg.error ? p.reject(new Error(msg.error)) : p.resolve(msg.result);
        }
        if (msg.event === "context" && this.onContext) this.onContext(msg.context);
        if (msg.event === "intent" && this.onIntent) this.onIntent(msg.intent, msg.context);
      });
      this.ws.addEventListener("error", reject);
    });
  }
  async call(action, data = {}) {
    await this.ready;
    const requestId = String(++this.counter);
    return new Promise((resolve, reject) => {
      this.pending.set(requestId, { resolve, reject });
      this.ws.send(JSON.stringify({ action, requestId, ...data }));
      setTimeout(() => {
        if (this.pending.has(requestId)) {
          this.pending.delete(requestId);
          reject(new Error("Desktop Agent request timed out"));
        }
      }, 5000);
    });
  }
  joinUserChannel(channel) { return this.call("joinChannel", { channel }); }
  broadcast(context) { return this.call("broadcast", { context }); }
  addContextListener(contextType, callback) {
    this.onContext = callback;
    return this.call("addContextListener", { contextType });
  }
  addIntentListener(intent, callback) {
    this.onIntent = (name, context) => { if (name === intent) callback(context); };
    return this.call("addIntentHandler", { intent });
  }
  raiseIntent(intent, context) { return this.call("raiseIntent", { intent, context }); }
  getInfo() { return this.call("getInfo"); }
}
window.FDC3Client = FDC3Client;
