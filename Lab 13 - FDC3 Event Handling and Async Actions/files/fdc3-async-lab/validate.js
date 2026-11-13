const FDC3DesktopAgent = require("./shared/js/fdc3-desktop-agent.js");
const MarketDataFeed = require("./apps/market-data-feed/market-data-feed.js");

class FeedValidator {
  async run(durationMs, intervalMs) {
    const agent = new FDC3DesktopAgent();
    await agent.registerApp("validator", null);
    for (const channel of ["red","green","blue"]) await agent.joinChannel(channel);

    let received = 0;
    let maxLagMs = 0;
    const listener = await agent.addContextListener("fdc3.instrument", context => {
      received++;
      const lag = Math.max(0, Date.now() - Date.parse(context.marketData.timestamp));
      maxLagMs = Math.max(maxLagMs, lag);
    });

    const streams = [
      {symbol:"AAPL",channelId:"red"},
      {symbol:"MSFT",channelId:"green"},
      {symbol:"GOOGL",channelId:"blue"}
    ];
    const feed = new MarketDataFeed(streams, intervalMs, 24680, agent);
    await feed.start();

    await new Promise(resolve => setTimeout(resolve, durationMs + intervalMs * 2));
    await feed.stop();
    listener.unsubscribe();

    const expectedTicks = Math.floor(durationMs / intervalMs) * streams.length;
    const totalTicks = received;
    const missedTicks = Math.max(0, expectedTicks - totalTicks);
    const report = {
      totalTicks,
      expectedTicks,
      missedTicks,
      backpressureEvents:feed.getBackpressureLog().length,
      maxLagMs,
      passed:missedTicks === 0 && maxLagMs < 1000
    };
    return report;
  }
}

(async () => {
  try {
    const report = await new FeedValidator().run(5000, 200);
    console.log(JSON.stringify(report, null, 2));
    process.exitCode = report.passed ? 0 : 1;
  } catch (error) {
    console.error("VALIDATION ERROR:", error);
    process.exitCode = 1;
  }
})();
