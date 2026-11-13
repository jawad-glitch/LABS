(() => {
  const log = message => { document.getElementById("log").textContent += message + "\n"; };
  if (!window.fdc3) { document.body.innerHTML = "<h2>FDC3 Desktop Agent unavailable</h2>"; return; }
  const show = context => {
    if (!context) return;
    const ticker = context.id && context.id.ticker ? context.id.ticker : "Unknown";
    document.getElementById("symbol").textContent = "Chart: " + ticker;
    log("Instrument context: " + JSON.stringify(context));
  };
  fdc3.addContextListener("fdc3.instrument", show);
  fdc3.addIntentListener("ViewChart", (intent, context) => {
    log("ViewChart intent received: " + intent.name);
    show(context);
  });
  document.getElementById("request").onclick = async () => {
    const context = await fdc3.getCurrentContext("fdc3.instrument");
    if (context) show(context); else log("No current instrument context");
  };
  log("Chart connected to local FDC3 lab agent");
})();
