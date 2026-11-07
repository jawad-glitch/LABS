#!/bin/bash

echo "=== Multi-Export Health Check ==="
echo

# Check all containers
echo "Container Status:"
{ docker ps --format "table {{.Names}}\t{{.Status}}" 2>/dev/null || sg docker -c 'docker ps --format "table {{.Names}}\t{{.Status}}"'; } | grep -E "(zipkin|jaeger|otel)"

echo
echo "Backend Health Checks:"

# Jaeger health
JAEGER_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:14269/)
echo "Jaeger Health: HTTP $JAEGER_STATUS"

# Zipkin health
ZIPKIN_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9411/health)
echo "Zipkin Health: HTTP $ZIPKIN_STATUS"

# Collector OTLP endpoint (405 = alive, POST-only)
OTLP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:4318/v1/traces)
echo "OTLP Endpoint: HTTP $OTLP_STATUS"

echo
if [ "$JAEGER_STATUS" = "200" ] && [ "$ZIPKIN_STATUS" = "200" ]; then
    echo "✅ All backends are healthy!"
else
    echo "❌ Some backends may have issues. Check logs."
fi
