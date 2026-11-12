#!/usr/bin/env python3
"""Gauge service (port 8002): active_sessions{service}, queue_depth{queue_name}, system_memory_used_bytes (no labels - lab contract)."""
import os, random, threading, time
import psutil
from prometheus_client import Gauge, start_http_server
PORT, APP_NAME = int(os.environ.get("PORT", 8002)), os.environ.get("APP_NAME", "gauge_app")
ACTIVE_SESSIONS = Gauge("active_sessions", "Currently active user sessions", ["service"])
QUEUE_DEPTH = Gauge("queue_depth", "Items currently waiting in a queue", ["queue_name"])
MEMORY_USED = Gauge("system_memory_used_bytes", "Memory in use on this host right now")

class SystemPoller:
    def __init__(self):
        self.sessions = {"web": 120, "mobile": 60, "admin": 4}
        self.queues = {"emails": 10, "payments": 3, "reports": 0}
    def poll_and_set(self) -> None:
        for s in self.sessions:                                   # gauges go up AND down
            self.sessions[s] = max(0, self.sessions[s] + random.randint(-8, 8)); ACTIVE_SESSIONS.labels(s).set(self.sessions[s])
        for q in self.queues:
            self.queues[q] = max(0, self.queues[q] + random.randint(-3, 4)); QUEUE_DEPTH.labels(q).set(self.queues[q])
        MEMORY_USED.set(psutil.virtual_memory().used)

def simulate() -> None:
    p = SystemPoller()
    while True:
        p.poll_and_set(); time.sleep(2)

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
