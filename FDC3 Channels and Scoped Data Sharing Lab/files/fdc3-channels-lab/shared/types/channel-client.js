(function (root) {
  class ChannelClient {
    constructor() {
      this.ws = null;
      this.pending = new Map();
      this.handlers = [];
      this.currentChannel = null;
      this.sequence = 0;
    }

    connect(url) {
      return new Promise((resolve, reject) => {
        this.ws = new WebSocket(url);
        this.ws.onopen = () => resolve();
        this.ws.onerror = () => reject(new Error('Could not connect to broker'));
        this.ws.onmessage = (event) => {
          const msg = JSON.parse(event.data);
          if (msg.event === 'context') {
            this.handlers.slice().forEach(fn => fn(msg.context, msg.channelId));
          }
          if (msg.requestId && this.pending.has(msg.requestId)) {
            const item = this.pending.get(msg.requestId);
            if (msg.event === 'error') {
              this.pending.delete(msg.requestId);
              item.reject(new Error(msg.message));
            } else if (item.events.includes(msg.event)) {
              this.pending.delete(msg.requestId);
              item.resolve(msg);
            }
          }
        };
        this.ws.onclose = () => {
          this.pending.forEach(p => p.reject(new Error('Broker connection closed')));
          this.pending.clear();
        };
      });
    }

    request(action, data = {}, events = []) {
      if (!this.ws || this.ws.readyState !== WebSocket.OPEN)
        return Promise.reject(new Error('Not connected to broker'));
      const requestId = `req-${++this.sequence}`;
      return new Promise((resolve, reject) => {
        this.pending.set(requestId, { resolve, reject, events });
        this.ws.send(JSON.stringify({ action, ...data, requestId }));
      });
    }

    async listChannels() {
      const r = await this.request('list_channels', {}, ['channel_list']);
      return r.channels || [];
    }

    async createChannel(channelId) {
      const r = await this.request('create_channel', { channelId }, ['channel_created']);
      return r.channels[0];
    }

    async joinChannel(channelId, contextType = null) {
      if (this.currentChannel) await this.leaveChannel();
      const r = await this.request('join', { channelId, contextType }, ['joined']);
      this.currentChannel = channelId;
      if (r.context) this.handlers.slice().forEach(fn => fn(r.context, channelId));
      return r.context || null;
    }

    async leaveChannel() {
      if (!this.currentChannel) return;
      const old = this.currentChannel;
      await this.request('leave', {}, ['left']);
      this.currentChannel = null;
    }

    async broadcast(context) {
      if (!this.currentChannel) throw new Error('Join a channel before broadcasting');
      await this.request('broadcast', { context }, ['broadcast']);
    }

    onContext(handler) {
      this.handlers.push(handler);
      return { unsubscribe: () => {
        this.handlers = this.handlers.filter(fn => fn !== handler);
      }};
    }

    disconnect() {
      if (this.ws) this.ws.close();
      this.currentChannel = null;
    }
  }

  root.ChannelClient = ChannelClient;
  if (typeof module !== 'undefined' && module.exports)
    module.exports = { ChannelClient };
})(typeof window !== 'undefined' ? window : globalThis);
