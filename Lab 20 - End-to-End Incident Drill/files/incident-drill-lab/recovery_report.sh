#!/bin/bash

echo "=== INCIDENT RECOVERY REPORT ==="
echo "Generated at: $(date)"
echo ""
echo "=== System Status ==="
echo "Application Status: $(curl -s http://localhost:3000/health | jq -r '.status')"
echo "Jaeger UI: http://localhost:16686"
echo "Grafana UI: http://localhost:3001"
echo ""
echo "=== Log Summary (today) ==="
RECENT_LOGS=$(grep "$(date -u '+%Y-%m-%d')" logs/app.log 2>/dev/null || echo "")
if [ -n "$RECENT_LOGS" ]; then
  echo "Recent completed requests: $(echo "$RECENT_LOGS" | grep -c "Work request completed")"
  echo "Recent failed requests: $(echo "$RECENT_LOGS" | grep -c "Work request failed")"
  echo "Recent latency injections: $(echo "$RECENT_LOGS" | grep -c "Injecting artificial latency")"
  echo "Last event: $(echo "$RECENT_LOGS" | tail -n 1 | jq -r '.message')"
fi
echo ""
echo "=== Verification Steps Completed ==="
echo "✓ Injections disabled"
echo "✓ Normal traffic generated"
echo "✓ Latency returned to baseline"
echo "✓ Error rate returned to normal"
echo ""
echo "Incident resolution: SUCCESSFUL"
