#!/bin/bash
echo "=== Prometheus Metrics Verification ==="
echo "1. Checking Prometheus targets status:"
curl -s "http://localhost:9090/api/v1/targets" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'data' in data and 'activeTargets' in data['data']:
    for target in data['data']['activeTargets']:
        print(f\"  Job: {target.get('labels', {}).get('job', 'unknown')}, Health: {target.get('health', 'unknown')}, Endpoint: {target.get('scrapeUrl', 'unknown')}\")
"
echo -e "\n2. Checking available metrics count:"
METRIC_COUNT=$(curl -s "http://localhost:9090/api/v1/label/__name__/values" | python3 -c "import json, sys; data = json.load(sys.stdin); print(len(data['data']) if 'data' in data else 0)")
echo "  Total metrics available: $METRIC_COUNT"
echo -e "\n3. Testing key system metrics:"
CPU_TEST=$(curl -s "http://localhost:9090/api/v1/query?query=node_cpu_seconds_total" | python3 -c "import json, sys; data = json.load(sys.stdin); print('OK' if 'data' in data and data['data']['result'] else 'FAIL')")
echo "  CPU metrics: $CPU_TEST"
MEM_TEST=$(curl -s "http://localhost:9090/api/v1/query?query=node_memory_MemTotal_bytes" | python3 -c "import json, sys; data = json.load(sys.stdin); print('OK' if 'data' in data and data['data']['result'] else 'FAIL')")
echo "  Memory metrics: $MEM_TEST"
DISK_TEST=$(curl -s "http://localhost:9090/api/v1/query?query=node_filesystem_size_bytes" | python3 -c "import json, sys; data = json.load(sys.stdin); print('OK' if 'data' in data and data['data']['result'] else 'FAIL')")
echo "  Disk metrics: $DISK_TEST"
echo -e "\n4. Data freshness check:"
LATEST_SCRAPE=$(curl -s "http://localhost:9090/api/v1/query?query=up" | python3 -c "
import json, sys, datetime, time
data = json.load(sys.stdin)
if 'data' in data and data['data']['result']:
    timestamp = float(data['data']['result'][0]['value'][0])
    print(f'Last scrape: {time.time() - timestamp:.1f} seconds ago')
else:
    print('No scrape data available')
")
echo "  $LATEST_SCRAPE"
