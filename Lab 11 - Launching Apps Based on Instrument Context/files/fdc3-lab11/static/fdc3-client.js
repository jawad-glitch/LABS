class FDC3Client {
  constructor(appId, wsUrl) {
    this.appId = appId;
    this.wsUrl = wsUrl;
    this.ws = null;
    this.channelId = "red";
    this.pending = new Map();
    this.contextHandlers = [];
    this.intentHandlers = [];
  }

  connect(channelId) {
    this.channelId = channelId || "red";
    return new Promise((resolve, reject) => {
      this.ws = new WebSocket(this.wsUrl);
      this.ws.onopen = () => {
        this.send("joinChannel", { channelId: this.channelId })
          .then(resolve).catch(reject);
      };
      this.ws.onerror = () => reject(new Error("WebSocket connection failed"));
      this.ws.onmessage = event => {
        const message = JSON.parse(event.data);

        if (message.type === "ack") {
          const pending = this.pending.get(message.messageId);
          if (pending) {
            this.pending.delete(message.messageId);
            if (message.status === "ok") {
              this.processLaunches(message.reason);
              pending.resolve(message);
            } else {
              pending.reject(new Error(message.reason || "Agent rejected message"));
            }
          }
        }

        if (message.type === "contextDelivery") {
          this.contextHandlers.forEach(fn =>
            fn(message.context, message.sourceAppId)
          );
        }

        if (message.type === "intentDelivery") {
          this.intentHandlers.forEach(fn =>
            fn(message.intent, message.context, message.sourceAppId)
          );
        }
      };
    });
  }

  processLaunches(reason) {
    if (!reason) return;
    try {
      const data = JSON.parse(reason);
      (data.launches || []).forEach(item => {
        const url = new URL(item.url, window.location.origin);
        window.open(url.href, "_blank", "noopener");
      });
    } catch (error) {
      console.warn("Could not process app launch instructions:", error);
    }
  }

  send(type, fields = {}) {
    return new Promise((resolve, reject) => {
      if (!this.ws || this.ws.readyState !== WebSocket.OPEN) {
        return reject(new Error("WebSocket is not connected"));
      }
      const messageId = crypto.randomUUID();
      this.pending.set(messageId, { resolve, reject });
      this.ws.send(JSON.stringify({
        type, messageId, appId: this.appId, ...fields
      }));
      setTimeout(() => {
        if (this.pending.has(messageId)) {
          this.pending.delete(messageId);
          reject(new Error("Desktop Agent acknowledgement timed out"));
        }
      }, 8000);
    });
  }

  broadcast(context) {
    return this.send("broadcast", { channelId: this.channelId, context });
  }

  raiseIntent(intent, context) {
    return this.send("raiseIntent", { intent, context });
  }

  onContext(handler) {
    this.contextHandlers.push(handler);
    return () => {
      this.contextHandlers = this.contextHandlers.filter(fn => fn !== handler);
    };
  }

  onIntent(handler) {
    this.intentHandlers.push(handler);
    return () => {
      this.intentHandlers = this.intentHandlers.filter(fn => fn !== handler);
    };
  }
}

window.FDC3Client = FDC3Client;
