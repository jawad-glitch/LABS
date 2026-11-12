#!/usr/bin/env python3
"""Webhook receiver on :8081 - any path is a receiver name. Prints a summary per alert and appends the raw JSON to logs/webhook.log."""
import http.server, json, datetime, os
LOG = os.path.expanduser("~/alerting-lab/logs/webhook.log")

class AlertPayload:
    def __init__(self, raw: dict):
        self.status: str = raw.get("status", "")
        self.alerts: list = raw.get("alerts", [])

class WebhookHandler(http.server.BaseHTTPRequestHandler):
    def do_POST(self) -> None:
        raw = json.loads(self.rfile.read(int(self.headers.get("Content-Length", 0))) or b"{}")
        p, ts = AlertPayload(raw), datetime.datetime.now(datetime.timezone.utc).isoformat(timespec="seconds")
        for a in p.alerts:
            l, an = a.get("labels", {}), a.get("annotations", {})
            print("RECEIVED path=%s time=%s status=%s alertname=%s severity=%s instance=%s summary=%s"
                  % (self.path, ts, a.get("status", p.status), l.get("alertname"), l.get("severity"), l.get("instance", "-"), an.get("summary")), flush=True)
        with open(LOG, "a") as f: f.write(json.dumps({"path": self.path, "received": ts, "payload": raw}) + "\n")
        body = b'{"status": "received"}'
        self.send_response(200); self.send_header("Content-Type", "application/json"); self.send_header("Content-Length", str(len(body))); self.end_headers(); self.wfile.write(body)
    def log_message(self, fmt, *args) -> None:
        pass

if __name__ == "__main__":
    http.server.ThreadingHTTPServer(("0.0.0.0", 8081), WebhookHandler).serve_forever()
