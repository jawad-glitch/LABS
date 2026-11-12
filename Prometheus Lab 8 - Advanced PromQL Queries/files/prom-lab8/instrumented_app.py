#!/usr/bin/env python3
"""HTTP on :8000 (/api/products fast, /api/checkout slow with a tail), metrics on :8001.
Generates 200 requests at start-up, then steady traffic so rate() windows stay populated."""
import math, random, threading, time, urllib.request
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from prometheus_client import Histogram, start_http_server

BUCKETS = [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1.0, 2.5]
ENDPOINTS = {"/api/products": 0.7, "/api/checkout": 0.3}

class LatencySimulator:
    """Generates request durations that produce a non-trivial histogram shape."""
    def sample_duration(self, endpoint: str) -> float:
        if endpoint == "/api/products":                                   # fast: median 20 ms
            d = random.lognormvariate(math.log(0.02), 0.6)
        elif random.random() < 0.85:                                      # checkout: median 120 ms ...
            d = random.lognormvariate(math.log(0.12), 0.5)
        else:                                                             # ... plus a 15% slow tail around 800 ms
            d = random.lognormvariate(math.log(0.8), 0.4)
        return min(max(d, 0.0), 2.4)                                      # stay inside the last finite bucket

class InstrumentedHandler:
    """HTTP request handler that records latency into a Prometheus Histogram."""
    def __init__(self):
        self.simulator = LatencySimulator()
        self.histogram = Histogram("http_request_duration_seconds", "Simulated HTTP request latency", ["endpoint"], buckets=BUCKETS)
    def handle_request(self, endpoint: str) -> None:
        duration = self.simulator.sample_duration(endpoint)
        time.sleep(duration)
        self.histogram.labels(endpoint=endpoint).observe(duration)

HANDLER = InstrumentedHandler()

class HTTP(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path not in ENDPOINTS:
            self.send_response(404); self.end_headers(); return
        HANDLER.handle_request(self.path)
        body = b'{"ok": true}\n'
        self.send_response(200); self.send_header("Content-Type", "application/json"); self.send_header("Content-Length", str(len(body)))
        self.end_headers(); self.wfile.write(body)
    def log_message(self, *args):
        pass

class RequestGenerator:
    """Drives the handler (through the real HTTP endpoint) with a 70/30 split across two endpoints."""
    def run(self, handler: InstrumentedHandler, total_requests: int, concurrency: int = 12) -> None:
        eps, weights, lock, sent = list(ENDPOINTS), list(ENDPOINTS.values()), threading.Lock(), [0]
        def worker():
            while True:
                with lock:
                    if sent[0] >= total_requests: return
                    sent[0] += 1
                try: urllib.request.urlopen("http://127.0.0.1:8000" + random.choices(eps, weights)[0], timeout=5).read()
                except Exception: pass
        threads = [threading.Thread(target=worker, daemon=True) for _ in range(concurrency)]
        for t in threads: t.start()
        for t in threads: t.join()

def main() -> None:
    start_http_server(8001)
    server = ThreadingHTTPServer(("0.0.0.0", 8000), HTTP)
    threading.Thread(target=server.serve_forever, daemon=True).start()
    gen = RequestGenerator()
    gen.run(HANDLER, 200); print("initial 200 requests done", flush=True)
    while True:
        gen.run(HANDLER, 20, concurrency=4); time.sleep(1)

if __name__ == "__main__":
    main()
