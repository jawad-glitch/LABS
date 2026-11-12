#!/usr/bin/env python3
"""Counter service (port 8001): http_requests_total{method,endpoint,status_code}, application_errors_total{error_type,component}."""
import os, random, threading, time
from prometheus_client import Counter, start_http_server
PORT, APP_NAME = int(os.environ.get("PORT", 8001)), os.environ.get("APP_NAME", "counter_app")
HTTP_REQUESTS = Counter("http_requests_total", "Total HTTP requests handled", ["method", "endpoint", "status_code"])
APP_ERRORS = Counter("application_errors_total", "Total application errors", ["error_type", "component"])
ENDPOINTS = [("GET", "/api/orders"), ("POST", "/api/orders"), ("GET", "/api/users"), ("GET", "/healthz")]
STATUSES = [("200", 0.90), ("404", 0.04), ("500", 0.04), ("503", 0.02)]
ERRORS = [("timeout", "db"), ("validation", "api"), ("connection_reset", "cache")]

class TrafficSimulator:
    def run_forever(self) -> None:
        while True:
            for _ in range(random.randint(5, 15)):
                method, endpoint = random.choice(ENDPOINTS)
                status = random.choices([s for s, _ in STATUSES], [w for _, w in STATUSES])[0]
                HTTP_REQUESTS.labels(method, endpoint, status).inc()          # counters only ever go up
                if status.startswith("5"):
                    APP_ERRORS.labels(*random.choice(ERRORS)).inc()
            time.sleep(0.2)

def main() -> None:
    start_http_server(PORT)
    t = threading.Thread(target=TrafficSimulator().run_forever, daemon=True); t.start()
    with open(f"/tmp/{APP_NAME}.pid", "w") as f: f.write(str(os.getpid()))
    try:
        while True: time.sleep(1)
    except KeyboardInterrupt:
        pass

if __name__ == "__main__":
    main()
