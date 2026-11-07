#!/usr/bin/env python3

import logging
import requests
from flask import Flask, jsonify
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import ConsoleSpanExporter, BatchSpanProcessor
from opentelemetry.instrumentation.flask import FlaskInstrumentor
from opentelemetry.instrumentation.requests import RequestsInstrumentor
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

# Instrument Flask and Requests with OpenTelemetry
FlaskInstrumentor().instrument_app(app)
RequestsInstrumentor().instrument()

@app.route('/process')
def process_request():
    """
    Main endpoint that orchestrates work by calling the worker service
    """
    logger.info("Main service received request at /process endpoint")

    with tracer.start_as_current_span("main_processing") as span:
        span.set_attribute("main.operation", "orchestrate_work")
        span.set_attribute("main.worker_url", "http://localhost:9000/do")

        try:
            # Add some pre-processing work
            with tracer.start_as_current_span("pre_processing") as pre_span:
                pre_span.set_attribute("pre.task", "validation")
                logger.info("Performing pre-processing validation...")
                time.sleep(0.5)

            # Make HTTP request to worker service
            logger.info("Calling worker service at http://localhost:9000/do")

            with tracer.start_as_current_span("call_worker_service") as call_span:
                call_span.set_attribute("http.method", "GET")
                call_span.set_attribute("http.url", "http://localhost:9000/do")

                # This request will automatically propagate trace context
                response = requests.get("http://localhost:9000/do", timeout=10)

                call_span.set_attribute("http.status_code", response.status_code)
                call_span.set_attribute("http.response_size", len(response.content))

            if response.status_code == 200:
                worker_result = response.json()
                logger.info(f"Worker service responded successfully: {worker_result}")

                # Add some post-processing work
                with tracer.start_as_current_span("post_processing") as post_span:
                    post_span.set_attribute("post.task", "result_aggregation")
                    logger.info("Performing post-processing aggregation...")
                    time.sleep(0.3)

                final_result = {
                    "status": "completed",
                    "message": "Request processed successfully",
                    "worker_response": worker_result,
                    "total_processing_time": 3.3,
                    "main_service": "app.py"
                }

                span.set_attribute("main.result", "success")
                span.set_attribute("main.total_time", 3.3)

                return jsonify(final_result)
            else:
                error_msg = f"Worker service returned error: {response.status_code}"
                logger.error(error_msg)
                span.set_attribute("main.result", "error")
                span.set_attribute("error.message", error_msg)
                return jsonify({"error": error_msg}), 500

        except requests.exceptions.RequestException as e:
            error_msg = f"Failed to connect to worker service: {str(e)}"
            logger.error(error_msg)
            span.set_attribute("main.result", "error")
            span.set_attribute("error.message", error_msg)
            return jsonify({"error": error_msg}), 500

@app.route('/health')
def health_check():
    """
    Health check endpoint
    """
    return jsonify({"status": "healthy", "service": "main"})

@app.route('/')
def index():
    """
    Simple index page with instructions
    """
    return jsonify({
        "message": "Main Service is running",
        "endpoints": {
            "/process": "Main processing endpoint that calls worker service",
            "/health": "Health check endpoint"
        },
        "worker_service": "http://localhost:9000"
    })

if __name__ == '__main__':
    logger.info("Starting Main Service on port 8000")
    app.run(host='0.0.0.0', port=8000, debug=True)
