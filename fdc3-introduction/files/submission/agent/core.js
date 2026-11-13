class DesktopAgent {
  constructor() {
    this.sessions = new Map();
    this.handlers = new Map();
    this.sequence = 0;
  }
  connect(id, metadata = {}) {
    this.sessions.set(id, { metadata, channel: null, contexts: [], listeners: new Map() });
    return id;
  }
  disconnect(id) {
    this.sessions.delete(id);
    this.handlers.delete(id);
  }
  joinChannel(id, channel) {
    const s = this.sessions.get(id);
    if (!s || !channel) throw new Error("Invalid session or channel");
    s.channel = channel;
    return { channel };
  }
  addContextListener(id, type, callback) {
    const s = this.sessions.get(id);
    if (!s || typeof callback !== "function") throw new Error("Invalid listener");
    const token = "ctx-" + (++this.sequence);
    s.listeners.set(token, { type, callback });
    return token;
  }
  removeContextListener(id, token) {
    const s = this.sessions.get(id);
    return !!s && s.listeners.delete(token);
  }
  broadcast(id, context) {
    if (!context || typeof context !== "object" || typeof context.type !== "string" || !context.type.includes(".")) {
      throw new Error("Invalid FDC3 context");
    }
    const sender = this.sessions.get(id);
    if (!sender) throw new Error("Unknown session");
    const delivered = [];
    for (const [targetId, target] of this.sessions) {
      if (targetId === id) continue;
      if (sender.channel && target.channel !== sender.channel) continue;
      if (!sender.channel && target.channel) continue;
      for (const listener of target.listeners.values()) {
        if (listener.type === context.type || listener.type === "*") {
          listener.callback(context);
          delivered.push(targetId);
        }
      }
    }
    return delivered;
  }
  addIntentHandler(id, intent, callback) {
    if (!this.sessions.has(id) || typeof callback !== "function") throw new Error("Invalid intent handler");
    if (!this.handlers.has(intent)) this.handlers.set(intent, []);
    const entry = { id, callback };
    this.handlers.get(intent).push(entry);
    return () => {
      const list = this.handlers.get(intent) || [];
      this.handlers.set(intent, list.filter(x => x !== entry));
    };
  }
  raiseIntent(id, intent, context) {
    if (!this.sessions.has(id)) throw new Error("Unknown session");
    const list = this.handlers.get(intent) || [];
    const target = list.find(x => x.id !== id);
    if (!target) return { source: null, intent, status: "unresolved" };
    const result = target.callback(context || {});
    return { source: target.id, intent, status: "resolved", result };
  }
  getInfo(id) {
    const s = this.sessions.get(id);
    if (!s) return null;
    return { appId: id, ...s.metadata };
  }
}
module.exports = { DesktopAgent };
