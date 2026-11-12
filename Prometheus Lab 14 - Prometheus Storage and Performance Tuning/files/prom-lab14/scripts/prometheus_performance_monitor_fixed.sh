#!/bin/bash
# Fixed: every query sent with --data-urlencode (no curl globbing), summary metrics selected by quantile/slice.
P=${PROM:-http://localhost:9090}
q() { curl -s --get --data-urlencode "query=$1" "$P/api/v1/query" | jq -r '.data.result[0].value[1] // "n/a"'; }
echo "=== Prometheus Performance Monitoring (fixed) - $(date -u '+%F %T') ==="
printf 'Memory: %.2f MB\n'                        "$(q 'process_resident_memory_bytes{job="prometheus"}' | awk '{print $1/1048576}')"
printf 'CPU: %.2f%%\n'                            "$(q 'rate(process_cpu_seconds_total{job="prometheus"}[1m])' | awk '{print $1*100}')"
printf 'Symbol Table: %.3f MB\n'                  "$(q 'prometheus_tsdb_symbol_table_size_bytes' | awk '{print $1/1048576}')"
printf 'Head Series: %s\n'                        "$(q 'prometheus_tsdb_head_series')"
printf 'WAL Fsync p90: %s s\n'                    "$(q 'prometheus_tsdb_wal_fsync_duration_seconds{quantile="0.9"}')"
printf 'Query inner_eval p90: %s s\n'             "$(q 'prometheus_engine_query_duration_seconds{slice="inner_eval",quantile="0.9"}')"
printf 'Query rate: %s queries/s\n'               "$(q 'rate(prometheus_engine_queries_total[1m])')"
printf 'Samples/sec: %.2f\n'                      "$(q 'rate(prometheus_tsdb_head_samples_appended_total[1m])')"
