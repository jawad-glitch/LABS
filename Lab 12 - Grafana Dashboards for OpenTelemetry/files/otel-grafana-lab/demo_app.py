#!/usr/bin/env python3
"""HTTP API instrumented with the OpenTelemetry metrics SDK (feeds the Grafana dashboard)."""
import json, random, time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from opentelemetry import metrics
from opentelemetry.sdk.metrics import MeterProvider
from opentelemetry.sdk.metrics.export import PeriodicExportingMetricReader
from opentelemetry.sdk.metrics.view import View, ExplicitBucketHistogramAggregation
from opentelemetry.sdk.resources import Resource
from opentelemetry.exporter.otlp.proto.http.metric_exporter import OTLPMetricExporter

resource = Resource.create({"service.name": "demo-http-api", "service.version": "1.0.0"})
reader = PeriodicExportingMetricReader(OTLPMetricExporter(endpoint="http://localhost:4318/v1/metrics"), export_interval_millis=5000)
# SDK default buckets are millisecond-scale; latencies here are recorded in SECONDS
latency_view = View(instrument_name="http_request_duration_seconds",
                    aggregation=ExplicitBucketHistogramAggregation([0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5]))
metrics.set_meter_provider(MeterProvider(resource=resource, metric_readers=[reader], views=[latency_view]))
meter = metrics.get_meter("lab12-demo", "1.0.0")
requests_total = meter.create_counter("http_requests_total", description="Total HTTP requests")
duration = meter.create_histogram("http_request_duration_seconds", unit="s", description="HTTP request latency")

ROUTES = {"/api/users": (0.01, 0.12, 0.03), "/api/orders": (0.05, 0.40, 0.10)}  # min s, max s, error ratio

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        start = time.time()
        if self.path in ROUTES:
            lo, hi, err = ROUTES[self.path]
            time.sleep(random.uniform(lo, hi))
            code = 500 if random.random() < err else 200
        else:
            code = 404
        body = json.dumps({"path": self.path, "status": code}).encode()
        self.send_response(code); self.send_header("Content-Type", "application/json"); self.end_headers(); self.wfile.write(body)
        attrs = {"method": "GET", "status_code": str(code), "route": self.path}
        requests_total.add(1, attrs)
        duration.record(time.time() - start, attrs)
    def log_message(self, *a):
        pass

if __name__ == "__main__":
    ThreadingHTTPServer(("", 8080), Handler).serve_forever()
