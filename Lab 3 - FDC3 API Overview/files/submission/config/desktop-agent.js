(function (root) {
  const listeners = new Set();
  const intentListeners = new Map();
  const channels = new Map();
  let currentContext = null;
  const transport = typeof window !== "undefined" && typeof window.BroadcastChannel !== "undefined" ? new window.BroadcastChannel("fdc3-lab-agent") : null;

  function receiveRemote(message) {
    if (!message) return;
    if (message.kind === "default-context") {
      currentContext = message.context;
      listeners.forEach(entry => {
        if (entry.type == null || entry.type === message.context.type) entry.handler(message.context);
      });
    } else if (message.kind === "channel-context") {
      const channel = channels.get(message.name);
      if (channel) channel._receive(message.context);
    } else if (message.kind === "intent") {
      const targets = intentListeners.get(message.intent);
      if (targets) targets.forEach(handler => handler({ name: message.intent }, message.context || null));
    }
  }
  if (transport) transport.onmessage = event => receiveRemote(event.data);

  function makeChannel(name) {
    const contextListeners = new Set();
    const channelIntentListeners = new Map();
    let channelContext = null;
    return {
      name,
      broadcast(context) {
        channelContext = context;
        currentContext = context;
        contextListeners.forEach(entry => {
          if (entry.type == null || entry.type === context.type) entry.handler(context);
        });
        if (transport) transport.postMessage({ kind: "channel-context", name, context });
      },
      _receive(context) {
        channelContext = context;
        contextListeners.forEach(entry => {
          if (entry.type == null || entry.type === context.type) entry.handler(context);
        });
      },
      addContextListener(type, handler) {
        const entry = { type: type || null, handler };
        contextListeners.add(entry);
        return Promise.resolve({ unsubscribe: () => contextListeners.delete(entry) });
      },
      addIntentListener(intent, handler) {
        if (!channelIntentListeners.has(intent)) channelIntentListeners.set(intent, new Set());
        channelIntentListeners.get(intent).add(handler);
        return Promise.resolve({ unsubscribe: () => channelIntentListeners.get(intent).delete(handler) });
      },
      getCurrentContext(type) {
        return Promise.resolve(!type || (channelContext && channelContext.type === type) ? channelContext : null);
      },
      _reset() {
        contextListeners.clear();
        channelIntentListeners.clear();
        channelContext = null;
      }
    };
  }

  const api = {
    version: "2.0",
    broadcast(context) {
      currentContext = context;
      listeners.forEach(entry => {
        if (entry.type == null || entry.type === context.type) entry.handler(context);
      });
      if (transport) transport.postMessage({ kind: "default-context", context });
      return Promise.resolve();
    },
    addContextListener(type, handler) {
      const entry = { type: type || null, handler };
      listeners.add(entry);
      return Promise.resolve({ unsubscribe: () => listeners.delete(entry) });
    },
    addIntentListener(intent, handler) {
      if (!intentListeners.has(intent)) intentListeners.set(intent, new Set());
      intentListeners.get(intent).add(handler);
      return Promise.resolve({ unsubscribe: () => intentListeners.get(intent).delete(handler) });
    },
    async raiseIntent(intent, context) {
      const targets = intentListeners.get(intent);
      let result = { delivered: false, intent, context: context || null };
      if (targets && targets.size) {
        targets.forEach(handler => handler({ name: intent }, context || null));
        result = { delivered: true, intent, context: context || null };
      } else if (transport) {
        result = { delivered: true, intent, context: context || null, delivery: "cross-window broadcast" };
      }
      if (transport) transport.postMessage({ kind: "intent", intent, context: context || null });
      return {
        source: "Local FDC3 Lab Desktop Agent",
        version: "2.0",
        getResult: async () => result
      };
    },
    getOrCreateChannel(name) {
      if (!channels.has(name)) channels.set(name, makeChannel(name));
      return Promise.resolve(channels.get(name));
    },
    getCurrentContext(type) {
      return Promise.resolve(!type || (currentContext && currentContext.type === type) ? currentContext : null);
    },
    _reset() {
      listeners.clear();
      intentListeners.clear();
      channels.forEach(channel => channel._reset());
      channels.clear();
      currentContext = null;
    }
  };

  if (typeof module !== "undefined" && module.exports) module.exports = api;
  if (root) root.fdc3 = api;
})(typeof window !== "undefined" ? window : globalThis);
