#!/bin/bash
echo "=== Prometheus Performance Monitoring ==="
echo "Timestamp: $(date)"
echo "1. Memory Usage:"
curl -s "http://localhost:9090/api/v1/query?query=process_resident_memory_bytes{job=\"prometheus\"}" | \
  python3 -c "import sys, json; data=json.load(sys.stdin); print(f\"Memory: {int(data['data']['result'][0]['value'][1])/1024/1024:.2f} MB\")" 2>/dev/null || echo "Memory data not available"
echo "2. CPU Usage:"
curl -s "http://localhost:9090/api/v1/query?query=rate(process_cpu_seconds_total{job=\"prometheus\"}[5m])" | \
  python3 -c "import sys, json; data=json.load(sys.stdin); print(f\"CPU: {float(data['data']['result'][0]['value'][1])*100:.2f}%\")" 2>/dev/null || echo "CPU data not available"
echo "3. Storage Metrics:"
curl -s "http://localhost:9090/api/v1/query?query=prometheus_tsdb_symbol_table_size_bytes" | \
  python3 -c "import sys, json; data=json.load(sys.stdin); print(f\"Symbol Table: {int(data['data']['result'][0]['value'][1])/1024/1024:.2f} MB\")" 2>/dev/null || echo "Symbol table data not available"
curl -s "http://localhost:9090/api/v1/query?query=prometheus_tsdb_head_series" | \
  python3 -c "import sys, json; data=json.load(sys.stdin); print(f\"Head Series: {data['data']['result'][0]['value'][1]}\")" 2>/dev/null || echo "Head series data not available"
echo "4. WAL Metrics:"
curl -s "http://localhost:9090/api/v1/query?query=prometheus_tsdb_wal_fsync_duration_seconds" | \
  python3 -c "import sys, json; data=json.load(sys.stdin); print(f\"WAL Fsync Duration: {float(data['data']['result'][0]['value'][1]):.6f}s\")" 2>/dev/null || echo "WAL fsync data not available"
echo "5. Query Performance:"
curl -s "http://localhost:9090/api/v1/query?query=prometheus_engine_query_duration_seconds{quantile=\"0.9\"}" | \
  python3 -c "import sys, json; data=json.load(sys.stdin); print(f\"90th Percentile Query Duration: {float(data['data']['result'][0]['value'][1]):.6f}s\")" 2>/dev/null || echo "Query duration data not available"
echo "6. Ingestion Rate:"
curl -s "http://localhost:9090/api/v1/query?query=rate(prometheus_tsdb_head_samples_appended_total[5m])" | \
  python3 -c "import sys, json; data=json.load(sys.stdin); print(f\"Samples/sec: {float(data['data']['result'][0]['value'][1]):.2f}\")" 2>/dev/null || echo "Ingestion rate data not available"
echo "=== End Performance Report ==="
