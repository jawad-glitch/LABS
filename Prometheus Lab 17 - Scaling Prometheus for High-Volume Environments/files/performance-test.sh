#!/bin/bash
echo "=== Performance Testing ==="
measure_query_time() {
    local url=$1 query=$2 description=$3
    echo "Testing: $description"
    start_time=$(date +%s.%N)
    result=$(curl -s "$url/api/v1/query?query=$query")
    end_time=$(date +%s.%N)
    duration=$(echo "$end_time - $start_time" | bc)
    result_count=$(echo "$result" | jq '.data.result | length')
    echo "  Duration: ${duration}s"
    echo "  Results: $result_count metrics"
    echo "  Status: $(echo "$result" | jq -r '.status')"
    echo ""
}
echo "1. Complex Aggregation Queries"
measure_query_time "http://localhost:9090" "sum(rate(node_cpu_seconds_total[5m])) by (mode)" "Prometheus Direct - CPU aggregation"
measure_query_time "http://localhost:19090" "sum(rate(node_cpu_seconds_total[5m])) by (mode)" "Thanos Query - CPU aggregation"
echo "2. Multi-dimensional Queries"
measure_query_time "http://localhost:9090" "node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes" "Prometheus Direct - Memory ratio"
measure_query_time "http://localhost:19090" "node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes" "Thanos Query - Memory ratio"
echo "3. Cross-job Queries"
measure_query_time "http://localhost:19090" "count by (job) (up == 1)" "Thanos Query - Service availability by job"
