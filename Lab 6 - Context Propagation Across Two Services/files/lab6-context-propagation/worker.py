#!/usr/bin/env python3

import logging
from flask import Flask, jsonify
from flask import request
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import ConsoleSpanExporter, BatchSpanProcessor
from opentelemetry.instrumentation.flask import FlaskInstrumentor
import time

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Initialize OpenTelemetry
trace.set_tracer_provider(TracerProvider())
tracer = trace.get_tracer(__name__)

# Configure console exporter for spans
console_exporter = ConsoleSpanExporter()
span_processor = BatchSpanProcessor(console_exporter)
trace.get_tracer_provider().add_span_processor(span_processor)

# Create Flask app
app = Flask(__name__)

# Instrument Flask with OpenTelemetry
FlaskInstrumentor().instrument_app(app)

@app.route('/do')
def do_work():
    """
    Worker endpoint that performs some simulated work
    """
    logger.info("Worker service received request at /do endpoint")

    # Log W3C Trace Context headers
    traceparent = request.headers.get('traceparent')
    tracestate = request.headers.get('tracestate')

    if traceparent:
        logger.info(f"Received traceparent header: {traceparent}")
    if tracestate:
        logger.info(f"Received tracestate header: {tracestate}")

    # Create a custom span for the work being done
    with tracer.start_as_current_span("worker_processing") as span:
        span.set_attribute("worker.task", "data_processing")
        span.set_attribute("worker.duration", 2)

        # Simulate some work
        logger.info("Worker is processing data...")
        time.sleep(2)

        # Add more detailed work simulation
        with tracer.start_as_current_span("database_query") as db_span:
            db_span.set_attribute("db.operation", "SELECT")
            db_span.set_attribute("db.table", "users")
            time.sleep(0.5)
            logger.info("Database query completed")

        with tracer.start_as_current_span("data_transformation") as transform_span:
            transform_span.set_attribute("transform.type", "json_to_xml")
            time.sleep(0.3)
            logger.info("Data transformation completed")

        result = {
            "status": "success",
            "message": "Work completed successfully",
            "processed_items": 42,
            "processing_time": 2.8
        }

        span.set_attribute("worker.result", "success")
        span.set_attribute("worker.items_processed", 42)

        logger.info(f"Worker completed processing: {result}")
        return jsonify(result)

@app.route('/health')
def health_check():
    """
    Health check endpoint
    """
    return jsonify({"status": "healthy", "service": "worker"})

if __name__ == '__main__':
    logger.info("Starting Worker Service on port 9000")
    app.run(host='0.0.0.0', port=9000, debug=True)
