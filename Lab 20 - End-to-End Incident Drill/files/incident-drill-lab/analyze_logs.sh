#!/bin/bash

echo "=== Log Analysis Report ==="
echo "Total log entries: $(wc -l < logs/app.log)"
echo "Latency injection events: $(grep -c "Injecting artificial latency" logs/app.log)"
echo "Error events: $(grep -c '"level":"error"' logs/app.log)"
echo "Completed requests: $(grep -c "Work request completed" logs/app.log)"
echo "Failed requests: $(grep -c "Work request failed" logs/app.log)"

echo -e "\n=== Recent High Latency Events ==="
grep "Injecting artificial latency" logs/app.log | tail -n 5 | jq -r '.timestamp + " - Trace: " + .traceId + " - Latency: " + (.latencyMs|tostring) + "ms"'
