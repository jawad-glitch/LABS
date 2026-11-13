(function (root) {
  class FDC3DesktopAgent {
    constructor() {
      this.appId = "unregistered-" + Math.random().toString(36).slice(2);
      this.windowRef = null;
      this.intentListeners = new Map();
      this.contextListeners = new Set();
      this.channels = new Set();
      this.currentChannel = null;
      this.pending = new Map();
      this.channelNames = {
        red: { name: "Red Channel", color: "#e74c3c" },
        green: { name: "Green Channel", color: "#27ae60" },
        blue: { name: "Blue Channel", color: "#3498db" }
      };
      this.bus = typeof window !== "undefined" && "BroadcastChannel" in window
        ? new BroadcastChannel("fdc3-async-lab-v1") : null;

      if (this.bus) this.bus.onmessage = event => this._receive(event.data);
    }

    async registerApp(appId, windowRef) {
      if (!appId || typeof appId !== "string") throw new Error("A valid appId is required");
      this.appId = appId;
      this.windowRef = windowRef || null;
    }

    _receive(message) {
      if (!message || message.from === this.appId) return;

      if (message.kind === "intent") {
        if (message.target && message.target !== this.appId) return;
        const listeners = this.intentListeners.get(message.intent) || [];
        if (!listeners.length) return;

        listeners.forEach(entry => {
          try {
            entry.handler(message.context);
            this.bus.postMessage({
              kind: "intentAck", requestId: message.requestId,
              from: this.appId, intent: message.intent
            });
          } catch (error) {
            this.bus.postMessage({
              kind: "intentError", requestId: message.requestId,
              from: this.appId, message: String(error.message || error)
            });
          }
        });
      }

      if (message.kind === "intentAck" || message.kind === "intentError") {
        const pending = this.pending.get(message.requestId);
        if (pending) {
          if (message.kind === "intentAck") pending.resolve({
            source: message.from, data: pending.context, version: "2.0"
          });
          else pending.reject({
            type: "ResolveError", message: message.message || "Intent handler failed"
          });
          this.pending.delete(message.requestId);
        }
      }

      if (message.kind === "context") {
        if (!this.channels.has(message.channelId)) return;
        this.contextListeners.forEach(entry => {
          if (entry.contextType === null || entry.contextType === message.context.type) {
            try { Promise.resolve(entry.handler(message.context)).catch(console.error); }
            catch (error) { console.error("Context listener error:", error); }
          }
        });
      }
    }

    async raiseIntent(intent, context, target) {
      if (!intent || !context || typeof context.type !== "string") {
        throw { type: "ResolveError", message: "Intent and valid FDC3 context are required" };
      }
      await new Promise(resolve => setTimeout(resolve, 150 + Math.floor(Math.random() * 651)));
      const requestId = this.appId + "-" + Date.now() + "-" + Math.random().toString(36).slice(2);
      const local = this.intentListeners.get(intent) || [];
      const eligible = local.filter(entry => !target || entry.appId === target);

      if (eligible.length) {
        eligible.forEach(entry => entry.handler(context));
        return { source: this.appId, data: context, version: "2.0" };
      }

      if (!this.bus) {
        throw { type: "ResolveError", message: "No handler registered for " + intent };
      }

      return new Promise((resolve, reject) => {
        const timeout = setTimeout(() => {
          this.pending.delete(requestId);
          reject({ type: "ResolveError", message: "No handler registered for " + intent });
        }, 1400);

        this.pending.set(requestId, {
          context,
          resolve: result => { clearTimeout(timeout); resolve(result); },
          reject: error => { clearTimeout(timeout); reject(error); }
        });

        this.bus.postMessage({
          kind: "intent", requestId, from: this.appId,
          intent, context, target: target || null
        });
      });
    }

    async addIntentListener(intent, handler) {
      if (typeof handler !== "function") throw new TypeError("Handler must be a function");
      const entry = { handler, appId: this.appId };
      if (!this.intentListeners.has(intent)) this.intentListeners.set(intent, []);
      this.intentListeners.get(intent).push(entry);
      let active = true;
      return { unsubscribe: () => {
        if (!active) return;
        active = false;
        const list = this.intentListeners.get(intent) || [];
        const next = list.filter(item => item !== entry);
        if (next.length) this.intentListeners.set(intent, next);
        else this.intentListeners.delete(intent);
      }};
    }

    async addContextListener(contextType, handler) {
      if (contextType !== null && typeof contextType !== "string") {
        throw new TypeError("contextType must be a string or null");
      }
      if (typeof handler !== "function") throw new TypeError("Handler must be a function");
      const entry = { contextType, handler };
      this.contextListeners.add(entry);
      let active = true;
      return { unsubscribe: () => {
        if (active) this.contextListeners.delete(entry);
        active = false;
      }};
    }

    async broadcast(context) {
      if (!this.currentChannel) return;
      const channelId = this.currentChannel.id;
      const jobs = [];
      this.contextListeners.forEach(entry => {
        if (this.channels.has(channelId) &&
            (entry.contextType === null || entry.contextType === context.type)) {
          jobs.push(Promise.resolve().then(() => entry.handler(context)));
        }
      });
      if (this.bus) this.bus.postMessage({
        kind: "context", from: this.appId, channelId, context
      });
      await Promise.all(jobs);
    }

    async joinChannel(channelId) {
      const metadata = this.channelNames[channelId];
      if (!metadata) throw { type: "ChannelError", message: "Unknown channel: " + channelId };
      this.channels.add(channelId);
      this.currentChannel = {
        id: channelId, type: "system",
        displayMetadata: { name: metadata.name, color: metadata.color }
      };
      return this.currentChannel;
    }

    async getCurrentChannel() { return this.currentChannel; }

    async leaveCurrentChannel() {
      if (this.currentChannel) this.channels.delete(this.currentChannel.id);
      this.currentChannel = null;
    }
  }

  root.FDC3DesktopAgent = FDC3DesktopAgent;
  if (typeof module !== "undefined" && module.exports) module.exports = FDC3DesktopAgent;
})(typeof window !== "undefined" ? window : globalThis);
