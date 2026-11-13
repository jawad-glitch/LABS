/* Lab 4 shared FDC3 agent. Cross-origin transport: local HTTP relay. */
class FDC3DesktopAgent {
  constructor() {
    this.relayUrl = "http://localhost:3003";
    this.listeners = new Set();
    this.current = new Map();
    this.lastEventId = 0;
    this.polling = false;
    this.poll();
    this.timer = setInterval(() => this.poll(), 300);
  }

  async broadcast(context) {
    if (!context || typeof context.type !== "string" || !context.type.trim()) {
      throw new TypeError("context.type must be a non-empty string");
    }
    const response = await fetch(`${this.relayUrl}/broadcast`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(context)
    });
    if (!response.ok) throw new Error(`Desktop Agent relay rejected broadcast (${response.status})`);
  }

  addContextListener(contextType, handler) {
    if (contextType !== null && typeof contextType !== "string") {
      throw new TypeError("contextType must be a string or null");
    }
    if (typeof handler !== "function") throw new TypeError("handler must be a function");
    const entry = { contextType, handler, active: true };
    this.listeners.add(entry);
    return {
      unsubscribe: () => {
        entry.active = false;
        this.listeners.delete(entry);
      }
    };
  }

  async getCurrentContext(contextType) {
    if (contextType === null) {
      const values = Array.from(this.current.values());
      return values.length ? values[values.length - 1] : null;
    }
    return this.current.get(contextType) || null;
  }

  async poll() {
    if (this.polling) return;
    this.polling = true;
    try {
      const response = await fetch(`${this.relayUrl}/events?since=${this.lastEventId}`, {
        cache: "no-store"
      });
      if (!response.ok) throw new Error(`Relay returned ${response.status}`);
      const events = await response.json();
      for (const event of events) {
        this.lastEventId = Math.max(this.lastEventId, event.id);
        const context = event.context;
        this.current.set(context.type, context);
        for (const listener of Array.from(this.listeners)) {
          if (listener.active &&
              (listener.contextType === null || listener.contextType === context.type)) {
            try { listener.handler(context); }
            catch (error) { console.error("FDC3 context listener error:", error); }
          }
        }
      }
    } catch (error) {
      if (!this._reportedRelayError) {
        console.warn("FDC3 relay is not available yet:", error.message);
        this._reportedRelayError = true;
      }
    } finally {
      this.polling = false;
    }
  }
}
window.fdc3 = new FDC3DesktopAgent();
