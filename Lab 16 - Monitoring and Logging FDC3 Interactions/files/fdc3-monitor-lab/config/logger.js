const fs = require("fs");
const path = require("path");
const winston = require("winston");

const logFile = path.join(__dirname, "..", "logs", "fdc3-interactions.log");
fs.mkdirSync(path.dirname(logFile), { recursive: true });

const logger = winston.createLogger({
  level: "info",
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.printf(info => JSON.stringify({
      timestamp: info.timestamp,
      event_type: info.event_type,
      source_app_id: info.source_app_id,
      payload: info.payload
    }))
  ),
  transports: [
    new winston.transports.File({ filename: logFile })
  ]
});

function logEvent(eventType, sourceAppId, payload = {}) {
  logger.info("", {
    event_type: eventType,
    source_app_id: sourceAppId || "unknown",
    payload
  });
}

module.exports = { logEvent, logFile };
