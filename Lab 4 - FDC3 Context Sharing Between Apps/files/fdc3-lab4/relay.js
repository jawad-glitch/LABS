const http = require("node:http");
const { URL } = require("node:url");

const PORT = 3003;
const events = [];
let nextId = 1;
const MAX_EVENTS = 500;

const server = http.createServer((req, res) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "GET,POST,OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type");

  if (req.method === "OPTIONS") {
    res.writeHead(204);
    return res.end();
  }

  const url = new URL(req.url, `http://${req.headers.host}`);

  if (req.method === "GET" && url.pathname === "/health") {
    res.writeHead(200, { "Content-Type": "application/json" });
    return res.end(JSON.stringify({ status: "ok", service: "FDC3 relay" }));
  }

  if (req.method === "POST" && url.pathname === "/broadcast") {
    let body = "";
    req.on("data", chunk => {
      body += chunk;
      if (body.length > 100000) req.destroy();
    });
    req.on("end", () => {
      try {
        const context = JSON.parse(body);
        if (!context || typeof context.type !== "string" || !context.type.trim()) {
          res.writeHead(400, { "Content-Type": "application/json" });
          return res.end(JSON.stringify({ error: "context.type must be a non-empty string" }));
        }
        const event = { id: nextId++, context, timestamp: new Date().toISOString() };
        events.push(event);
        if (events.length > MAX_EVENTS) events.shift();
        res.writeHead(202, { "Content-Type": "application/json" });
        res.end(JSON.stringify({ accepted: true, id: event.id }));
      } catch {
        res.writeHead(400, { "Content-Type": "application/json" });
        res.end(JSON.stringify({ error: "Invalid JSON" }));
      }
    });
    return;
  }

  if (req.method === "GET" && url.pathname === "/events") {
    const since = Number(url.searchParams.get("since") || 0);
    const result = events.filter(event => event.id > since);
    res.writeHead(200, { "Content-Type": "application/json", "Cache-Control": "no-store" });
    return res.end(JSON.stringify(result));
  }

  res.writeHead(404, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ error: "Not found" }));
});

server.listen(PORT, "127.0.0.1", () => {
  console.log(`FDC3 relay listening on http://127.0.0.1:${PORT}`);
});
