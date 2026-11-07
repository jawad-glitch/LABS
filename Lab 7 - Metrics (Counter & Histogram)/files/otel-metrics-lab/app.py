#!/usr/bin/env python3

import time
import random
from flask import Flask, jsonify
from opentelemetry import metrics
from opentelemetry.sdk.metrics import MeterProvider
from opentelemetry.sdk.metrics.export import PeriodicExportingMetricReader
from opentelemetry.exporter.otlp.proto.grpc.metric_exporter import OTLPMetricExporter
from opentelemetry.sdk.resources import Resource

# Configure resource information
resource = Resource.create({
    "service.name": "metrics-demo-app",
    "service.version": "1.0.0",
})

# Configure OTLP exporter
otlp_exporter = OTLPMetricExporter(
    endpoint="http://localhost:4317",
    insecure=True,
)

# Configure metric reader with export interval
metric_reader = PeriodicExportingMetricReader(
    exporter=otlp_exporter,
    export_interval_millis=5000,  # Export every 5 seconds
)

# Set up the meter provider
metrics.set_meter_provider(
    MeterProvider(
        resource=resource,
        metric_readers=[metric_reader],
    )
)

# Get a meter
meter = metrics.get_meter("demo-meter", "1.0.0")

# Create metrics instruments
request_counter = meter.create_counter(
    name="http_requests_total",
    description="Total number of HTTP requests",
    unit="1",
)

request_duration_histogram = meter.create_histogram(
    name="http_request_duration_seconds",
    description="Duration of HTTP requests in seconds",
    unit="s",
)

# Create Flask app
app = Flask(__name__)

@app.route('/fast')
def fast_endpoint():
    """Fast endpoint with low latency"""
    start_time = time.time()

    # Simulate fast processing
    time.sleep(random.uniform(0.1, 0.3))

    # Calculate duration
    duration = time.time() - start_time

    # Record metrics
    request_counter.add(1, {"endpoint": "/fast", "method": "GET", "status": "200"})
    request_duration_histogram.record(duration, {"endpoint": "/fast", "method": "GET"})

    return jsonify({
        "message": "Fast response",
        "duration": f"{duration:.3f}s"
    })

@app.route('/slow')
def slow_endpoint():
    """Slow endpoint with higher latency"""
    start_time = time.time()

    # Simulate slow processing
    time.sleep(random.uniform(1.0, 3.0))

    # Calculate duration
    duration = time.time() - start_time

    # Record metrics
    request_counter.add(1, {"endpoint": "/slow", "method": "GET", "status": "200"})
    request_duration_histogram.record(duration, {"endpoint": "/slow", "method": "GET"})

    return jsonify({
        "message": "Slow response",
        "duration": f"{duration:.3f}s"
    })

@app.route('/error')
def error_endpoint():
    """Endpoint that sometimes returns errors"""
    start_time = time.time()

    # Simulate processing time
    time.sleep(random.uniform(0.2, 0.5))

    # Calculate duration
    duration = time.time() - start_time

    # Randomly return error or success
    if random.random() < 0.3:  # 30% chance of error
        request_counter.add(1, {"endpoint": "/error", "method": "GET", "status": "500"})
        request_duration_histogram.record(duration, {"endpoint": "/error", "method": "GET"})
        return jsonify({"error": "Internal server error"}), 500
    else:
        request_counter.add(1, {"endpoint": "/error", "method": "GET", "status": "200"})
        request_duration_histogram.record(duration, {"endpoint": "/error", "method": "GET"})
        return jsonify({"message": "Success"})

@app.route('/health')
def health_check():
    """Health check endpoint"""
    start_time = time.time()
    duration = time.time() - start_time

    request_counter.add(1, {"endpoint": "/health", "method": "GET", "status": "200"})
    request_duration_histogram.record(duration, {"endpoint": "/health", "method": "GET"})

    return jsonify({"status": "healthy"})

if __name__ == '__main__':
    print("Starting metrics demo application...")
    print("Available endpoints:")
    print("  - http://localhost:5000/fast")
    print("  - http://localhost:5000/slow")
    print("  - http://localhost:5000/error")
    print("  - http://localhost:5000/health")

    app.run(host='0.0.0.0', port=5000, debug=True)
