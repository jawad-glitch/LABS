const test = require("node:test");
const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");

const root = path.resolve(__dirname, "..");
const agent = fs.readFileSync(path.join(root, "desktop-agent/agent.js"), "utf8");
const sender = fs.readFileSync(path.join(root, "app-sender/app.js"), "utf8");
const receiver = fs.readFileSync(path.join(root, "app-receiver/app.js"), "utf8");
const relay = fs.readFileSync(path.join(root, "relay.js"), "utf8");

test("agent exposes the required FDC3 methods and window.fdc3", () => {
  for (const method of ["broadcast(context)", "addContextListener(contextType, handler)", "getCurrentContext(contextType)"]) {
    assert.ok(agent.includes(method), `missing ${method}`);
  }
  assert.ok(agent.trimEnd().endsWith("window.fdc3 = new FDC3DesktopAgent();"));
});

test("agent validates context type and supports unsubscribe", () => {
  assert.match(agent, /context\.type !== "string"/);
  assert.match(agent, /unsubscribe:\s*\(\)\s*=>/);
});

test("agent supports typed and wildcard listeners", () => {
  assert.match(agent, /listener\.contextType === null/);
  assert.match(agent, /listener\.contextType === context\.type/);
});

test("sender builds fdc3.instrument with ticker, ISIN, MIC and RIC", () => {
  assert.match(sender, /type:\s*"fdc3\.instrument"/);
  for (const key of ["ticker", "ISIN", "MIC", "RIC"]) assert.ok(sender.includes(key));
  assert.match(sender, /window\.fdc3\.broadcast\(context\)/);
});

test("receiver registers wildcard listener and supports stop and clear", () => {
  assert.match(receiver, /addContextListener\(null/);
  assert.match(receiver, /listener\.unsubscribe\(\)/);
  assert.match(receiver, /clearHistory\(\)/);
  assert.match(receiver, /toISOString\(\)/);
});

test("relay supports cross-origin CORS and message polling", () => {
  assert.match(relay, /Access-Control-Allow-Origin/);
  assert.match(relay, /\/broadcast/);
  assert.match(relay, /\/events/);
});

test("all app HTML pages load the shared agent by relative path", () => {
  for (const app of ["app-sender", "app-receiver"]) {
    const html = fs.readFileSync(path.join(root, app, "index.html"), "utf8");
    assert.ok(html.includes("../desktop-agent/agent.js"));
  }
});
