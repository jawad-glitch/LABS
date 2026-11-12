#!/bin/bash
# Fixed: query passed via curl --data-urlencode (no shell-in-python quoting), Python in single quotes,
# exit code 0 = data, 2 = PromQL error, 3 = empty result.
PROMETHEUS_URL="${PROMETHEUS_URL:-http://localhost:9090}"
execute_query() {
    local query="$1" description="$2"
    echo "=== $description ==="; echo "Query: $query"; echo
    curl -s --get --data-urlencode "query=$query" "$PROMETHEUS_URL/api/v1/query" | python3 -c '
import sys, json
d = json.load(sys.stdin)
if d.get("status") != "success":
    print("Error:", d.get("error", "unknown")); sys.exit(2)
res = d["data"]["result"]
if not res:
    print("No data returned"); sys.exit(3)
for it in res:
    print("Metric:", it.get("metric", {})); print("Value:", it["value"][1]); print()
'
    local rc=${PIPESTATUS[1]}
    echo "----------------------------------------"; echo; return $rc
}
curl -s -m 3 "$PROMETHEUS_URL/-/ready" >/dev/null || { echo "Error: Cannot connect to Prometheus at $PROMETHEUS_URL"; exit 1; }
[ $# -eq 2 ] || { echo "Usage: $0 'query' 'description'"; exit 64; }
execute_query "$1" "$2"
