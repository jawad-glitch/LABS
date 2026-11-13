(function () {
  "use strict";

  class FDC3DesktopAgent {
    constructor() {
      this.base = window.location.protocol + "//" + window.location.hostname;
      this.api = this.base + ":3001";
      this.wsUrl = "ws://" + window.location.hostname + ":8080";
      this.appId = "fdc3-app-" + Math.random().toString(36).slice(2);
      this.channels = {};
      this.currentChannel = null;
      this.contextListeners = new Set();
      this.intentListeners = new Map();
      this.tabBus = new BroadcastChannel("fdc3-lab17");
      this.tabBus.onmessage = event => this.receiveCrossTab(event.data);

      const definitions = [
        ["red", "Red", "#e74c3c"],
        ["green", "Green", "#27ae60"],
        ["blue", "Blue", "#3498db"],
        ["yellow", "Yellow", "#d4ac0d"]
      ];
      definitions.forEach(([id, name, color]) => {
        this.channels[id] = {
          id, type: "system",
          displayMetadata: { name, color },
          contexts: new Map(),
          subscribers: new Set()
        };
      });
    }

    async open(appName, context) {
      if (context) await this.broadcast(context);
      return { source: appName || this.appId, version: "2.0" };
    }

    async findIntent(intent, context) {
      return { intent: { name: intent }, apps: [] };
    }

    async raiseIntent(intent, context, target) {
      const response = await fetch(this.api + "/api/fdc3/intent", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ intent, context, target })
      });
      const body = await response.json();
      if (!response.ok) throw new Error(body.message || "Intent request failed");
      this.tabBus.postMessage({
        kind: "intent", intent, context, target,
        source: this.appId, response: body
      });
      this.dispatchIntent(intent, context);
      return { source: this.appId, data: body, version: "2.0" };
    }

    async addIntentListener(intent, handler) {
      if (!this.intentListeners.has(intent)) this.intentListeners.set(intent, new Set());
      const handlers = this.intentListeners.get(intent);
      handlers.add(handler);
      return { unsubscribe: () => handlers.delete(handler) };
    }

    async broadcast(context) {
      if (!context || typeof context.type !== "string" || typeof context.name !== "string") {
        throw new Error("Invalid FDC3 context");
      }
      if (this.currentChannel) {
        const channel = this.channels[this.currentChannel];
        channel.contexts.set(context.type, context);
        channel.subscribers.forEach(fn => {
          try { fn(context); } catch (err) { console.error(err); }
        });
      }
      this.contextListeners.forEach(listener => {
        if (listener.type === null || listener.type === context.type) {
          try { listener.handler(context); } catch (err) { console.error(err); }
        }
      });
      this.tabBus.postMessage({ kind: "context", context, source: this.appId });

      try {
        const response = await fetch(this.api + "/api/fdc3/context", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ context })
        });
        if (!response.ok) console.warn("Context REST forwarding returned", response.status);
      } catch (err) {
        console.warn("Context REST forwarding failed; local broadcast was retained:", err.message);
      }
    }

    async addContextListener(contextType, handler) {
      const item = { type: contextType, handler };
      this.contextListeners.add(item);
      if (this.currentChannel && contextType) {
        const existing = this.channels[this.currentChannel].contexts.get(contextType);
        if (existing) handler(existing);
      }
      return { unsubscribe: () => this.contextListeners.delete(item) };
    }

    async getSystemChannels() {
      return Object.values(this.channels).map(c => ({
        id: c.id, type: c.type, displayMetadata: c.displayMetadata
      }));
    }

    async joinChannel(channelId) {
      const channel = this.channels[channelId];
      if (!channel) throw new Error("Unknown system channel: " + channelId);
      if (this.currentChannel) await this.leaveCurrentChannel();
      this.currentChannel = channelId;
      return {
        id: channel.id, type: channel.type, displayMetadata: channel.displayMetadata
      };
    }

    async getCurrentChannel() {
      if (!this.currentChannel) return null;
      const c = this.channels[this.currentChannel];
      return { id: c.id, type: c.type, displayMetadata: c.displayMetadata };
    }

    async leaveCurrentChannel() {
      this.currentChannel = null;
    }

    dispatchIntent(intent, context) {
      const handlers = this.intentListeners.get(intent);
      if (handlers) handlers.forEach(fn => {
        try { fn(context); } catch (err) { console.error(err); }
      });
    }

    receiveCrossTab(message) {
      if (!message || message.source === this.appId) return;
      if (message.kind === "context") {
        const context = message.context;
        if (!context) return;
        if (this.currentChannel) {
          const channel = this.channels[this.currentChannel];
          channel.contexts.set(context.type, context);
          channel.subscribers.forEach(fn => {
            try { fn(context); } catch (err) { console.error(err); }
          });
        }
        this.contextListeners.forEach(listener => {
          if (listener.type === null || listener.type === context.type) {
            try { listener.handler(context); } catch (err) { console.error(err); }
          }
        });
      } else if (message.kind === "intent") {
        this.dispatchIntent(message.intent, message.context);
      }
    }
  }

  window.fdc3 = new FDC3DesktopAgent();
})();
