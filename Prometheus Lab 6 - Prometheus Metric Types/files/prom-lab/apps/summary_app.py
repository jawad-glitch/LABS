#!/usr/bin/env python3
"""Summary service (port 8004): rpc_call_duration_seconds{service,method}, cache_operation_duration_seconds{cache_type,operation}.
SUMMARY_MODE=client  -> prometheus_client.Summary as the lab implies (Python client: _count/_sum only, NO quantiles)
SUMMARY_MODE=quantile -> custom collector computing client-side quantiles over a 60 s sliding window (type summary + quantile series)"""
import bisect, collections, math, os, random, threading, time
from prometheus_client import Summary, start_http_server, REGISTRY
from prometheus_client.core import Metric
PORT, APP_NAME = int(os.environ.get("PORT", 8004)), os.environ.get("APP_NAME", "summary_app")
MODE, SCALE = os.environ.get("SUMMARY_MODE", "quantile"), float(os.environ.get("SCALE", 1))
QUANTILES, WINDOW = (0.5, 0.9, 0.99), 60.0

class QuantileSummary:
    """Client-side quantiles over a sliding time window, exposed in the summary exposition format."""
    def __init__(self, name, doc, labelnames):
        self.name, self.doc, self.labelnames = name, doc, labelnames
        self.lock = threading.Lock(); self.window = collections.defaultdict(collections.deque); self.count = collections.Counter(); self.sum = collections.Counter()
        REGISTRY.register(self)
    def labels(self, *values):
        parent = self
        class _Child:
            def observe(self, v):
                now = time.time()
                with parent.lock:
                    w = parent.window[values]; w.append((now, v)); parent.count[values] += 1; parent.sum[values] += v
                    while w and w[0][0] < now - WINDOW: w.popleft()
        return _Child()
    def collect(self):
        m = Metric(self.name, self.doc, "summary")
        with self.lock:
            for values, w in self.window.items():
                lbl = dict(zip(self.labelnames, values)); data = sorted(v for _, v in w)
                for q in QUANTILES:
                    if data: m.add_sample(self.name, dict(lbl, quantile=str(q)), data[min(len(data) - 1, int(math.ceil(q * len(data))) - 1)])
                m.add_sample(self.name + "_count", lbl, self.count[values]); m.add_sample(self.name + "_sum", lbl, self.sum[values])
        yield m

def make(name, doc, labels):
    return Summary(name, doc, labels) if MODE == "client" else QuantileSummary(name, doc, labels)
RPC = make("rpc_call_duration_seconds", "RPC call duration", ["service", "method"])
CACHE = make("cache_operation_duration_seconds", "Cache operation duration", ["cache_type", "operation"])
RPCS = [("payments", "Charge"), ("payments", "Refund"), ("inventory", "Reserve")]
CACHES = [("redis", "get"), ("redis", "set"), ("local", "get")]

class LatencySimulator:
    def observe_operation(self, operation: str) -> None:
        svc, meth = random.choice(RPCS) if operation == "rpc" else (None, None)
        if operation == "rpc": RPC.labels(svc, meth).observe(random.lognormvariate(math.log(0.05), 0.5) * SCALE)
        else: CACHE.labels(*random.choice(CACHES)).observe(random.lognormvariate(math.log(0.0008), 0.6) * SCALE)

def simulate() -> None:
    sim = LatencySimulator()
    while True:
        for _ in range(3): sim.observe_operation("rpc")
        sim.observe_operation("cache"); time.sleep(0.05)

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
