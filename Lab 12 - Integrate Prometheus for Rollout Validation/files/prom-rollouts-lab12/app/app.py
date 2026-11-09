import os, random, time, threading
from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler
ERR = float(os.environ.get("ERROR_RATE", "0")); VER = os.environ.get("VERSION", "v1")
lock = threading.Lock(); req = {}; LE = [0.1, 0.5, 1.0]; buckets = [0, 0, 0]; state = {"count": 0, "sum": 0.0}
class H(BaseHTTPRequestHandler):
    def log_message(self, *a): pass
    def do_GET(self):
        if self.path == "/metrics":
            with lock:
                out = ["# HELP http_requests_total Total HTTP requests", "# TYPE http_requests_total counter"]
                out += ['http_requests_total{method="%s",status="%s"} %d' % (m, s, v) for (m, s), v in sorted(req.items())]
                out += ["# HELP response_time_seconds Response time in seconds", "# TYPE response_time_seconds histogram"]
                out += ['response_time_seconds_bucket{le="%s"} %d' % (le, b) for le, b in zip(LE, buckets)]
                out += ['response_time_seconds_bucket{le="+Inf"} %d' % state["count"], "response_time_seconds_sum %f" % state["sum"], "response_time_seconds_count %d" % state["count"]]
            body = ("\n".join(out) + "\n").encode()
            self.send_response(200); self.send_header("Content-Type", "text/plain; version=0.0.4"); self.end_headers(); self.wfile.write(body); return
        t0 = time.time(); status = 500 if random.random() < ERR else 200
        body = ("sample-app %s\n" % VER).encode(); self.send_response(status); self.end_headers(); self.wfile.write(body)
        d = time.time() - t0
        with lock:
            req[("GET", str(status))] = req.get(("GET", str(status)), 0) + 1; state["count"] += 1; state["sum"] += d
            for i, le in enumerate(LE):
                if d <= le: buckets[i] += 1
ThreadingHTTPServer(("", 8080), H).serve_forever()
