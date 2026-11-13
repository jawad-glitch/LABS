const express = require("express");
const cors = require("cors");
const fs = require("fs");
const { logFile } = require("../config/logger");

const app = express();
const PORT = Number(process.env.MONITOR_PORT || 3001);

app.use(cors());
app.use(express.json());

function readLogs() {
  if (!fs.existsSync(logFile)) return [];

  return fs.readFileSync(logFile, "utf8")
    .split(/\r?\n/)
    .filter(line => line.trim())
    .map((line, index) => {
      try {
        return JSON.parse(line);
      } catch {
        throw new Error(`Invalid JSON in log line ${index + 1}`);
      }
    });
}

app.get("/health", (req, res) => {
  res.json({ status: "ok", logFile });
});

app.get("/metrics", (req, res) => {
  try {
    const logs = readLogs();
    const metrics = {};

    for (const entry of logs) {
      const type = entry.event_type;
      metrics[type] = (metrics[type] || 0) + 1;
    }

    const required = [
      "intent_routed",
      "context_broadcast",
      "channel_joined",
      "app_connected"
    ];

    for (const key of required) {
      if (typeof metrics[key] !== "number") metrics[key] = 0;
    }

    metrics.errors_encountered = logs.filter(entry =>
      entry.event_type === "error" ||
      entry.event_type === "intent_routing_failed"
    ).length;

    metrics.total_events = logs.length;
    res.json(metrics);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get("/logs", (req, res) => {
  try {
    let logs = readLogs();
    const start = req.query.start;
    const end = req.query.end;

    if (start && !Number.isFinite(Date.parse(start))) {
      return res.status(400).json({ error: "Invalid start timestamp" });
    }
    if (end && !Number.isFinite(Date.parse(end))) {
      return res.status(400).json({ error: "Invalid end timestamp" });
    }

    if (start) {
      const startTime = Date.parse(start);
      logs = logs.filter(entry => Date.parse(entry.timestamp) >= startTime);
    }
    if (end) {
      const endTime = Date.parse(end);
      logs = logs.filter(entry => Date.parse(entry.timestamp) <= endTime);
    }

    res.json(logs);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`FDC3 Monitoring Service listening on http://0.0.0.0:${PORT}`);
  console.log(`Reading structured log: ${logFile}`);
});
