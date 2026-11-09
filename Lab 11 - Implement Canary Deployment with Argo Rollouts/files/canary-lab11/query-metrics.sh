#!/bin/bash
PROMETHEUS_URL="${PROMETHEUS_URL:-http://localhost:9090}"
for q in rollout_info rollout_info_replicas_available rollout_info_replicas_desired analysis_run_info; do
  echo "=== $q ==="
  curl -s -G "${PROMETHEUS_URL}/api/v1/query" --data-urlencode "query=$q" | python3 -m json.tool
done
