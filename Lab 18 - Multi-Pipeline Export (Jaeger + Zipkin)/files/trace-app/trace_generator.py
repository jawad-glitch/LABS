#!/usr/bin/env python3

import time
import requests
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.instrumentation.requests import RequestsInstrumentor

# Configure OpenTelemetry (service.name comes from OTEL_SERVICE_NAME)
trace.set_tracer_provider(TracerProvider())
tracer = trace.get_tracer(__name__)

# Configure OTLP exporter
otlp_exporter = OTLPSpanExporter(
    endpoint="http://localhost:4317",
    insecure=True
)

# Add span processor
span_processor = BatchSpanProcessor(otlp_exporter)
trace.get_tracer_provider().add_span_processor(span_processor)

# Auto-instrument requests
RequestsInstrumentor().instrument()

def create_sample_traces():
    """Generate sample traces with multiple spans"""

    with tracer.start_as_current_span("main-operation") as main_span:
        main_span.set_attribute("operation.type", "multi-export-demo")
        main_span.set_attribute("lab.number", "18")

        # Simulate database operation
        with tracer.start_as_current_span("database-query") as db_span:
            db_span.set_attribute("db.system", "postgresql")
            db_span.set_attribute("db.operation", "SELECT")
            db_span.set_attribute("db.table", "users")
            time.sleep(0.1)  # Simulate query time

        # Simulate API call
        with tracer.start_as_current_span("external-api-call") as api_span:
            api_span.set_attribute("http.method", "GET")
            api_span.set_attribute("http.url", "https://api.example.com/data")
            api_span.set_attribute("http.status_code", 200)
            time.sleep(0.2)  # Simulate API response time

        # Simulate processing
        with tracer.start_as_current_span("data-processing") as process_span:
            process_span.set_attribute("processing.type", "transformation")
            process_span.set_attribute("records.count", 150)
            time.sleep(0.15)  # Simulate processing time

            # Nested span for detailed processing
            with tracer.start_as_current_span("data-validation") as validation_span:
                validation_span.set_attribute("validation.rules", 5)
                validation_span.set_attribute("validation.passed", True)
                time.sleep(0.05)

        main_span.set_attribute("operation.status", "completed")
        print("Sample trace generated successfully!")

if __name__ == "__main__":
    print("Starting multi-export trace generation...")

    # Generate multiple traces
    for i in range(3):
        print(f"Generating trace {i+1}/3...")
        create_sample_traces()
        time.sleep(1)  # Wait between traces

    # Allow time for export
    print("Waiting for trace export to complete...")
    time.sleep(5)
    print("Trace generation completed!")
