#!/bin/bash
# Submit a CreateAsset endorsed by Org1 only; the AND policy must reject it at validation (ENDORSEMENT_POLICY_FAILURE).
# Per the lab's acceptance criterion this script exits 1 when the rejection is observed.
H="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; . "$H/env.sh"; . "$H/lib.sh"
ID="one-org-$(date +%s%N | cut -c1-15)"; OUT=$(mktemp)
peer chaincode invoke $(ORD) -C $CHANNEL_NAME -n $CC_NAME $(ONE) -c "{\"function\":\"CreateAsset\",\"Args\":[\"$ID\",\"red\",\"1\",\"Bob\",\"10\"]}" --waitForEvent > "$OUT" 2>&1; RC=$?
TX=$(txid_of "$OUT"); ST=$(status_of "$OUT")
EXISTS=$(peer chaincode query -C $CHANNEL_NAME -n $CC_NAME -c "{\"Args\":[\"AssetExists\",\"$ID\"]}" 2>/dev/null)
if [ "$ST" = ENDORSEMENT_POLICY_FAILURE ] || grep -q ENDORSEMENT_POLICY_FAILURE "$OUT"; then
  echo "ENDORSEMENT_POLICY_FAILURE: txid=$TX was rejected at validation (cli exit $RC); asset written: $EXISTS"; exit 1
fi
echo "UNEXPECTED: single-org transaction was not rejected (status=${ST:-none}, cli exit $RC)"; exit 2
