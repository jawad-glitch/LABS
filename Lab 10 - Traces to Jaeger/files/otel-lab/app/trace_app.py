#!/usr/bin/env python3

import time
import requests
from flask import Flask, jsonify
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.instrumentation.flask import FlaskInstrumentor
from opentelemetry.instrumentation.requests import RequestsInstrumentor

# Configure OpenTelemetry (service name comes from OTEL_SERVICE_NAME)
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

# Create Flask app
app = Flask(__name__)

# Instrument Flask and requests
FlaskInstrumentor().instrument_app(app)
RequestsInstrumentor().instrument()

@app.route('/')
def home():
    with tracer.start_as_current_span("home_request") as span:
        span.set_attribute("http.method", "GET")
        span.set_attribute("http.route", "/")

        # Simulate some work
        time.sleep(0.1)

        return jsonify({
            "message": "Hello from traced application!",
            "timestamp": time.time()
        })

@app.route('/api/users/<user_id>')
def get_user(user_id):
    with tracer.start_as_current_span("get_user") as span:
        span.set_attribute("user.id", user_id)
        span.set_attribute("http.method", "GET")
        span.set_attribute("http.route", "/api/users/<user_id>")

        # Simulate database lookup
        with tracer.start_as_current_span("database_query") as db_span:
            db_span.set_attribute("db.operation", "SELECT")
            db_span.set_attribute("db.table", "users")
            time.sleep(0.05)  # Simulate DB query time

        # Simulate external API call
        with tracer.start_as_current_span("external_api_call") as api_span:
            api_span.set_attribute("http.url", "https://jsonplaceholder.typicode.com/users/1")
            try:
                response = requests.get("https://jsonplaceholder.typicode.com/users/1", timeout=5)
                api_span.set_attribute("http.status_code", response.status_code)
            except Exception as e:
                api_span.set_attribute("error", True)
                api_span.set_attribute("error.message", str(e))

        return jsonify({
            "user_id": user_id,
            "name": f"User {user_id}",
            "timestamp": time.time()
        })

@app.route('/api/slow')
def slow_endpoint():
    with tracer.start_as_current_span("slow_operation") as span:
        span.set_attribute("operation.type", "slow")

        # Simulate multiple slow operations
        for i in range(3):
            with tracer.start_as_current_span(f"slow_step_{i+1}") as step_span:
                step_span.set_attribute("step.number", i+1)
                time.sleep(0.2)  # Simulate slow operation

        return jsonify({
            "message": "Slow operation completed",
            "duration": "~0.6 seconds"
        })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
