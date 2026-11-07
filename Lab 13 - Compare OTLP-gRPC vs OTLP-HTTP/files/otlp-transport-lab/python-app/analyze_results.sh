#!/bin/bash

echo "=== TRANSPORT ANALYSIS RESULTS ==="
echo
echo "1. Collector Status:"
docker ps 2>/dev/null | grep otel-collector || sg docker -c "docker ps" | grep otel-collector
echo
echo "2. Port Usage:"
ss -tlnp | grep -E ':(4317|4318)\b'
echo
echo "3. Exported Data Summary:"
if [ -f /tmp/telemetry-data.json ]; then
    echo "Total telemetry records (export batches): $(wc -l < /tmp/telemetry-data.json)"
    echo "File size: $(du -h /tmp/telemetry-data.json | cut -f1)"
else
    echo "No telemetry data file found"
fi
echo
echo "4. Transport Success Verification (spans per service in the exported file):"
grpc_spans=$(grep -o '"sample-app-grpc"' /tmp/telemetry-data.json 2>/dev/null | wc -l)
http_spans=$(grep -o '"sample-app-http"' /tmp/telemetry-data.json 2>/dev/null | wc -l)
echo "gRPC (sample-app-grpc) resource entries: $grpc_spans"
echo "HTTP (sample-app-http) resource entries: $http_spans"
if [ "$grpc_spans" -gt 0 ] && [ "$http_spans" -gt 0 ]; then
    echo "✅ Both transports working successfully!"
elif [ "$grpc_spans" -gt 0 ]; then
    echo "✅ gRPC transport working, ❌ HTTP transport may have issues"
elif [ "$http_spans" -gt 0 ]; then
    echo "✅ HTTP transport working, ❌ gRPC transport may have issues"
else
    echo "❌ Both transports may have issues - check configuration"
fi
