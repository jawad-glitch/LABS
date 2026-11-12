#!/bin/bash
echo "=== Comprehensive Prometheus Setup Verification ==="
echo "1. Service Status:"
services=("prometheus" "node_exporter" "thanos-sidecar" "thanos-store" "thanos-querier")
for service in "${services[@]}"; do
    if systemctl is-active --quiet $service; then echo "✓ $service is running"; else echo "✗ $service is not running"; fi
done
echo "2. Endpoint Accessibility:"
endpoints=("http://localhost:9090/-/healthy:Prometheus" "http://localhost:9100/metrics:Node Exporter" "http://localhost:10902/metrics:Thanos Sidecar" "http://localhost:10904/metrics:Thanos Store" "http://localhost:10905/api/v1/stores:Thanos Querier")
for endpoint in "${endpoints[@]}"; do
    url=$(echo $endpoint | cut -d: -f1-3)
    name=$(echo $endpoint | cut -d: -f4)
    if curl -s "$url" > /dev/null; then echo "✓ $name accessible"; else echo "✗ $name not accessible"; fi
done
echo "3. Data Ingestion:"
targets=$(curl -s "http://localhost:9090/api/v1/targets" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(f\"{sum(1 for t in data['data']['activeTargets'] if t['health'] == 'up')}/{len(data['data']['activeTargets'])}\")
" 2>/dev/null)
echo "Active targets: $targets"
echo "4. Storage Status:"
series=$(curl -s "http://localhost:9090/api/v1/query?query=prometheus_tsdb_head_series" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data['data']['result'][0]['value'][1] if data['data']['result'] else '0')" 2>/dev/null)
echo "Active series: $series"
echo "5. Thanos Integration:"
stores=$(curl -s "http://localhost:10905/api/v1/stores" | python3 -c "import sys, json; data=json.load(sys.stdin); print(len(data['data']) if 'data' in data else 0)" 2>/dev/null)
echo "Connected stores: $stores"
echo "=== Verification Complete ==="
