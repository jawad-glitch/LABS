#!/usr/bin/env bash
# File: ~/otel-lab15/validate-prometheus.sh

PROM_API="http://localhost:9090/api/v1"

RESULT=$(curl -fsSL "${PROM_API}/query?query=http_requests_total")

if [ "$(echo "$RESULT" | jq '.data.result | length')" -eq 0 ]; then
  echo "FAIL: No time-series found for http_requests_total"
  echo "Check that Prometheus is scraping localhost:8889 and the collector is running."
  exit 1
fi

echo "=== Labels on http_requests_total ==="
echo "$RESULT" | jq -r '.data.result[0].metric | to_entries[] | "\(.key): \(.value)"' | sort

echo ""
echo "=== Asserting required labels are present ==="

REQUIRED_LABELS=(
  "deployment_environment"
  "team_owner"
  "region"
  "service_name"
)

MISSING=0
for LABEL in "${REQUIRED_LABELS[@]}"; do
  VAL=$(echo "$RESULT" | jq -r --arg l "$LABEL" '.data.result[0].metric[$l] // empty')
  if [ -z "$VAL" ]; then
    echo "MISSING: $LABEL"
    MISSING=$((MISSING + 1))
  else
    echo "OK:      $LABEL = $VAL"
  fi
done

[ "$MISSING" -eq 0 ] && echo "All required metric labels present." \
  || echo "FAIL: $MISSING label(s) missing - review attributes processor and Prometheus exporter config."
