(function(root) {
  class MarketDataFeed {
    constructor(streams, intervalMs, lcgSeed, agent) {
      if (!Array.isArray(streams) || streams.length < 3) throw new Error("At least three streams are required");
      this.streams = streams;
      this.intervalMs = Math.max(100, Number(intervalMs) || 100);
      this.seed = Number.isInteger(lcgSeed) ? lcgSeed : 12345;
      this.agent = agent || root.fdc3DesktopAgent;
      this.timer = null;
      this.running = false;
      this.inFlight = new Set();
      this.backpressureLog = [];
      this.totalTicks = 0;
      this.states = new Map();
      this.prices = new Map();
      this.previous = new Map();
      this.bases = {AAPL:190,MSFT:420,GOOGL:175,TSLA:250,AMZN:200};
      this.names = {AAPL:"Apple Inc.",MSFT:"Microsoft Corp.",GOOGL:"Alphabet Inc.",TSLA:"Tesla Inc.",AMZN:"Amazon.com Inc."};
      streams.forEach((stream, index) => {
        this.states.set(stream.symbol, (this.seed + index * 7919) >>> 0);
        this.prices.set(stream.symbol, this.bases[stream.symbol] || 100);
      });
      this.onTick = null;
    }

    nextPrice(symbol) {
      let state = this.states.get(symbol);
      if (state === undefined) state = this.seed >>> 0;
      state = (1664525 * state + 1013904223) >>> 0;
      this.states.set(symbol, state);
      const base = this.bases[symbol] || 100;
      const movement = ((state / 4294967296) - 0.5) * 0.10;
      const previous = this.prices.get(symbol) || base;
      const price = Math.max(base * 0.95, Math.min(base * 1.05, previous * (1 + movement)));
      this.prices.set(symbol, price);
      return Number(price.toFixed(2));
    }

    async start() {
      if (this.running) return;
      this.running = true;
      this.backpressureLog = [];
      for (const stream of this.streams) await this.agent.joinChannel(stream.channelId);
      this._emitAll();
      this.timer = setInterval(() => this._emitAll(), this.intervalMs);
    }

    _emitAll() {
      if (!this.running) return;
      for (const stream of this.streams) {
        const job = this._emitOne(stream);
        this.inFlight.add(job);
        job.finally(() => this.inFlight.delete(job)).catch(() => {});
      }
    }

    async _emitOne(stream) {
      const price = this.nextPrice(stream.symbol);
      const oldPrice = this.previous.has(stream.symbol) ? this.previous.get(stream.symbol) : price;
      const timestamp = new Date().toISOString();
      const context = {
        type:"fdc3.instrument",
        name:this.names[stream.symbol] || stream.symbol,
        id:{ticker:stream.symbol},
        marketData:{
          price, volume:1000 + (this.totalTicks * 137 % 90000),
          timestamp, change:Number((price - oldPrice).toFixed(2))
        }
      };
      this.previous.set(stream.symbol, price);
      this.totalTicks++;
      if (typeof this.onTick === "function") this.onTick(context);

      await this.agent.joinChannel(stream.channelId);
      let warned = false;
      const warningTimer = setTimeout(() => {
        warned = true;
        const event = {
          symbol:stream.symbol,
          lagMs:Date.now() - Date.parse(timestamp),
          timestamp:new Date().toISOString()
        };
        this.backpressureLog.push(event);
        console.warn("BACKPRESSURE_WARNING", JSON.stringify(event));
      }, 500);

      try {
        await this.agent.broadcast(context);
      } finally {
        clearTimeout(warningTimer);
        if (warned) {
          const last = this.backpressureLog[this.backpressureLog.length - 1];
          if (last && last.symbol === stream.symbol) last.lagMs = Date.now() - Date.parse(timestamp);
        }
      }
    }

    async stop() {
      if (this.timer) clearInterval(this.timer);
      this.timer = null;
      this.running = false;
      await Promise.allSettled(Array.from(this.inFlight));
      for (const stream of this.streams) {
        await this.agent.joinChannel(stream.channelId);
        await this.agent.leaveCurrentChannel();
      }
    }

    getBackpressureLog() { return this.backpressureLog.slice(); }
  }

  root.MarketDataFeed = MarketDataFeed;
  if (typeof module !== "undefined" && module.exports) module.exports = MarketDataFeed;
})(typeof window !== "undefined" ? window : globalThis);
