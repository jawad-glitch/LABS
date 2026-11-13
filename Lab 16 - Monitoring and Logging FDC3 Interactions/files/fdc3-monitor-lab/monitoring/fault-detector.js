const fs = require("fs");
const path = require("path");

const root = path.join(__dirname, "..");
const logFile = path.join(root, "logs", "fdc3-interactions.log");
const reportFile = path.join(root, "fault-report.txt");

if (!fs.existsSync(logFile)) {
  console.error("ERROR: Log file does not exist:", logFile);
  process.exit(1);
}

const lines = fs.readFileSync(logFile, "utf8")
  .split(/\r?\n/)
  .filter(line => line.trim());

const failures = [];

for (let index = 0; index < lines.length; index++) {
  let entry;
  try {
    entry = JSON.parse(lines[index]);
  } catch {
    console.error(`ERROR: Invalid JSON at log line ${index + 1}`);
    process.exit(1);
  }

  if (entry.event_type !== "intent_routing_failed") continue;

  const intentName = entry.payload?.intentName;
  if (!intentName) continue;

  failures.push({
    timestamp: entry.timestamp,
    intent: intentName,
    source_app_id: entry.source_app_id,
    explanation: `No registered handler was found for intent ${intentName}, according to the Desktop Agent routing-failure record.`
  });
}

if (failures.length === 0) {
  fs.writeFileSync(reportFile, "FDC3 Fault Report\n=================\n\nNo failed intent routing events were found in the log file.\n");
  console.error("No failed intent routing events found. Report created, but fault acceptance criteria are not met.");
  process.exit(1);
}

const report = [
  "FDC3 Fault Report",
  "=================",
  `Generated: ${new Date().toISOString()}`,
  `Failed routing events: ${failures.length}`,
  "",
  ...failures.flatMap((failure, index) => [
    `Failure ${index + 1}`,
    `timestamp: ${failure.timestamp}`,
    `intent: ${failure.intent}`,
    `source_app_id: ${failure.source_app_id}`,
    `explanation: ${failure.explanation}`,
    ""
  ])
].join("\n");

fs.writeFileSync(reportFile, report, { mode: 0o600 });
console.log(`SUCCESS: Wrote ${failures.length} failed routing event(s) to ${reportFile}`);
