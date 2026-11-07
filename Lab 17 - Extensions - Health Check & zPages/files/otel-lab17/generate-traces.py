#!/usr/bin/env python3
import requests
import json
import time
import random

def send_trace():
    trace_data = {
        "resourceSpans": [{
            "resource": {
                "attributes": [{
                    "key": "service.name",
                    "value": {"stringValue": "lab17-test-service"}
                }]
            },
            "scopeSpans": [{
                "scope": {
                    "name": "lab17-tracer",
                    "version": "1.0.0"
                },
                "spans": [{
                    "traceId": f"{random.getrandbits(128):032x}",
                    "spanId": f"{random.getrandbits(64):016x}",
                    "name": "test-operation",
                    "kind": 1,
                    "startTimeUnixNano": str(int(time.time() * 1e9)),
                    "endTimeUnixNano": str(int((time.time() + 0.1) * 1e9)),
                    "attributes": [{
                        "key": "operation.type",
                        "value": {"stringValue": "test"}
                    }]
                }]
            }]
        }]
    }

    try:
        response = requests.post(
            "http://localhost:4318/v1/traces",
            headers={"Content-Type": "application/json"},
            data=json.dumps(trace_data)
        )
        print(f"Sent trace, status: {response.status_code}")
    except Exception as e:
        print(f"Error sending trace: {e}")

if __name__ == "__main__":
    for i in range(5):
        send_trace()
        time.sleep(1)
    print("Finished sending traces")
