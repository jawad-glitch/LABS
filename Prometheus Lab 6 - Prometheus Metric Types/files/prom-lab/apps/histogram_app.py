#!/usr/bin/env python3
"""Histogram service (port 8003): http_request_duration_seconds{method,endpoint}, db_query_duration_seconds{query_type}.
SCALE multiplies every latency (used to run a second, slower instance for the aggregation comparison)."""
import math, os, random, threading, time
from prometheus_client import Histogram, start_http_server
PORT, APP_NAME, SCALE = int(os.environ.get("PORT", 8003)), os.environ.get("APP_NAME", "histogram_app"), float(os.environ.get("SCALE", 1))
REQ = Histogram("http_request_duration_seconds", "HTTP request latency", ["method", "endpoint"],
                buckets=(0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1.0, 2.5, float("inf")))
DB = Histogram("db_query_duration_seconds", "Database query latency", ["query_type"],
               buckets=(0.001, 0.005, 0.01, 0.05, 0.1, 0.5, 1.0, float("inf")))
ENDPOINTS = [("GET", "/api/orders"), ("POST", "/api/orders"), ("GET", "/api/users")]
REQ_MU, REQ_SIGMA = math.log(0.08), 0.6          # lognormal: median 80 ms
DB_MEDIAN = {"select": 0.004, "insert": 0.012, "update": 0.02}

class RequestSimulator:
    def observe_request(self, method: str, endpoint: str) -> None:
        REQ.labels(method, endpoint).observe(random.lognormvariate(REQ_MU, REQ_SIGMA) * SCALE)
        qt = random.choice(list(DB_MEDIAN)); DB.labels(qt).observe(random.lognormvariate(math.log(DB_MEDIAN[qt]), 0.7) * SCALE)

def simulate() -> None:
    sim = RequestSimulator()
    while True:
        for m, e in ENDPOINTS: sim.observe_request(m, e)
        time.sleep(0.05)

def main() -> None:
    start_http_server(PORT)
    t = threading.Thread(target=simulate, daemon=True); t.start()
    with open(f"/tmp/{APP_NAME}.pid", "w") as f: f.write(str(os.getpid()))
    try:
        while True: time.sleep(1)
    except KeyboardInterrupt:
        pass

if __name__ == "__main__":
    main()
