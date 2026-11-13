const client = new ChannelClient();
let selected = null;
const $ = id => document.getElementById(id);
function status(text) { $('status').textContent = text; }
function renderChannels(channels) {
  $('channels').replaceChildren();
  channels.forEach(ch => {
    const b = document.createElement('button');
    b.className = 'channel ' + (ch.type === 'user' ? 'user' : '');
    b.textContent = `${ch.displayMetadata?.name || ch.id} (${ch.type})`;
    if (ch.type === 'system' && ch.displayMetadata?.color)
      b.style.borderLeftColor = ch.displayMetadata.color;
    b.onclick = () => {
      selected = ch;
      $('channelMessage').textContent = `Selected: ${ch.id}. Click Join to subscribe.`;
      const join = document.getElementById('joinSelected');
      if (join) join.remove();
      const j = document.createElement('button');
      j.id = 'joinSelected'; j.textContent = 'Join Selected Channel';
      j.onclick = joinSelected;
      $('channelMessage').append(' ', j);
    };
    $('channels').append(b);
  });
}
async function refresh() { renderChannels(await client.listChannels()); }
async function joinSelected() {
  if (!selected) return;
  try {
    const restored = await client.joinChannel(selected.id, null);
    status(`Joined channel: ${selected.id} (${selected.type})`);
    $('restored').textContent = restored
      ? JSON.stringify(restored, null, 2) : 'No previous context for this channel.';
  } catch (e) { $('error').textContent = e.message; }
}
$('create').onclick = async () => {
  try {
    const id = $('newChannel').value.trim();
    if (!id) throw new Error('Enter a channel ID.');
    await client.createChannel(id);
    $('newChannel').value = '';
    await refresh();
    $('channelMessage').textContent = `Channel "${id}" created or already existed.`;
  } catch (e) { $('channelMessage').textContent = e.message; }
};
$('broadcast').onclick = async () => {
  $('error').textContent = '';
  try {
    const context = JSON.parse($('payload').value);
    if (!context || context.type !== $('contextType').value)
      throw new Error('The JSON type must match the selected context type.');
    if (!context.id || typeof context.id !== 'object')
      throw new Error('The context must contain an id object.');
    await client.broadcast(context);
    $('result').textContent = `Broadcast sent to ${client.currentChannel} at ${new Date().toISOString()}`;
  } catch (e) { $('error').textContent = e.message; }
};
client.connect('ws://' + location.hostname + ':8765')
  .then(async () => {
    status('Connected — No channel joined');
    await refresh();
    client.onContext((context, channelId) => {
      $('restored').textContent = `Latest context on ${channelId}:\n${JSON.stringify(context, null, 2)}`;
    });
  })
  .catch(e => status('Broker connection failed: ' + e.message));
