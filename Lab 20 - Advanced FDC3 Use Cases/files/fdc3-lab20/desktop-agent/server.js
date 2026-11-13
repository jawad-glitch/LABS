const express = require('express');
const http = require('http');
const WebSocket = require('ws');
const cors = require('cors');
const path = require('path');
const { v4: uuidv4 } = require('uuid');

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

const server = http.createServer(app);
const wss = new WebSocket.Server({ server });
const connectedApps = new Map();
const channelNames = ['red', 'blue', 'green', 'yellow', 'orange', 'purple'];
const channels = new Map(
  channelNames.map(id => [id, { members: new Set(), currentContext: null }])
);

function send(ws, payload) {
  if (ws && ws.readyState === WebSocket.OPEN) {
    ws.send(JSON.stringify(payload));
  }
}

function sendToApp(appId, payload) {
  const client = connectedApps.get(appId);
  if (client) send(client.ws, payload);
}

wss.on('connection', ws => {
  const appId = uuidv4();
  connectedApps.set(appId, {
    ws,
    currentChannel: null,
    intentListeners: new Set()
  });

  send(ws, { type: 'connected', appId, fdc3Version: '2.0' });

  ws.on('message', raw => {
    try {
      const message = JSON.parse(raw.toString());
      if (!message || typeof message.type !== 'string') {
        throw new Error('Message must contain a type');
      }
      dispatch(appId, message);
    } catch (error) {
      send(ws, { type: 'error', error: error.message });
    }
  });

  ws.on('close', () => {
    const client = connectedApps.get(appId);
    if (client && client.currentChannel) {
      channels.get(client.currentChannel)?.members.delete(appId);
    }
    connectedApps.delete(appId);
    console.log('Disconnected:', appId);
  });
});

function dispatch(appId, message) {
  switch (message.type) {
    case 'joinChannel':
      return handleJoinChannel(appId, message.channelId);
    case 'broadcast':
      return handleBroadcast(appId, message.context);
    case 'raiseIntent':
      return handleRaiseIntent(appId, message.intent, message.context);
    case 'addIntentListener':
      return handleAddIntentListener(appId, message.intent);
    case 'getChannels':
      return sendToApp(appId, { type: 'channels', channels: channelNames });
    default:
      sendToApp(appId, { type: 'error', error: 'Unknown message type' });
  }
}

function handleJoinChannel(appId, channelId) {
  const client = connectedApps.get(appId);
  const channel = channels.get(channelId);
  if (!client || !channel) {
    return sendToApp(appId, { type: 'error', error: 'Invalid channel' });
  }

  if (client.currentChannel) {
    channels.get(client.currentChannel)?.members.delete(appId);
  }

  client.currentChannel = channelId;
  channel.members.add(appId);

  sendToApp(appId, { type: 'channelJoined', channelId });

  if (channel.currentContext !== null) {
    sendToApp(appId, { type: 'context', context: channel.currentContext });
  }
}

function handleBroadcast(appId, context) {
  const client = connectedApps.get(appId);
  if (!client || !client.currentChannel) {
    return sendToApp(appId, { type: 'error', error: 'Not on a channel' });
  }
  if (!context || typeof context.type !== 'string') {
    return sendToApp(appId, { type: 'error', error: 'Invalid FDC3 context' });
  }

  const channel = channels.get(client.currentChannel);
  channel.currentContext = context;

  for (const memberId of channel.members) {
    if (memberId !== appId) {
      sendToApp(memberId, { type: 'context', context });
    }
  }

  sendToApp(appId, {
    type: 'broadcastComplete',
    contextType: context.type,
    channelId: client.currentChannel
  });
}

function handleRaiseIntent(appId, intent, context) {
  if (typeof intent !== 'string' || !intent.trim()) {
    return sendToApp(appId, { type: 'intentError', error: 'Invalid intent' });
  }

  const candidates = [...connectedApps.entries()].filter(
    ([id, client]) => id !== appId && client.intentListeners.has(intent)
  );

  // Lab compatibility: if no other app handles the intent, allow the
  // originating app to receive its own intent when it registered a listener.
  if (candidates.length === 0) {
    const self = connectedApps.get(appId);
    if (self && self.intentListeners.has(intent)) {
      candidates.push([appId, self]);
    }
  }

  if (candidates.length === 0) {
    return sendToApp(appId, {
      type: 'intentError',
      error: `No handler registered for ${intent}`
    });
  }

  const [targetId] = candidates[0];
  sendToApp(targetId, { type: 'intent', intent, context, source: appId });
  sendToApp(appId, {
    type: 'intentResolution',
    intent,
    target: targetId
  });
}

function handleAddIntentListener(appId, intent) {
  const client = connectedApps.get(appId);
  if (!client || typeof intent !== 'string' || !intent.trim()) {
    return sendToApp(appId, {
      type: 'error',
      error: 'Invalid intent listener registration'
    });
  }

  client.intentListeners.add(intent);
  sendToApp(appId, { type: 'intentListenerAdded', intent });
}

app.get('/api/status', (req, res) => {
  const channelSummary = {};
  channels.forEach((channel, id) => {
    channelSummary[id] = {
      members: [...channel.members],
      hasContext: channel.currentContext !== null
    };
  });

  res.json({
    connectedApps: connectedApps.size,
    channels: channelSummary,
    apps: [...connectedApps.entries()].map(([id, client]) => ({
      appId: id,
      currentChannel: client.currentChannel,
      intentListeners: [...client.intentListeners]
    })),
    ts: new Date().toISOString()
  });
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'FDC3 Desktop Agent' });
});

server.listen(9090, '0.0.0.0', () => {
  console.log('FDC3 Desktop Agent listening on port 9090');
});

process.on('SIGTERM', () => {
  wss.clients.forEach(client => client.close());
  server.close();
});
