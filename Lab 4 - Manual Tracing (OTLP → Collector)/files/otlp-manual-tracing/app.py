from flask import Flask, jsonify
import time
import random
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.resources import Resource

# Initialize Flask app
app = Flask(__name__)

# Configure OpenTelemetry
def configure_opentelemetry():
    # Create resource with service information
    resource = Resource.create({
        "service.name": "manual-tracing-app",
        "service.version": "1.0.0",
    })

    # Set up tracer provider
    trace.set_tracer_provider(TracerProvider(resource=resource))

    # Configure OTLP exporter to send to localhost:4317
    otlp_exporter = OTLPSpanExporter(
        endpoint="http://localhost:4317",
        insecure=True
    )

    # Add span processor
    span_processor = BatchSpanProcessor(otlp_exporter)
    trace.get_tracer_provider().add_span_processor(span_processor)

# Initialize OpenTelemetry
configure_opentelemetry()

# Get tracer
tracer = trace.get_tracer(__name__)

@app.route('/')
def home():
    return jsonify({"message": "Manual Tracing Lab - Use /work endpoint"})

@app.route('/work')
def work_endpoint():
    # Create parent span for the entire work operation
    with tracer.start_as_current_span("work_operation") as parent_span:
        # Add attributes to parent span
        parent_span.set_attribute("http.method", "GET")
        parent_span.set_attribute("http.route", "/work")
        parent_span.set_attribute("operation.type", "manual_work")

        # Simulate data preparation work
        with tracer.start_as_current_span("data_preparation") as prep_span:
            prep_span.set_attribute("step", "preparation")
            prep_span.add_event("Starting data preparation")

            # Simulate some work
            time.sleep(0.1)
            data_size = random.randint(100, 1000)
            prep_span.set_attribute("data.size", data_size)
            prep_span.add_event("Data preparation completed", {"records": data_size})

        # Simulate processing work
        with tracer.start_as_current_span("data_processing") as process_span:
            process_span.set_attribute("step", "processing")
            process_span.add_event("Starting data processing")

            # Simulate processing time
            processing_time = random.uniform(0.05, 0.2)
            time.sleep(processing_time)

            process_span.set_attribute("processing.duration_ms", int(processing_time * 1000))
            process_span.add_event("Processing completed successfully")

        # Simulate result generation
        with tracer.start_as_current_span("result_generation") as result_span:
            result_span.set_attribute("step", "result_generation")
            result_span.add_event("Generating results")

            time.sleep(0.05)
            result_count = random.randint(10, 50)
            result_span.set_attribute("result.count", result_count)
            result_span.add_event("Results generated", {"count": result_count})

        # Add final attributes to parent span
        parent_span.set_attribute("operation.success", True)
        parent_span.add_event("Work operation completed successfully")

        return jsonify({
            "status": "success",
            "message": "Work completed with manual tracing",
            "data_processed": data_size,
            "results_generated": result_count,
            "processing_time_ms": int(processing_time * 1000)
        })

if __name__ == '__main__':
    print("Starting Flask app with manual tracing...")
    print("OpenTelemetry configured to send traces to localhost:4317")
    app.run(host='0.0.0.0', port=5000, debug=True)
