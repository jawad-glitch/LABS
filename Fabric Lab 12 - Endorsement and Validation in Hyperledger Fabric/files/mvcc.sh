#!/bin/bash
# Two concurrent TransferAsset calls on the same key: exactly one must be invalidated with MVCC_READ_CONFLICT.
H="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; . "$H/env.sh"; . "$H/lib.sh"
ID="mvcc-$(date +%s%N | cut -c1-15)"; A=$(mktemp); B=$(mktemp)
peer chaincode invoke $(ORD) -C $CHANNEL_NAME -n $CC_NAME $(BOTH) -c "{\"function\":\"CreateAsset\",\"Args\":[\"$ID\",\"white\",\"3\",\"Origin\",\"100\"]}" --waitForEvent > /dev/null 2>&1 || { echo "FAIL: could not create $ID"; exit 1; }
peer chaincode invoke $(ORD) -C $CHANNEL_NAME -n $CC_NAME $(BOTH) -c "{\"function\":\"TransferAsset\",\"Args\":[\"$ID\",\"OwnerA\"]}" --waitForEvent > "$A" 2>&1 & PA=$!
peer chaincode invoke $(ORD) -C $CHANNEL_NAME -n $CC_NAME $(BOTH) -c "{\"function\":\"TransferAsset\",\"Args\":[\"$ID\",\"OwnerB\"]}" --waitForEvent > "$B" 2>&1 & PB=$!
wait $PA $PB
TA=$(txid_of "$A"); SA=$(status_of "$A"); TB=$(txid_of "$B"); SB=$(status_of "$B")
echo "tx A ${TA:0:16} -> $SA | tx B ${TB:0:16} -> $SB"
sleep 1; LOG=$($DK logs peer0.org1.example.com 2>&1 | grep -E "MVCC_READ_CONFLICT" | grep -E "${TA:-none}|${TB:-none}")
echo "peer0.org1 validation log: $(echo "$LOG" | tail -1 | grep -oE 'Block \[[0-9]+\].*' | cut -c1-160)"
INVALID=$( (echo "$SA"; echo "$SB") | grep -vc '^VALID$')
if [ "$INVALID" = 1 ] && [ -n "$LOG" ] && echo "$SA $SB" | grep -q MVCC_READ_CONFLICT; then
  echo "PASS: exactly one of the two concurrent transfers was marked invalid (MVCC_READ_CONFLICT) and recorded in the block; owner now $(peer chaincode query -C $CHANNEL_NAME -n $CC_NAME -c "{\"Args\":[\"ReadAsset\",\"$ID\"]}" 2>/dev/null | jq -r .Owner)"; exit 0
fi
echo "FAIL: expected exactly one MVCC_READ_CONFLICT (got A=$SA B=$SB, log lines: $(echo -n "$LOG" | grep -c .))"; exit 1
