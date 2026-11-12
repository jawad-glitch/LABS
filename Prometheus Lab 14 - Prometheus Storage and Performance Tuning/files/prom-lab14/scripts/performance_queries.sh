#!/bin/bash
echo "=== Comprehensive Prometheus Performance Queries ==="
execute_query() {
    local query="$1"
    local description="$2"
    echo "Query: $description"
    echo "PromQL: $query"
    curl -s "http://localhost:9090/api/v1/query?query=$(echo "$query" | sed 's/ /%20/g')" | \
      python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    if data['data']['result']:
        for result in data['data']['result']:
            print(f'Value: {result[\"value\"][1]} {result.get(\"metric\", {})}')
    else:
        print('No data available')
except:
    print('Error parsing response')
"
    echo "---"
}
execute_query "process_resident_memory_bytes{job=\"prometheus\"}" "Prometheus Memory Usage"
execute_query "rate(process_cpu_seconds_total{job=\"prometheus\"}[5m])" "Prometheus CPU Usage Rate"
execute_query "go_memstats_alloc_bytes{job=\"prometheus\"}" "Go Memory Allocation"
execute_query "prometheus_tsdb_head_series" "Active Time Series"
execute_query "prometheus_tsdb_head_chunks" "Head Chunks"
execute_query "rate(prometheus_tsdb_head_samples_appended_total[5m])" "Sample Ingestion Rate"
execute_query "prometheus_tsdb_compaction_chunk_size_bytes" "Compaction Chunk Size"
execute_query "prometheus_engine_queries_concurrent_max" "Max Concurrent Queries"
execute_query "rate(prometheus_engine_queries_total[5m])" "Query Rate"
execute_query "histogram_quantile(0.95, rate(prometheus_engine_query_duration_seconds_bucket[5m]))" "95th Percentile Query Duration"
execute_query "prometheus_tsdb_wal_fsync_duration_seconds" "WAL Fsync Duration"
execute_query "prometheus_tsdb_wal_truncations_total" "WAL Truncations"
execute_query "prometheus_config_last_reload_success_timestamp_seconds" "Last Config Reload"
execute_query "prometheus_sd_discovered_targets" "Discovered Targets"
execute_query "rate(prometheus_http_requests_total[5m])" "HTTP Request Rate"
execute_query "prometheus_notifications_queue_length" "Notification Queue Length"
