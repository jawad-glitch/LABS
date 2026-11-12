#!/usr/bin/env python3
"""Metrics simulator on :8080/metrics. Each 120 s cycle starts with a 30 s incident (traffic surge, ~90% 5xx,
database errors) followed by 90 s of normal traffic (~5% 5xx). Exposition format written by hand (stdlib only)."""
import http.server, socketserver, threading, time, random

BUCKETS = [0.05, 0.1, 0.25, 0.5, 1.0, 2.5, 5.0]
CYCLE, INCIDENT = 120, 30

class MetricsState:
    def __init__(self):
        self.t0 = time.time(); self.lock = threading.Lock()
        self.requests = {"2xx": 0, "5xx": 0}; self.app_errors = {"database": 0, "cache": 0, "external_api": 0}
        self.h_count = 0; self.h_sum = 0.0; self.h_buckets = [0] * len(BUCKETS)
        threading.Thread(target=self._tick, daemon=True).start()
    def degraded(self) -> bool:
        return (time.time() - self.t0) % CYCLE < INCIDENT
    def error_rate(self) -> float:
        return 0.90 if self.degraded() else 0.05
    def avg_duration_seconds(self) -> float:
        return 0.6 if self.degraded() else 0.15
    def app_error_counts(self) -> dict:
        with self.lock: return dict(self.app_errors)
    def _tick(self):
        while True:
            deg = self.degraded(); n = 200 if deg else 20
            with self.lock:
                for _ in range(n):
                    self.requests["5xx" if random.random() < self.error_rate() else "2xx"] += 1
                    d = random.expovariate(1.0 / self.avg_duration_seconds())
                    self.h_count += 1; self.h_sum += d
                    for i, b in enumerate(BUCKETS):
                        if d <= b: self.h_buckets[i] += 1
                self.app_errors["database"] += random.randint(10, 20) if deg else random.randint(0, 1)
                self.app_errors["cache"] += random.randint(1, 3) if deg else (1 if random.random() < 0.1 else 0)
                self.app_errors["external_api"] += random.randint(2, 5) if deg else (1 if random.random() < 0.1 else 0)
            time.sleep(1)
    def exposition(self) -> str:
        with self.lock:
            out = ["# HELP http_requests_total Total HTTP requests by status class.", "# TYPE http_requests_total counter"]
            out += ['http_requests_total{status="%s"} %d' % (k, v) for k, v in self.requests.items()]
            out += ["# HELP http_request_duration_seconds HTTP request duration.", "# TYPE http_request_duration_seconds histogram"]
            out += ['http_request_duration_seconds_bucket{le="%s"} %d' % (b, c) for b, c in zip(BUCKETS, self.h_buckets)]
            out += ['http_request_duration_seconds_bucket{le="+Inf"} %d' % self.h_count, "http_request_duration_seconds_sum %f" % self.h_sum, "http_request_duration_seconds_count %d" % self.h_count]
            out += ["# HELP application_errors_total Application errors by subtype.", "# TYPE application_errors_total counter"]
            out += ['application_errors_total{type="%s"} %d' % (k, v) for k, v in self.app_errors.items()]
        return "\n".join(out) + "\n"

STATE = MetricsState()

class MetricsHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self) -> None:
        if self.path != "/metrics":
            self.send_response(404); self.end_headers(); return
        body = STATE.exposition().encode()
        self.send_response(200); self.send_header("Content-Type", "text/plain; version=0.0.4"); self.send_header("Content-Length", str(len(body)))
        self.end_headers(); self.wfile.write(body)
    def log_message(self, fmt, *args) -> None:
        pass

class SimulatorServer:
    def __init__(self, port: int, state: MetricsState) -> None:
        self.port, self.state = port, state
    def start(self) -> None:
        socketserver.ThreadingTCPServer.allow_reuse_address = True
        with socketserver.ThreadingTCPServer(("0.0.0.0", self.port), MetricsHandler) as s: s.serve_forever()

if __name__ == "__main__":
    SimulatorServer(8080, STATE).start()
