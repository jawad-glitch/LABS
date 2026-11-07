#!/bin/bash
echo "=== Besu + Prometheus Setup Verification ==="
echo ""
echo "1. Docker Containers Status:"
docker ps --format "table {{.Names}}\t{{.Status}}" 2>/dev/null || sudo docker ps --format "table {{.Names}}\t{{.Status}}" 2>/dev/null
echo ""
echo "2. Besu Process Status:"
if pgrep -f 'besu.*config-file' > /dev/null; then
    echo "OK: Besu running (PID $(pgrep -f 'besu.*config-file'))"
else
    echo "FAIL: Besu not running"
fi
echo ""
echo "3. Port Accessibility:"
for pair in "9090:Prometheus" "9545:BesuMetrics" "8545:BesuRPC"; do
    port="${pair%%:*}"; svc="${pair##*:}"
    if timeout 1 bash -c "echo > /dev/tcp/localhost/$port" 2>/dev/null; then
        echo "OK: $svc (port $port) accessible"
    else
        echo "FAIL: $svc (port $port) not accessible"
    fi
done
echo ""
echo "4. Metrics Availability:"
if curl -s http://localhost:9545/metrics | head -1 | grep -q "HELP"; then
    echo "OK: Besu metrics available ($(curl -s http://localhost:9545/metrics | wc -l) lines)"
else
    echo "FAIL: Besu metrics not available"
fi
echo ""
echo "5. Prometheus Target Status:"
curl -s "http://localhost:9090/api/v1/targets" 2>/dev/null | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    for t in d['data']['activeTargets']:
        if 'besu' in t['labels']['job']:
            print(f\"   Besu target: {t['health']} - {t['scrapeUrl']}\")
except Exception:
    print('   Unable to check')
" 2>/dev/null
echo ""
echo "=== Verification Complete ==="
