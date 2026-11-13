class ChannelRegistry {
  constructor() {
    this.apps = new Map();
    this.channels = new Map();
  }

  registerApp(socketId, appMeta = {}) {
    const name = String(appMeta.name || "unnamed-app").trim();
    if (!name) throw new Error("Application name is required");

    const appId = String(appMeta.appId || `${name}:${socketId}`);
    for (const app of this.apps.values()) {
      if (app.appId === appId) throw new Error("appId already active");
    }

    this.apps.set(socketId, {
      appId,
      name,
      type: String(appMeta.type || "web"),
      version: String(appMeta.version || "1.0.0")
    });

    return { appId, status: "registered" };
  }

  joinChannel(socketId, channelId) {
    if (!this.apps.has(socketId)) throw new Error("Application is not registered");
    if (typeof channelId !== "string" || !channelId.trim()) {
      throw new Error("channelId is required");
    }

    if (!this.channels.has(channelId)) {
      this.channels.set(channelId, {
        members: new Set(),
        currentContext: null,
        updatedAt: null
      });
    }

    const channel = this.channels.get(channelId);
    channel.members.add(socketId);

    return {
      channelId,
      memberCount: channel.members.size,
      currentContext: channel.currentContext
    };
  }

  broadcastContext(socketId, channelId, context) {
    const channel = this.channels.get(channelId);
    if (!this.apps.has(socketId)) throw new Error("Application is not registered");
    if (!channel || !channel.members.has(socketId)) {
      throw new Error("Application has not joined this channel");
    }

    if (!context || typeof context !== "object" ||
        typeof context.type !== "string" ||
        !/^fdc3\.[a-z]+$/.test(context.type)) {
      const error = new Error("Context type must match fdc3.<noun>");
      error.code = "MISSING_TYPE";
      throw error;
    }

    channel.currentContext = JSON.parse(JSON.stringify(context));
    channel.updatedAt = new Date().toISOString();

    return [...channel.members].filter(id => id !== socketId);
  }

  getCurrentContext(channelId) {
    return this.channels.get(channelId)?.currentContext || null;
  }

  getChannelDetail(channelId) {
    const channel = this.channels.get(channelId);
    if (!channel) return null;

    return {
      memberCount: channel.members.size,
      contextType: channel.currentContext?.type || null,
      updatedAt: channel.updatedAt,
      currentContext: channel.currentContext
    };
  }

  deregisterApp(socketId) {
    this.apps.delete(socketId);
    for (const channel of this.channels.values()) {
      channel.members.delete(socketId);
    }
  }

  snapshot() {
    const result = {};
    for (const [channelId, channel] of this.channels.entries()) {
      result[channelId] = {
        memberCount: channel.members.size,
        contextType: channel.currentContext?.type || null,
        updatedAt: channel.updatedAt
      };
    }
    return result;
  }
}

module.exports = ChannelRegistry;
