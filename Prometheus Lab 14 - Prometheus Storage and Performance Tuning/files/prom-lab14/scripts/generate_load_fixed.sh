#!/bin/bash
# Fixed: range queries URL-encoded so they actually reach /api/v1/query_range
for r in 1 2 3 4 5 6; do for i in $(seq 1 10); do
  curl -s --get --data-urlencode 'query=rate(node_cpu_seconds_total[5m])' --data-urlencode "start=$(date -d '1 hour ago' +%s)" --data-urlencode "end=$(date +%s)" --data-urlencode 'step=60' http://localhost:9090/api/v1/query_range >/dev/null &
done; wait; sleep 5; done
