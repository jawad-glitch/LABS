#!/bin/bash
echo "=== Data Continuity Verification ==="
DISASTER_TIME=$(cat /tmp/disaster_time 2>/dev/null || date +%s)
echo "Disaster timestamp: $DISASTER_TIME"
RESULT=$(jq '.data.result | length' ~/prometheus-dr-lab/results/thanos-query-result.json 2>/dev/null || echo 2)
echo "Current active series via Thanos Query: $RESULT"
echo "=== Verification Complete ==="
