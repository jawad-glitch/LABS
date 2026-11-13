#!/bin/bash
set -e
BASE="$HOME/fabric-dr-lab"
T="$BASE/fabric-samples/test-network"
PRE="$BASE/pre-disaster-state.json"
POST="$BASE/post-recovery-state.json"

test -s "$PRE"
test -s "$T/ledger/peer0/assets.json"
jq . "$T/ledger/peer0/assets.json" > "$POST"

BEFORE="$(jq 'length' "$PRE")"
AFTER="$(jq 'length' "$POST")"

echo "========== RECOVERY VALIDATION =========="
echo "Pre-disaster asset count: $BEFORE"
echo "Post-recovery asset count: $AFTER"

[ "$BEFORE" -eq "$AFTER" ] || {
 echo "FAIL: Asset counts differ."
 exit 1
}
echo "PASS: Asset counts match."

jq -e '.[] | select(.ID == "asset-DR-001")' "$POST" >/dev/null
echo "PASS: asset-DR-001 exists after recovery."

cmp -s "$T/ledger/peer0/assets.json" "$T/ledger/peer1/assets.json"
echo "PASS: Peer ledger snapshots match."
echo "PASS: Recovered ledger validation completed."
