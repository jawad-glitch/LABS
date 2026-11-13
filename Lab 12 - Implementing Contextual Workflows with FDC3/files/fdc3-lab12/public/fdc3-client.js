class FDC3Client {
  constructor() {
    this.socket = null;
    this.appId = null;
    this.intents = [];
    this.contextTypes = [];
    this.contextHandlers = new Map();
    this.intentHandlers = new Map();
    this.contextQueue = [];
    this.intentQueue = [];
    this.pending = new Map();
    this.connected = false;
  }

  async connect(appId, intents = [], contextTypes = []) {
    this.appId = appId;
    this.intents = intents;
    this.contextTypes = contextTypes;

    const protocol = location.protocol === "https:" ? "wss:" : "ws:";
    const url = `${protocol}//${location.hostname}:3000`;

    return new Promise((resolve, reject) => {
      this.socket = new WebSocket(url);

      const startupTimeout = setTimeout(() => {
        reject(new Error("Broker connection or registration timed out"));
        this.socket.close();
      }, 10000);

      this.socket.onopen = () => {
        this.socket.send(JSON.stringify({
          messageType: "register",
          appId,
          intents,
          contextTypes
        }));
      };

      this.socket.onmessage = event => {
        let message;
        try {
          message = JSON.parse(event.data);
        } catch {
          console.error("Invalid broker message", event.data);
          return;
        }

        if (message.messageType === "registered") {
          this.connected = true;
          clearTimeout(startupTimeout);
          window.dispatchEvent(new CustomEvent("fdc3status", {
            detail: { connected: true }
          }));
          resolve();
          return;
        }

        if (message.messageType === "registerError") {
          clearTimeout(startupTimeout);
          reject(new Error(message.reason));
          return;
        }

        if (message.messageType === "contextUpdate") {
          this.dispatchContext(message.context);
          return;
        }

        if (message.messageType === "intentDelivery") {
          this.dispatchIntent(message.intent, message.context);
          return;
        }

        if (message.messageType === "broadcastAck") {
          const pending = this.pending.get(message.requestId || "broadcast");
          if (pending) {
            this.pending.delete(message.requestId || "broadcast");
            pending.resolve(message);
          }
          return;
        }

        if (message.messageType === "intentAck" ||
            message.messageType === "intentError") {
          const pending = this.pending.get(message.requestId);
          if (pending) {
            this.pending.delete(message.requestId);
            if (message.messageType === "intentAck") pending.resolve(message);
            else pending.reject(new Error(message.reason || "Intent routing failed"));
          } else if (message.messageType === "intentError") {
            console.error("FDC3 intent error:", message.reason);
          }
          return;
        }

        if (message.messageType === "protocolError") {
          console.error("FDC3 broker protocol error:", message.reason);
        }
      };

      this.socket.onclose = () => {
        this.connected = false;
        window.dispatchEvent(new CustomEvent("fdc3status", {
          detail: { connected: false }
        }));
      };

      this.socket.onerror = () => {
        this.connected = false;
        window.dispatchEvent(new CustomEvent("fdc3status", {
          detail: { connected: false }
        }));
        clearTimeout(startupTimeout);
        reject(new Error("WebSocket connection to broker failed"));
      };
    });
  }

  dispatchContext(context) {
    const handlers = this.contextHandlers.get(context?.type) || [];
    if (!handlers.length) {
      this.contextQueue.push(context);
      return;
    }
    handlers.forEach(handler => {
      try { handler(context); }
      catch (error) { console.error("Context listener failed:", error); }
    });
  }

  dispatchIntent(intent, context) {
    const handlers = this.intentHandlers.get(intent) || [];
    if (!handlers.length) {
      this.intentQueue.push({ intent, context });
      return;
    }
    handlers.forEach(handler => {
      try { handler(context); }
      catch (error) { console.error("Intent listener failed:", error); }
    });
  }

  async broadcast(context) {
    if (!this.connected || this.socket.readyState !== WebSocket.OPEN) {
      throw new Error("FDC3 client is disconnected");
    }
    if (!context || typeof context.type !== "string") {
      throw new Error("Context must contain a type field");
    }
    this.socket.send(JSON.stringify({
      messageType: "broadcast",
      context
    }));
  }

  async addContextListener(contextType, handler) {
    if (typeof handler !== "function") throw new Error("Handler must be a function");
    if (!this.contextHandlers.has(contextType)) this.contextHandlers.set(contextType, []);
    this.contextHandlers.get(contextType).push(handler);

    const remaining = [];
    this.contextQueue.forEach(context => {
      if (context.type === contextType) {
        try { handler(context); } catch (error) { console.error(error); }
      } else remaining.push(context);
    });
    this.contextQueue = remaining;
  }

  async addIntentListener(intent, handler) {
    if (typeof handler !== "function") throw new Error("Handler must be a function");
    if (!this.intentHandlers.has(intent)) this.intentHandlers.set(intent, []);
    this.intentHandlers.get(intent).push(handler);

    const remaining = [];
    this.intentQueue.forEach(item => {
      if (item.intent === intent) {
        try { handler(item.context); } catch (error) { console.error(error); }
      } else remaining.push(item);
    });
    this.intentQueue = remaining;
  }

  async raiseIntent(intent, context) {
    if (!this.connected || this.socket.readyState !== WebSocket.OPEN) {
      throw new Error("FDC3 client is disconnected");
    }
    const requestId = crypto.randomUUID();
    return new Promise((resolve, reject) => {
      this.pending.set(requestId, { resolve, reject });
      this.socket.send(JSON.stringify({
        messageType: "raiseIntent",
        requestId,
        intent,
        context
      }));
      setTimeout(() => {
        if (this.pending.has(requestId)) {
          this.pending.delete(requestId);
          reject(new Error("Intent acknowledgement timed out"));
        }
      }, 8000);
    });
  }
}

window.fdc3 = new FDC3Client();
