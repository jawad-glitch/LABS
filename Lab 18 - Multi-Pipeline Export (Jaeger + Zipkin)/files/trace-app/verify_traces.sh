#!/bin/bash

SERVICE="${OTEL_SERVICE_NAME:-trace-generator}"
echo "=== Multi-Export Verification (service: $SERVICE) ==="
echo

# Check Jaeger traces
echo "Checking Jaeger traces..."
JAEGER_TRACES=$(curl -s "http://localhost:16686/api/traces?service=${SERVICE}&limit=100" | jq '.data | length')
echo "Jaeger traces found: $JAEGER_TRACES"

# Check Zipkin traces
echo "Checking Zipkin traces..."
ZIPKIN_TRACES=$(curl -s "http://localhost:9411/api/v2/traces?serviceName=${SERVICE}&limit=100" | jq '. | length')
echo "Zipkin traces found: $ZIPKIN_TRACES"

echo
if [ "${JAEGER_TRACES:-0}" -gt 0 ] && [ "${ZIPKIN_TRACES:-0}" -gt 0 ]; then
    echo "✅ SUCCESS: Traces found in both backends!"
    echo "Multi-export configuration is working correctly."
else
    echo "❌ WARNING: Traces may not be present in both backends."
    echo "Check collector logs and backend connectivity."
fi
