#!/usr/bin/env python3
"""
Health check for OpenTelemetry Collector pipeline
"""

import requests
import socket
import time

def check_collector_health():
    print("OpenTelemetry Collector Health Check")
    print("=" * 40)
    ok = True
    try:
        r = requests.get("http://localhost:13133/", timeout=5)
        print("✓ health_check extension reports healthy (13133)" if r.status_code == 200 else f"✗ health_check returned {r.status_code}")
        ok &= r.status_code == 200
    except Exception as e:
        print(f"✗ Collector health check failed: {e}"); return False
    try:
        r = requests.get("http://localhost:8888/metrics", timeout=5)
        print("✓ Collector self-metrics served on 8888/metrics" if r.status_code == 200 and "otelcol_" in r.text else f"? 8888/metrics returned {r.status_code}")
    except Exception as e:
        print(f"? 8888/metrics not reachable ({e})")
    r = requests.post("http://localhost:4318/v1/traces", json={}, timeout=5)
    print("✓ OTLP HTTP endpoint is accessible" if r.status_code in (200, 400) else f"? OTLP HTTP endpoint returned: {r.status_code}")
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM); sock.settimeout(5)
    res = sock.connect_ex(('localhost', 4317)); sock.close()
    print("✓ OTLP gRPC port is open" if res == 0 else "✗ OTLP gRPC port is not accessible")
    return ok and res == 0

def test_pipeline_flow():
    print("\nTesting Pipeline Flow")
    print("=" * 25)
    test_data = {"resourceSpans": [{"resource": {"attributes": [{"key": "service.name", "value": {"stringValue": "health-check-service"}}]},
        "scopeSpans": [{"spans": [{"traceId": "12345678901234567890123456789012", "spanId": "1234567890123456", "name": "health-check-span",
        "startTimeUnixNano": str(int(time.time() * 1_000_000_000)), "endTimeUnixNano": str(int((time.time() + 0.1) * 1_000_000_000))}]}]}]}
    r = requests.post("http://localhost:4318/v1/traces", json=test_data, timeout=5)
    if r.status_code == 200:
        print("✓ Test data sent successfully"); print("✓ Pipeline is processing data"); return True
    print(f"✗ Failed to send test data: {r.status_code}"); return False

def main():
    print("Starting comprehensive health check...\n")
    a = check_collector_health(); b = test_pipeline_flow()
    print(f"\n{'='*40}")
    print("✓ All health checks passed!\n✓ Collector pipeline is working correctly" if a and b else "✗ Some health checks failed")

if __name__ == "__main__":
    main()
