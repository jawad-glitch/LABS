(function () {
  const appId = document.body.dataset.appId;
  const socket = new WebSocket("ws://localhost:3001");
  const pending = new Map();
  const listeners = new Map();
  const disconnectHandlers = new Map();
  let registered = false;
  let readyResolve;
  let readyReject;

  const ready = new Promise((resolve, reject) => {
    readyResolve = resolve;
    readyReject = reject;
  });

  socket.addEventListener("open", async () => {
    try {
      await request("register", { appId });
      registered = true;
      readyResolve();
      window.dispatchEvent(new Event("fdc3-ready"));
    } catch (error) {
      readyReject(error);
    }
  });

  socket.addEventListener("error", () => {
    if (!registered) readyReject(new Error("Desktop Agent connection failed"));
  });

  socket.addEventListener("close", () => {
    for (const item of pending.values()) item.reject(new Error("Desktop Agent disconnected"));
    pending.clear();
  });

  function request(action, payload = {}) {
    const sendRequest = () => new Promise((resolve, reject) => {
      const msgId = crypto.randomUUID();
      pending.set(msgId, { resolve, reject });
      socket.send(JSON.stringify({ msgId, action, payload }));
      setTimeout(() => {
        if (pending.has(msgId)) {
          pending.delete(msgId);
          reject(new Error("Desktop Agent request timed out: " + action));
        }
      }, 8000);
    });
    return action === "register" ? sendRequest() : ready.then(sendRequest);
  }

  socket.addEventListener("message", (event) => {
    let message;
    try { message = JSON.parse(event.data); } catch { return; }

    if (message.msgId && pending.has(message.msgId)) {
      const item = pending.get(message.msgId);
      pending.delete(message.msgId);
      if (message.ok) item.resolve(message.data || {});
      else item.reject(new Error(message.error || "Desktop Agent request failed"));
      return;
    }

    if (message.event === "contextReceived") {
      for (const [id, item] of listeners) {
        if (item.channelId === message.channelId &&
            (!item.contextType || item.contextType === message.payload.context.type)) {
          try { item.handler(message.payload.context); }
          catch (error) { console.error("FDC3 listener error", error); }
        }
      }
    }

    if (message.event === "channelDisconnected" || message.event === "participantLeft") {
      for (const handler of disconnectHandlers.get(message.channelId) || []) {
        try { handler(); } catch (error) { console.error(error); }
      }
    }
  });

  function makeListener(channelId, contextType, handler) {
    const id = crypto.randomUUID();
    listeners.set(id, { channelId, contextType, handler });
    return {
      id,
      unsubscribe() {
        listeners.delete(id);
        request("removeContextListener", { listenerId: id }).catch(() => {});
      }
    };
  }

  const fdc3 = {
    async createPrivateChannel() {
      const result = await request("createPrivateChannel");
      const channel = makeChannel(result.channelId);
      return channel;
    },

    async addParticipant(channelId, targetAppId) {
      await request("addParticipant", { channelId, targetAppId });
    },

    async joinPrivateChannel(channelId) {
      await request("joinPrivateChannel", { channelId });
      return makeChannel(channelId);
    },

    async broadcast(channelId, context) {
      await request("broadcast", { channelId, context });
    },

    async addContextListener(channelId, contextType, handler) {
      await request("addContextListener", { channelId, contextType });
      return makeListener(channelId, contextType, handler);
    },

    async disconnect(channelId) {
      await request("disconnect", { channelId });
    }
  };

  function makeChannel(channelId) {
    return {
      id: channelId,
      type: "private",
      broadcast: (context) => fdc3.broadcast(channelId, context),
      addContextListener: (contextType, handler) =>
        fdc3.addContextListener(channelId, contextType, handler),
      addOnDisconnectListener(handler) {
        if (!disconnectHandlers.has(channelId)) disconnectHandlers.set(channelId, new Set());
        disconnectHandlers.get(channelId).add(handler);
        return {
          id: crypto.randomUUID(),
          unsubscribe() { disconnectHandlers.get(channelId)?.delete(handler); }
        };
      },
      disconnect: () => fdc3.disconnect(channelId)
    };
  }

  window.mockDesktopAgent = {
    registerApp(id) {
      if (id !== appId) console.warn("Page appId differs from requested registration");
      return ready;
    }
  };

  window.fdc3 = fdc3;
  window.mockDesktopAgent.registerApp(appId);
})();
