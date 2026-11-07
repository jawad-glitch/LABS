#!/bin/bash

# Cleanup script for OpenTelemetry CI validation lab

echo "Cleaning up OpenTelemetry CI validation lab..."

pkill otelcol 2>/dev/null || true
pkill prometheus 2>/dev/null || true

sleep 3

rm -f /tmp/otel_check.log
rm -f /tmp/health_response.json
rm -f /tmp/prometheus_response.json
rm -f /tmp/send_test_span.py
rm -f /tmp/send_test_metrics.py

echo "Cleanup completed!"
