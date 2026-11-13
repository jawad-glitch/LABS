#!/bin/bash
BASE="$(cd "$(dirname "$0")" && pwd)"
STATE="$BASE/network-state"
REPORT="$BASE/health-report.txt"
: > "$REPORT"
FAILED=0

check() {
  if [ "$2" = yes ]; then
    echo "[PASS] $1" | tee -a "$REPORT"
  else
    echo "[FAIL] $1" | tee -a "$REPORT"
    FAILED=1
  fi
}

check "Two peers are Up" "$(grep -cE '^peer[01] Up$' "$STATE/containers.txt" 2>/dev/null | grep -q '^2$' && echo yes || echo no)"
check "Orderer is Up" "$(grep -q '^orderer Up$' "$STATE/containers.txt" 2>/dev/null && echo yes || echo no)"
check "Two certificate authorities are Up" "$(grep -cE '^ca_org[12] Up$' "$STATE/containers.txt" 2>/dev/null | grep -q '^2$' && echo yes || echo no)"

QUERY_OK=no
for attempt in 1 2 3 4 5 6; do
  if timeout 30 bash "$BASE/scripts/query.sh" > "$BASE/results/query.json" 2>/dev/null && jq -e 'type == "array" and length > 0' "$BASE/results/query.json" >/dev/null 2>&1; then
    QUERY_OK=yes
    break
  fi
  [ "$attempt" = 6 ] || sleep 5
done
check "Chaincode query returns non-empty JSON" "$QUERY_OK"

SEQ_OK=no
if [ -s "$STATE/sequence.txt" ] && [ "$(cat "$STATE/sequence.txt")" = 1 ]; then
  SEQ_OK=yes
fi
check "Committed sequence matches deployment sequence 1" "$SEQ_OK"

[ "$FAILED" = 0 ]
