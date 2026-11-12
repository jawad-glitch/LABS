#!/bin/bash
echo "=== Testing Prometheus Direct Queries ==="
echo "1. Checking available metrics..."
curl -s "http://localhost:9090/api/v1/label/__name__/values" | jq '.data | length'
echo "2. Current up status across all jobs..."
curl -s "http://localhost:9090/api/v1/query?query=up" | jq '.data.result[] | {job: .metric.job, value: .value[1]}'
echo "3. CPU usage over last 10 minutes..."
curl -s "http://localhost:9090/api/v1/query_range?query=rate(node_cpu_seconds_total[5m])&start=$(date -d '10 minutes ago' +%s)&end=$(date +%s)&step=60" | jq '.data.result | length'
echo "=== Testing Thanos Query Interface ==="
echo "4. Thanos Query - Available metrics..."
curl -s "http://localhost:19090/api/v1/label/__name__/values" | jq '.data | length'
echo "5. Thanos Query - Up status across all components..."
curl -s "http://localhost:19090/api/v1/query?query=up" | jq '.data.result[] | {job: .metric.job, cluster: .metric.cluster, value: .value[1]}'
echo "6. Thanos Query - Historical data range..."
curl -s "http://localhost:19090/api/v1/query_range?query=up&start=$(date -d '15 minutes ago' +%s)&end=$(date +%s)&step=60" | jq '.data.result | length'
