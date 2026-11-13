const WebSocket = require("ws");
const { DesktopAgent } = require("./core");
const agent = new DesktopAgent();
const server = new WebSocket.Server({ port: 4200 });
let next = 0;
server.on("connection", socket => {
  const id = "app-" + (++next);
  agent.connect(id, { title: id, instanceId: id });
  socket.send(JSON.stringify({ event: "ready", id }));
  socket.on("message", raw => {
    let msg;
    try { msg = JSON.parse(raw.toString()); } catch { return; }
    const reply = (data) => socket.send(JSON.stringify(data));
    try {
      if (msg.action === "joinChannel") reply({ requestId: msg.requestId, result: agent.joinChannel(id, msg.channel) });
      else if (msg.action === "broadcast") reply({ requestId: msg.requestId, result: agent.broadcast(id, msg.context) });
      else if (msg.action === "addContextListener") {
        const token = agent.addContextListener(id, msg.contextType, context => reply({ event: "context", token, context }));
        reply({ requestId: msg.requestId, result: { token } });
      } else if (msg.action === "removeContextListener") reply({ requestId: msg.requestId, result: agent.removeContextListener(id, msg.token) });
      else if (msg.action === "addIntentHandler") {
        agent.addIntentHandler(id, msg.intent, context => {
          reply({ event: "intent", intent: msg.intent, context });
          return { accepted: true };
        });
        reply({ requestId: msg.requestId, result: { registered: true } });
      } else if (msg.action === "raiseIntent") reply({ requestId: msg.requestId, result: agent.raiseIntent(id, msg.intent, msg.context) });
      else if (msg.action === "getInfo") reply({ requestId: msg.requestId, result: agent.getInfo(id) });
      else reply({ requestId: msg.requestId, error: "Unknown action" });
    } catch (e) { reply({ requestId: msg.requestId, error: e.message }); }
  });
  socket.on("close", () => agent.disconnect(id));
});
console.log("Mock FDC3 Desktop Agent listening on ws://127.0.0.1:4200");
