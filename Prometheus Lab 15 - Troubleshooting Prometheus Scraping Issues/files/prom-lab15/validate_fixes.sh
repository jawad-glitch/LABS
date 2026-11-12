#!/bin/bash
echo "=== Prometheus Scraping Validation ==="
echo "1. Configuration syntax check:"
if /usr/local/bin/promtool check config /etc/prometheus/prometheus.yml; then echo "✓ Configuration is valid"; else echo "✗ Configuration has errors"; exit 1; fi
echo "2. Service status:"
if sudo systemctl is-active prometheus > /dev/null; then echo "✓ Prometheus service is running"; else echo "✗ Prometheus service is not running"; fi
echo "3. Target status summary:"
curl -s 'http://localhost:9090/api/v1/query?query=up' | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    total = len(data['data']['result'])
    up_count = sum(1 for r in data['data']['result'] if r['value'][1] == '1')
    print(f'Targets UP: {up_count}/{total}')
    if up_count < total:
        print('\\nDOWN targets:')
        for result in data['data']['result']:
            if result['value'][1] == '0':
                print(f\"  - {result['metric']['job']} ({result['metric']['instance']})\")
except:
    print('Error querying Prometheus API')
"
echo "4. Relabeling validation:"
relabeled_count=$(curl -s 'http://localhost:9090/api/v1/query?query=up{relabeled="true"}' | python3 -c "
import sys, json
try:
    print(len(json.load(sys.stdin)['data']['result']))
except:
    print('0')
")
if [ "$relabeled_count" -gt 0 ]; then echo "✓ Found $relabeled_count relabeled targets"; else echo "! No relabeled targets found"; fi
echo "5. Recent scraping errors:"
error_count=$(sudo journalctl -u prometheus --since "5 minutes ago" | grep -c -i "error\|failed")
if [ "$error_count" -eq 0 ]; then echo "✓ No recent scraping errors"; else echo "! Found $error_count recent errors"; fi
echo "=== Validation Complete ==="
