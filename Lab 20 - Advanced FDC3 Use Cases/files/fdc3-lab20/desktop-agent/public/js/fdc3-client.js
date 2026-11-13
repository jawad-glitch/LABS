class FDC3Client {
  constructor(agentUrl) {
    const host = window.location.hostname || 'localhost';
    this.agentUrl = agentUrl || `ws://${host}:9090`;
    this.appId = null;
    this.currentChannel = null;
    this.socket = null;
    this.contextListeners = new Map();
    this.intentListeners = new Map();
    this.pendingChannel = null;
    this.ready = false;
  }

  connect() {
    return new Promise((resolve, reject) => {
      this.socket = new WebSocket(this.agentUrl);

      const timeout = setTimeout(() => {
        reject(new Error('Desktop Agent connection timed out'));
      }, 10000);

      this.socket.addEventListener('open', () => {
        this.ready = true;
      });

      this.socket.addEventListener('message', event => {
        let message;
        try {
          message = JSON.parse(event.data);
        } catch (error) {
          console.error('Invalid agent message:', error);
          return;
        }

        if (message.type === 'connected') {
          this.appId = message.appId;
          clearTimeout(timeout);
          resolve(this);
        }

        this._onMessage(message);
      });

      this.socket.addEventListener('error', () => {
        clearTimeout(timeout);
        reject(new Error('WebSocket connection failed'));
      });

      this.socket.addEventListener('close', () => {
        this.ready = false;
        this.currentChannel = null;
      });
    });
  }

  _send(message) {
    if (!this.socket || this.socket.readyState !== WebSocket.OPEN) {
      throw new Error('Desktop Agent is not connected');
    }
    this.socket.send(JSON.stringify(message));
  }

  _onMessage(message) {
    if (message.type === 'channelJoined') {
      this.currentChannel = message.channelId;
      return;
    }

    if (message.type === 'context') {
      const handlers = this.contextListeners.get(message.context?.type) || [];
      handlers.slice().forEach(handler => {
        try { handler(message.context); }
        catch (error) { console.error(error); }
      });
      return;
    }

    if (message.type === 'intent') {
      const handler = this.intentListeners.get(message.intent);
      if (handler) {
        try { handler(message.context, message); }
        catch (error) { console.error(error); }
      }
      return;
    }

    if (message.type === 'error' || message.type === 'intentError') {
      console.warn('FDC3 agent:', message.error);
    }
  }

  joinChannel(channelId) {
    this._send({ type: 'joinChannel', channelId });
  }

  broadcast(context) {
    if (!this.currentChannel) throw new Error('Not on a channel');
    if (!context || typeof context.type !== 'string') {
      throw new Error('Invalid FDC3 context');
    }
    this._send({ type: 'broadcast', context });
  }

  addContextListener(contextType, handler) {
    const handlers = this.contextListeners.get(contextType) || [];
    handlers.push(handler);
    this.contextListeners.set(contextType, handlers);

    return {
      unsubscribe: () => {
        const current = this.contextListeners.get(contextType) || [];
        this.contextListeners.set(
          contextType,
          current.filter(item => item !== handler)
        );
      }
    };
  }

  raiseIntent(intent, context) {
    this._send({ type: 'raiseIntent', intent, context });
  }

  addIntentListener(intent, handler) {
    this.intentListeners.set(intent, handler);
    this._send({ type: 'addIntentListener', intent });

    return {
      unsubscribe: () => this.intentListeners.delete(intent)
    };
  }
}

window.FDC3Client = FDC3Client;
