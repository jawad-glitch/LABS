#!/usr/bin/env python3
"""Lab 15 telemetry generator: traces + metrics over OTLP/gRPC (no TLS)."""
import os
import random
import signal
import time

from opentelemetry.exporter.otlp.proto.grpc.metric_exporter import OTLPMetricExporter
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.metrics import MeterProvider
from opentelemetry.sdk.metrics.export import PeriodicExportingMetricReader
from opentelemetry.sdk.resources import SERVICE_NAME, SERVICE_VERSION, Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor


class TelemetryGenerator:
    def __init__(self, otlp_endpoint: str, service_name: str, service_version: str) -> None:
        """Configure TracerProvider and MeterProvider with a Resource carrying service.name and
        service.version; both export to otlp_endpoint via OTLP/gRPC with no TLS.
        Resource.create() also merges OTEL_RESOURCE_ATTRIBUTES and the detectors listed in
        OTEL_EXPERIMENTAL_RESOURCE_DETECTORS (e.g. 'process' -> process.pid, process.executable.name)."""
        resource = Resource.create({SERVICE_NAME: service_name, SERVICE_VERSION: service_version})
        self.tracer_provider = TracerProvider(resource=resource)
        self.tracer_provider.add_span_processor(
            BatchSpanProcessor(OTLPSpanExporter(endpoint=otlp_endpoint, insecure=True)))
        reader = PeriodicExportingMetricReader(
            OTLPMetricExporter(endpoint=otlp_endpoint, insecure=True), export_interval_millis=10000)
        self.meter_provider = MeterProvider(resource=resource, metric_readers=[reader])
        self.tracer = self.tracer_provider.get_tracer("lab15.generator", "1.0.0")
        meter = self.meter_provider.get_meter("lab15.generator", "1.0.0")
        self.requests_total = meter.create_counter("http_requests_total", description="Total HTTP requests")
        self.request_duration = meter.create_histogram(
            "http_request_duration_seconds", unit="s", description="HTTP request duration")
        self.iterations = 0

    def emit_trace(self, operation_name: str, child_operation: str) -> None:
        """Root span + one child span; >=2 attributes on root, 1 on child; 50-500 ms in each."""
        with self.tracer.start_as_current_span(operation_name) as root:
            root.set_attribute("http.method", "GET")
            root.set_attribute("http.route", "/api/orders")
            root.set_attribute("generator.iteration", self.iterations)
            time.sleep(random.uniform(0.05, 0.5))
            with self.tracer.start_as_current_span(child_operation) as child:
                child.set_attribute("db.system", "postgresql")
                time.sleep(random.uniform(0.05, 0.5))

    def emit_metrics(self) -> None:
        """One Counter increment (method, status_code) and one Histogram observation (endpoint)."""
        status_code = random.choice(["200"] * 9 + ["500"])
        self.requests_total.add(1, {"method": "GET", "status_code": status_code})
        self.request_duration.record(random.uniform(0.05, 0.5), {"endpoint": "/api/orders"})

    def run(self, interval_seconds: int) -> None:
        """Loop emit_trace + emit_metrics; on KeyboardInterrupt flush all providers before exit."""
        try:
            while True:
                self.iterations += 1
                self.emit_trace("process_order", "query_inventory")
                self.emit_metrics()
                print(f"iteration {self.iterations}: emitted trace (process_order > query_inventory) + metrics", flush=True)
                time.sleep(interval_seconds)
        except KeyboardInterrupt:
            print("KeyboardInterrupt received - flushing providers", flush=True)
        finally:
            self.tracer_provider.force_flush()
            self.meter_provider.force_flush()
            self.tracer_provider.shutdown()
            self.meter_provider.shutdown()
            print(f"providers flushed and shut down cleanly after {self.iterations} iterations", flush=True)


def _sigterm(*_):
    raise KeyboardInterrupt


if __name__ == "__main__":
    signal.signal(signal.SIGTERM, _sigterm)
    TelemetryGenerator(
        otlp_endpoint=os.getenv("OTLP_ENDPOINT", "localhost:4317"),
        service_name="sample-app",
        service_version="1.0.0",
    ).run(interval_seconds=int(os.getenv("INTERVAL_SECONDS", "2")))
