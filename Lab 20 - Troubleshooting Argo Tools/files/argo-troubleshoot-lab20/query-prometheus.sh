#!/bin/bash
P=${PROMETHEUS_URL:-http://localhost:9091}
for q in up rollout_info rollout_info_replicas_available rollout_info_replicas_desired analysis_run_info; do
  echo "=== $q"; curl -s -G "$P/api/v1/query" --data-urlencode "query=$q" | python3 -c 'import sys,json; [print(r["metric"], r["value"][1]) for r in json.load(sys.stdin)["data"]["result"]]'
done
