const client = new ChannelClient();
const $ = id => document.getElementById(id);
const seenTypes = new Set();
let redEventsAfterSwitch = 0;
let testActive = false;

function addType(type) {
  if (seenTypes.has(type)) return;
  seenTypes.add(type);
  const option = document.createElement('option');
  option.value = type; option.textContent = type;
  $('filter').append(option);
}
function renderFilter() {
  const selected = $('filter').value;
  document.querySelectorAll('.entry').forEach(el => {
    el.hidden = !!selected && el.dataset.type !== selected;
  });
}
function addEvent(context, channelId) {
  addType(context.type);
  if (testActive && channelId === 'red') redEventsAfterSwitch++;
  const item = document.createElement('article');
  item.className = 'entry'; item.dataset.type = context.type;
  const time = new Date().toISOString();
  const heading = document.createElement('strong');
  heading.textContent = `${channelId} | ${context.type} | ${time}`;
  const pre = document.createElement('pre');
  pre.textContent = JSON.stringify(context, null, 2);
  item.append(heading, pre);
  $('log').prepend(item);
  renderFilter();
}
function renderChannels(channels) {
  $('channels').replaceChildren();
  channels.forEach(ch => {
    const b = document.createElement('button');
    b.textContent = `${ch.displayMetadata?.name || ch.id} (${ch.type})`;
    b.onclick = async () => {
      try {
        await client.joinChannel(ch.id, null);
        $('status').textContent = `Connected — Joined channel: ${ch.id} (${ch.type})`;
        $('message').textContent = `Listening on ${ch.id}`;
      } catch (e) { $('message').textContent = e.message; }
    };
    $('channels').append(b);
  });
}
$('filter').onchange = renderFilter;
$('clear').onclick = () => $('log').replaceChildren();

$('runTest').onclick = async () => {
  const button = $('runTest');
  button.disabled = true;
  $('testResult').textContent = 'Running isolation test…';
  testActive = false;
  redEventsAfterSwitch = 0;
  let probe;
  try {
    await client.joinChannel('red', null);
    await new Promise(r => setTimeout(r, 150));
    await client.joinChannel('green', null);
    testActive = true;

    probe = new ChannelClient();
    await probe.connect('ws://' + location.hostname + ':8765');
    await probe.joinChannel('red', null);

    for (let i = 0; i < 6; i++) {
      await probe.broadcast({
        type: 'fdc3.instrument',
        name: 'Isolation probe ' + (i + 1),
        id: { ticker: 'ISOTEST', MIC: 'XNAS' }
      });
      await new Promise(r => setTimeout(r, 200));
    }
    await new Promise(r => setTimeout(r, 250));
    testActive = false;
    if (redEventsAfterSwitch === 0) {
      $('testResult').textContent = 'PASS — no red-channel events were received after switching to green.';
    } else {
      $('testResult').textContent = `FAIL — received ${redEventsAfterSwitch} red-channel event(s) after switching to green.`;
    }
  } catch (e) {
    testActive = false;
    $('testResult').textContent = 'TEST ERROR — ' + e.message;
  } finally {
    if (probe) probe.disconnect();
    button.disabled = false;
  }
};

client.onContext(addEvent);
client.connect('ws://' + location.hostname + ':8765')
  .then(async () => {
    $('status').textContent = 'Connected — No channel joined';
    renderChannels(await client.listChannels());
  })
  .catch(e => $('status').textContent = 'Broker connection failed: ' + e.message);
