class IntentRegistry {
  constructor() {
    this.handlers = new Map();
  }

  register(appId, intentName, handlerUrl) {
    if (!appId || !intentName || !handlerUrl) {
      throw new Error("appId, intentName and handlerUrl are required");
    }

    const entries = this.handlers.get(intentName) || [];
    const existing = entries.findIndex(item => item.appId === appId);

    const entry = { appId, handlerUrl };
    if (existing >= 0) entries[existing] = entry;
    else entries.push(entry);

    this.handlers.set(intentName, entries);
  }

  resolve(intentName) {
    return (this.handlers.get(intentName) || []).map(item => ({ ...item }));
  }

  list() {
    return Object.fromEntries(
      [...this.handlers.entries()].map(([name, entries]) => [
        name, entries.map(item => ({ ...item }))
      ])
    );
  }

  clear(appId) {
    for (const [name, entries] of this.handlers.entries()) {
      const remaining = entries.filter(item => item.appId !== appId);
      if (remaining.length) this.handlers.set(name, remaining);
      else this.handlers.delete(name);
    }
  }
}

module.exports = IntentRegistry;
