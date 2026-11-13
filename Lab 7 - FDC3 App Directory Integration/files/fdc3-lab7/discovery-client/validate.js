const AppDiscovery = require('./AppDiscovery');
const discovery = new AppDiscovery('http://127.0.0.1:3001');

(async () => {
  let failures = 0;

  function check(condition, description) {
    if (condition) console.log('PASS:', description);
    else {
      console.log('FAIL:', description);
      failures++;
    }
  }

  const all = await discovery.listAll();
  check(all.length === 3, 'listAll returns exactly 3 applications');

  const quote = await discovery.findByIntent('ViewQuote');
  check(quote.length === 2 &&
    quote.some(app => app.appId === 'trading-app-v1') &&
    quote.some(app => app.appId === 'market-data-viewer-v1'),
    'findByIntent ViewQuote returns the two expected applications');

  const lowerQuote = await discovery.findByIntent('viewquote');
  check(lowerQuote.length === 2, 'findByIntent is case-insensitive');

  const portfolio = await discovery.findByContext('fdc3.portfolio');
  check(portfolio.length === 2 &&
    portfolio.some(app => app.appId === 'trading-app-v1') &&
    portfolio.some(app => app.appId === 'portfolio-manager-v2'),
    'findByContext fdc3.portfolio returns the two expected applications');

  const trading = await discovery.findByCategory('trading');
  check(trading.some(app => app.appId === 'trading-app-v1'),
    'findByCategory trading includes trading-app-v1');

  const capabilities = await discovery.getCapabilities('portfolio-manager-v2');
  check(capabilities !== null && capabilities.intents.length === 3,
    'getCapabilities returns three portfolio-manager intents');

  console.log(`\n${6 - failures}/6 assertions passed.`);
  if (failures) process.exitCode = 1;
})().catch(error => {
  console.error('Validation runner failed:', error.message);
  process.exitCode = 1;
});
