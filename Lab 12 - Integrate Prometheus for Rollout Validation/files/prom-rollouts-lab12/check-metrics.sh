#!/bin/bash
PROMETHEUS_URL="${PROMETHEUS_URL:-http://localhost:9090}"
for q in 'http_requests_total' 'response_time_seconds_count' 'up{job="sample-app-service"}'; do
  echo "=== $q ==="
  curl -s -G "$PROMETHEUS_URL/api/v1/query" --data-urlencode "query=$q" | python3 -c 'import sys,json; [print(r["metric"], r["value"][1]) for r in json.load(sys.stdin)["data"]["result"]]'
done
