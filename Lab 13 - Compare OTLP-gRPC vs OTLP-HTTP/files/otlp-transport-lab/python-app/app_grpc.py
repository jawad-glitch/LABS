#!/usr/bin/env python3

import time
import random
from opentelemetry import trace, metrics
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.sdk.metrics import MeterProvider
from opentelemetry.sdk.metrics.export import PeriodicExportingMetricReader
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.exporter.otlp.proto.grpc.metric_exporter import OTLPMetricExporter
from opentelemetry.sdk.resources import Resource

def setup_telemetry_grpc():
    """Configure OpenTelemetry to use gRPC transport"""

    # Create resource
    resource = Resource.create({
        "service.name": "sample-app-grpc",
        "service.version": "1.0.0",
        "transport.protocol": "grpc"
    })

    # Configure tracing with gRPC exporter
    trace_exporter = OTLPSpanExporter(
        endpoint="http://localhost:4317",
        insecure=True,
        headers={}
    )

    tracer_provider = TracerProvider(resource=resource)
    span_processor = BatchSpanProcessor(trace_exporter)
    tracer_provider.add_span_processor(span_processor)
    trace.set_tracer_provider(tracer_provider)

    # Configure metrics with gRPC exporter
    metric_exporter = OTLPMetricExporter(
        endpoint="http://localhost:4317",
        insecure=True,
        headers={}
    )

    metric_reader = PeriodicExportingMetricReader(
        exporter=metric_exporter,
        export_interval_millis=5000
    )

    meter_provider = MeterProvider(
        resource=resource,
        metric_readers=[metric_reader]
    )
    metrics.set_meter_provider(meter_provider)

    # Return from THIS provider: the global provider can only be set once per process,
    # so trace.get_tracer() would hand the HTTP thread the gRPC provider in test_both_transports.py
    return tracer_provider.get_tracer(__name__), meter_provider.get_meter(__name__)

def generate_telemetry_data(tracer, meter):
    """Generate sample traces and metrics"""

    # Create a counter metric
    request_counter = meter.create_counter(
        name="requests_total",
        description="Total number of requests",
        unit="1"
    )

    # Create a histogram metric
    request_duration = meter.create_histogram(
        name="request_duration_seconds",
        description="Request duration in seconds",
        unit="s"
    )

    print("Generating telemetry data using gRPC transport...")

    for i in range(10):
        # Create a trace
        with tracer.start_as_current_span(f"grpc-operation-{i}") as span:
            span.set_attribute("operation.type", "grpc-test")
            span.set_attribute("iteration", i)

            # Simulate some work
            duration = random.uniform(0.1, 2.0)
            time.sleep(duration)

            # Record metrics
            request_counter.add(1, {"method": "GET", "transport": "grpc"})
            request_duration.record(duration, {"method": "GET", "transport": "grpc"})

            span.set_attribute("duration", duration)
            print(f"Generated span {i+1}/10 via gRPC (duration: {duration:.2f}s)")

    print("Completed generating telemetry data via gRPC")

if __name__ == "__main__":
    tracer, meter = setup_telemetry_grpc()
    generate_telemetry_data(tracer, meter)

    # Allow time for final export
    print("Waiting for final export...")
    time.sleep(10)
    print("gRPC export test completed")
