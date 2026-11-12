#!/bin/bash
echo "=== Prometheus Troubleshooting Script ==="
echo
echo "1. Checking Prometheus service status:"
sudo systemctl status prometheus --no-pager -l
echo
echo "2. Checking recent Prometheus logs for errors:"
sudo journalctl -u prometheus --since "5 minutes ago" | grep -i "error\|failed\|timeout" | tail -10
echo
echo "3. Testing Prometheus API connectivity:"
if curl -s http://localhost:9090/api/v1/query > /dev/null; then
    echo "✓ Prometheus API is accessible"
else
    echo "✗ Prometheus API is not accessible"
fi
echo
echo "4. Checking target status:"
curl -s 'http://localhost:9090/api/v1/query?query=up' | python3 -m json.tool
echo
echo "5. Checking scrape duration:"
curl -s 'http://localhost:9090/api/v1/query?query=prometheus_target_scrape_duration_seconds' | python3 -m json.tool
echo
echo "6. Checking configuration file syntax:"
/usr/local/bin/promtool check config /etc/prometheus/prometheus.yml
echo
echo "=== Troubleshooting Complete ==="
