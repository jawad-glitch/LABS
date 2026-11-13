(() => {
  const log = message => { document.getElementById("log").textContent += message + "\n"; };
  if (!window.fdc3) { document.body.innerHTML = "<h2>FDC3 Desktop Agent unavailable</h2>"; return; }
  const instrument = () => ({ type: "fdc3.instrument", id: { ticker: document.getElementById("instrument").value } });
  document.getElementById("broadcast").onclick = async () => { await fdc3.broadcast(instrument()); log("Broadcast: " + JSON.stringify(instrument())); };
  document.getElementById("intent").onclick = async () => {
    const resolution = await fdc3.raiseIntent("ViewChart", instrument());
    log("Intent resolution: " + resolution.source + " / v" + resolution.version);
    log("Result: " + JSON.stringify(await resolution.getResult()));
  };
  document.getElementById("join").onclick = async () => {
    const channel = await fdc3.getOrCreateChannel(document.getElementById("channel").value);
    await channel.addContextListener(null, context => log("Channel context: " + JSON.stringify(context)));
    window.labChannel = channel;
    log("Joined channel: " + channel.name);
  };
  document.getElementById("channelBroadcast").onclick = () => {
    if (!window.labChannel) return log("Join a channel first");
    window.labChannel.broadcast(instrument());
    log("Channel broadcast sent");
  };
  fdc3.addContextListener(null, context => log("Default context received: " + JSON.stringify(context)));
  log("Blotter connected to local FDC3 lab agent");
})();
