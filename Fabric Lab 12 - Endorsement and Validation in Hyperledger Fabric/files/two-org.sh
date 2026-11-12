#!/bin/bash
# Submit a CreateAsset endorsed by Org1 and Org2, extract the txid, confirm it in the peer log, read the asset back.
H="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; . "$H/env.sh"; . "$H/lib.sh"
ID="two-org-$(date +%s%N | cut -c1-15)"; COLOR=blue; SIZE=7; OWNER=Alice; VALUE=450; OUT=$(mktemp)
peer chaincode invoke $(ORD) -C $CHANNEL_NAME -n $CC_NAME $(BOTH) -c "{\"function\":\"CreateAsset\",\"Args\":[\"$ID\",\"$COLOR\",\"$SIZE\",\"$OWNER\",\"$VALUE\"]}" --waitForEvent > "$OUT" 2>&1; RC=$?
TX=$(txid_of "$OUT"); ST=$(status_of "$OUT")
echo "invoke: $(grep -oE 'status:[0-9]+' "$OUT" | head -1 | sed 's/status:/Status: /') | txid=$TX | commit status=$ST"
INLOG=$($DK logs peer0.org1.example.com 2>&1 | grep -c "txID=${TX:0:8}")
echo "peer0.org1 log lines with txID=${TX:0:8}: $INLOG"
GOT=$(peer chaincode query -C $CHANNEL_NAME -n $CC_NAME -c "{\"Args\":[\"ReadAsset\",\"$ID\"]}" 2>/dev/null)
echo "ReadAsset $ID: $GOT"
if [ $RC = 0 ] && [ "$ST" = VALID ] && [ -n "$TX" ] && [ "$INLOG" -ge 1 ] && \
   [ "$(echo "$GOT" | jq -r '"\(.ID)|\(.Color)|\(.Size)|\(.Owner)|\(.AppraisedValue)"')" = "$ID|$COLOR|$SIZE|$OWNER|$VALUE" ]; then
  echo "PASS: two-org endorsed transaction committed and all fields match"; exit 0
else echo "FAIL: two-org transaction did not commit as expected"; exit 1; fi
