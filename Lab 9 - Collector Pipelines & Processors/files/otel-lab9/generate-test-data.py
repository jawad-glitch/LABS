#!/usr/bin/env python3
"""
Test data generator for OpenTelemetry Collector Lab 9
Sends sample traces, metrics, and logs to the collector
"""

import json
import time
import requests
import random
from datetime import datetime

# Collector endpoint
OTLP_HTTP_ENDPOINT = "http://localhost:4318/v1/traces"
OTLP_METRICS_ENDPOINT = "http://localhost:4318/v1/metrics"
OTLP_LOGS_ENDPOINT = "http://localhost:4318/v1/logs"

def generate_trace_data():
    """Generate sample trace data"""
    # OTLP requires a 16-byte trace id (32 hex chars) and an 8-byte span id (16 hex chars)
    trace_id = f"{random.getrandbits(128):032x}"
    span_id = f"{random.getrandbits(64):016x}"

    trace_data = {
        "resourceSpans": [{
            "resource": {
                "attributes": [{
                    "key": "service.name",
                    "value": {"stringValue": "test-service"}
                }, {
                    "key": "service.version",
                    "value": {"stringValue": "1.0.0"}
                }]
            },
            "scopeSpans": [{
                "scope": {
                    "name": "test-tracer",
                    "version": "1.0.0"
                },
                "spans": [{
                    "traceId": trace_id,
                    "spanId": span_id,
                    "name": "test-operation",
                    "kind": 1,
                    "startTimeUnixNano": str(int(time.time() * 1_000_000_000)),
                    "endTimeUnixNano": str(int((time.time() + 0.1) * 1_000_000_000)),
                    "attributes": [{
                        "key": "http.method",
                        "value": {"stringValue": "GET"}
                    }, {
                        "key": "http.status_code",
                        "value": {"intValue": 200}
                    }]
                }]
            }]
        }]
    }
    return trace_data

def generate_metric_data():
    """Generate sample metric data"""
    metric_data = {
        "resourceMetrics": [{
            "resource": {
                "attributes": [{
                    "key": "service.name",
                    "value": {"stringValue": "test-service"}
                }]
            },
            "scopeMetrics": [{
                "scope": {
                    "name": "test-meter",
                    "version": "1.0.0"
                },
                "metrics": [{
                    "name": "test_counter",
                    "description": "A test counter metric",
                    "unit": "1",
                    "sum": {
                        "dataPoints": [{
                            "attributes": [{
                                "key": "method",
                                "value": {"stringValue": "GET"}
                            }],
                            "timeUnixNano": str(int(time.time() * 1_000_000_000)),
                            "asInt": str(random.randint(1, 100))
                        }],
                        "aggregationTemporality": 2,
                        "isMonotonic": True
                    }
                }]
            }]
        }]
    }
    return metric_data

def generate_log_data():
    """Generate sample log data (the lab defined the logs endpoint but never used it)"""
    return {
        "resourceLogs": [{
            "resource": {"attributes": [{"key": "service.name", "value": {"stringValue": "test-service"}}]},
            "scopeLogs": [{
                "scope": {"name": "test-logger", "version": "1.0.0"},
                "logRecords": [{
                    "timeUnixNano": str(int(time.time() * 1_000_000_000)),
                    "severityText": "INFO",
                    "body": {"stringValue": "lab9 test log record"},
                    "attributes": [{"key": "component", "value": {"stringValue": "generator"}}]
                }]
            }]
        }]
    }

def send_data(endpoint, data):
    """Send data to the collector"""
    headers = {
        "Content-Type": "application/json"
    }

    try:
        response = requests.post(endpoint, json=data, headers=headers, timeout=5)
        if response.status_code == 200:
            print(f"✓ Successfully sent data to {endpoint}")
            return True
        else:
            print(f"✗ Failed to send data to {endpoint}: {response.status_code}")
            return False
    except Exception as e:
        print(f"✗ Error sending data to {endpoint}: {e}")
        return False

def main():
    """Main function to generate and send test data"""
    print("OpenTelemetry Collector Test Data Generator")
    print("=" * 50)

    print("\n1. Sending trace data...")
    send_data(OTLP_HTTP_ENDPOINT, generate_trace_data())

    print("\n2. Sending metric data...")
    send_data(OTLP_METRICS_ENDPOINT, generate_metric_data())

    print("\n3. Sending log data...")
    send_data(OTLP_LOGS_ENDPOINT, generate_log_data())

    print(f"\n4. Test completed at {datetime.now()}")
    print("Check the collector logs to see the processed data with added attributes!")

if __name__ == "__main__":
    main()
