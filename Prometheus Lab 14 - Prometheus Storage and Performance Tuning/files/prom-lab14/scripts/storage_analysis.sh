#!/bin/bash
echo "=== Prometheus Storage Analysis ==="
echo "1. Disk Usage:"
du -sh /var/lib/prometheus/
ls -la /var/lib/prometheus/
echo "2. TSDB Blocks:"
if [ -d "/var/lib/prometheus" ]; then
    find /var/lib/prometheus -name "*.db" -o -name "chunks_head" | head -10
fi
echo "3. WAL Files:"
if [ -d "/var/lib/prometheus/wal" ]; then
    ls -lah /var/lib/prometheus/wal/ | head -10
fi
echo "4. Storage Metrics:"
curl -s "http://localhost:9090/api/v1/query?query=prometheus_tsdb_size_retentions_total" | \
  python3 -c "import sys, json; data=json.load(sys.stdin); print(f\"Retention cleanups: {data['data']['result'][0]['value'][1] if data['data']['result'] else 'N/A'}\")" 2>/dev/null
curl -s "http://localhost:9090/api/v1/query?query=prometheus_tsdb_lowest_timestamp_seconds" | \
  python3 -c "import sys, json; data=json.load(sys.stdin); print(f\"Oldest data timestamp: {data['data']['result'][0]['value'][1] if data['data']['result'] else 'N/A'}\")" 2>/dev/null
