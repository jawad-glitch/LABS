const express = require('express');
const http = require('http');
const { WebSocketServer, WebSocket } = require('ws');
const crypto = require('crypto');

class ChannelRegistry {
  constructor() { this.channels = new Map(); this.lastContexts = new Map(); }
  listChannels() { return [...this.channels.values()]; }
  getOrCreate(id, type, displayMetadata) {
    if (!this.channels.has(id)) {
      this.channels.set(id, { id, type, displayMetadata: displayMetadata || {} });
    }
    return this.channels.get(id);
  }
  getLastContext(id) { return this.lastContexts.get(id) || null; }
  setLastContext(id, context) { this.lastContexts.set(id, context); }
}

class ConnectionState {
  constructor(connectionId) {
    this.connectionId = connectionId;
    this.currentChannel = null;
    this.subscriptions = new Map();
  }
  getCurrentChannel() { return this.currentChannel; }
  setCurrentChannel(id) { this.currentChannel = id; }
  clearCurrentChannel() { this.currentChannel = null; }
  addSubscription(id, contextType) { this.subscriptions.set(id, contextType || null); }
  removeSubscription(id) { this.subscriptions.delete(id); }
  isSubscribed(id, contextType) {
    if (!this.subscriptions.has(id)) return false;
    const filter = this.subscriptions.get(id);
    return filter === null || filter === contextType;
  }
}

const registry = new ChannelRegistry();
const colors = { red: '#e05252', green: '#2f9d65', blue: '#3979d5', yellow: '#d7a928' };
Object.entries(colors).forEach(([id, color]) =>
  registry.getOrCreate(id, 'system', { name: id[0].toUpperCase() + id.slice(1), color })
);

const app = express();
app.use(express.json());
app.get('/health', (_req, res) =>
  res.json({ status: 'ok', channels: registry.listChannels().length })
);

const server = http.createServer(app);
const wss = new WebSocketServer({ server });
const connections = new Map();

function send(ws, event, data = {}) {
  if (ws.readyState === WebSocket.OPEN) ws.send(JSON.stringify({ event, ...data }));
}
function fail(ws, message, requestId) { send(ws, 'error', { message, requestId }); }

wss.on('connection', (ws) => {
  const id = crypto.randomUUID();
  const state = new ConnectionState(id);
  connections.set(ws, state);

  ws.on('message', (raw) => {
    let msg;
    try { msg = JSON.parse(raw.toString()); }
    catch { return fail(ws, 'Invalid JSON message'); }

    const { action, channelId, requestId } = msg;
    try {
      if (action === 'list_channels') {
        return send(ws, 'channel_list', { channels: registry.listChannels(), requestId });
      }

      if (action === 'create_channel') {
        if (!channelId || !/^[a-zA-Z0-9_-]{1,40}$/.test(channelId))
          return fail(ws, 'Channel ID must be 1–40 letters, numbers, _ or -', requestId);
        const descriptor = registry.getOrCreate(channelId, 'user', {
          name: channelId, color: '#8056a8'
        });
        return send(ws, 'channel_created', { channels: [descriptor], channelId, requestId });
      }

      if (action === 'join') {
        if (!registry.channels.has(channelId)) return fail(ws, 'Unknown channel: ' + channelId, requestId);
        const previous = state.getCurrentChannel();
        if (previous) state.removeSubscription(previous);
        state.clearCurrentChannel();
        state.setCurrentChannel(channelId);
        state.addSubscription(channelId, msg.contextType || null);
        return send(ws, 'joined', {
          channelId, context: registry.getLastContext(channelId), requestId
        });
      }

      if (action === 'leave') {
        const previous = state.getCurrentChannel();
        if (previous) state.removeSubscription(previous);
        state.clearCurrentChannel();
        return send(ws, 'left', { channelId: previous, requestId });
      }

      if (action === 'subscribe') {
        if (!registry.channels.has(channelId)) return fail(ws, 'Unknown channel', requestId);
        state.addSubscription(channelId, msg.contextType || null);
        return send(ws, 'joined', { channelId, context: registry.getLastContext(channelId), requestId });
      }

      if (action === 'unsubscribe') {
        state.removeSubscription(channelId);
        if (state.getCurrentChannel() === channelId) state.clearCurrentChannel();
        return send(ws, 'left', { channelId, requestId });
      }

      if (action === 'broadcast') {
        const current = state.getCurrentChannel();
        const context = msg.context;
        if (!current) return fail(ws, 'Join a channel before broadcasting', requestId);
        if (!context || typeof context.type !== 'string' || !context.type.startsWith('fdc3.'))
          return fail(ws, 'A valid namespaced FDC3 context is required', requestId);
        registry.setLastContext(current, context);
        for (const [client, clientState] of connections) {
          if (client !== ws && clientState.isSubscribed(current, context.type)) {
            send(client, 'context', { channelId: current, context });
          }
        }
        return send(ws, 'broadcast', { channelId: current, requestId });
      }

      fail(ws, 'Unsupported action: ' + action, requestId);
    } catch (err) {
      fail(ws, err.message || 'Broker error', requestId);
    }
  });

  ws.on('close', () => {
    const current = state.getCurrentChannel();
    if (current) state.removeSubscription(current);
    state.clearCurrentChannel();
    connections.delete(ws);
  });
});

const PORT = Number(process.env.BROKER_PORT || 8765);
server.listen(PORT, '0.0.0.0', () =>
  console.log(`FDC3 channel broker listening on ${PORT}`)
);
