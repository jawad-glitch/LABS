const WebSocket = require('../desktop-agent/node_modules/ws');

const agent = 'ws://127.0.0.1:9090';
const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));

function connect() {
  return new Promise((resolve, reject) => {
    const ws = new WebSocket(agent);
    const messages = [];
    ws.on('message', raw => {
      const message = JSON.parse(raw.toString());
      messages.push(message);
      if (message.type === 'connected') resolve({ ws, messages, appId: message.appId });
    });
    ws.on('error', reject);
  });
}

async function waitFor(client, type, timeout = 4000) {
  const start = Date.now();
  while (Date.now() - start < timeout) {
    const found = client.messages.find(message => message.type === type);
    if (found) return found;
    await sleep(30);
  }
  throw new Error(`Timed out waiting for ${type}`);
}

(async () => {
  let portfolio, trading;
  try {
    portfolio = await connect();
    trading = await connect();

    portfolio.ws.send(JSON.stringify({ type: 'joinChannel', channelId: 'blue' }));
    trading.ws.send(JSON.stringify({ type: 'joinChannel', channelId: 'blue' }));
    await waitFor(portfolio, 'channelJoined');
    await waitFor(trading, 'channelJoined');

    const instrument = {
      type: 'fdc3.instrument',
      name: 'Apple Inc.',
      id: { ticker: 'AAPL', ISIN: 'US0378331005' }
    };
    portfolio.ws.send(JSON.stringify({ type: 'broadcast', context: instrument }));
    const received = await waitFor(trading, 'context');
    if (received.context.id.ticker !== 'AAPL') throw new Error('Wrong instrument context');
    console.log('PASS: portfolio context broadcast reached trading client');

    trading.ws.send(JSON.stringify({ type: 'addIntentListener', intent: 'ViewChart' }));
    await waitFor(trading, 'intentListenerAdded');
    trading.ws.send(JSON.stringify({
      type: 'raiseIntent',
      intent: 'ViewChart',
      context: instrument
    }));
    const intent = await waitFor(trading, 'intent');
    if (intent.context.id.ticker !== 'AAPL') throw new Error('Wrong intent context');
    console.log('PASS: ViewChart intent reached its registered handler');

    const status = await fetch('http://127.0.0.1:9090/api/status').then(r => r.json());
    if (status.connectedApps < 2) throw new Error('Agent does not show both test clients');
    console.log('PASS: REST monitoring endpoint reports connected clients');

    console.log('ALL AUTOMATED FDC3 TESTS PASSED');
  } catch (error) {
    console.error('TEST FAILED:', error.message);
    process.exitCode = 1;
  } finally {
    if (portfolio) portfolio.ws.close();
    if (trading) trading.ws.close();
  }
})();
