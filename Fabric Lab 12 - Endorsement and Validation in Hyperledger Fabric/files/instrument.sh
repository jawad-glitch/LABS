#!/bin/bash
# Block validation instrumentation for $CHANNEL_NAME. No arguments: channel, orderer and TLS come from the peer CLI environment
# (CHANNEL_NAME, ORDERER_ADDRESS, ORDERER_CA, PEER0_ORG1_*/PEER0_ORG2_*, CORE_PEER_*).
for dep in configtxlator jq peer; do command -v $dep >/dev/null 2>&1 || { echo "MISSING DEPENDENCY: $dep"; exit 1; }; done
: "${CHANNEL_NAME:?}" "${ORDERER_ADDRESS:?}" "${ORDERER_CA:?}" "${PEER0_ORG1_ADDRESS:?}" "${PEER0_ORG2_ADDRESS:?}"
ORDA="-o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA"
BOTH="--peerAddresses $PEER0_ORG1_ADDRESS --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses $PEER0_ORG2_ADDRESS --tlsRootCertFiles $PEER0_ORG2_CA"
ONE="--peerAddresses $PEER0_ORG1_ADDRESS --tlsRootCertFiles $PEER0_ORG1_CA"
height() { peer channel getinfo -c $CHANNEL_NAME 2>/dev/null | sed 's/^Blockchain info: //' | jq -r .height; }
inv() { peer chaincode invoke $ORDA -C $CHANNEL_NAME -n basic $1 -c "$2" --waitForEvent > /dev/null 2>&1; }
RUN="i$(date +%s)"; H0=$(height); echo "height before: $H0"
inv "$BOTH" "{\"function\":\"CreateAsset\",\"Args\":[\"$RUN-a\",\"blue\",\"1\",\"Ann\",\"10\"]}"
inv "$BOTH" "{\"function\":\"CreateAsset\",\"Args\":[\"$RUN-b\",\"green\",\"2\",\"Ben\",\"20\"]}"
inv "$ONE"  "{\"function\":\"CreateAsset\",\"Args\":[\"$RUN-c\",\"red\",\"3\",\"Cid\",\"30\"]}"      # expected ENDORSEMENT_POLICY_FAILURE
inv "$BOTH" "{\"function\":\"UpdateAsset\",\"Args\":[\"$RUN-a\",\"blue\",\"5\",\"Ann\",\"15\"]}"
inv "$BOTH" "{\"function\":\"TransferAsset\",\"Args\":[\"$RUN-b\",\"Dee\"]}" & X=$!                # concurrent pair -> one MVCC_READ_CONFLICT
inv "$BOTH" "{\"function\":\"TransferAsset\",\"Args\":[\"$RUN-b\",\"Eve\"]}" & Y=$!
wait $X $Y
H1=$(height); echo "height after: $H1"
mkdir -p blocks; : > audit-report.txt
declare -A NAME=([0]=MESSAGE [1]=CONFIG [2]=CONFIG_UPDATE [3]=ENDORSER_TRANSACTION [4]=ORDERER_TRANSACTION [5]=DELIVER_SEEK_INFO [6]=CHAINCODE_PACKAGE)
for n in $(seq $H0 $((H1 - 1))); do
  peer channel fetch $n blocks/block_$n.pb $ORDA -c $CHANNEL_NAME > /dev/null 2>&1 || { echo "fetch of block $n failed"; exit 1; }
  configtxlator proto_decode --input blocks/block_$n.pb --type common.Block --output blocks/block_$n.json || exit 1
  CODES=$(jq -c '.metadata.metadata[2] | @base64d | explode' blocks/block_$n.json)
  jq -r '.data.data | to_entries[] | "\(.key) \(.value.payload.header.channel_header.tx_id) \(.value.payload.header.channel_header.type)"' blocks/block_$n.json | \
  while read -r idx tx type; do
    code=$(echo "$CODES" | jq ".[$idx]"); st=$([ "$code" = 0 ] && echo VALID || echo INVALID)
    echo "BLOCK=$n TXID=${tx:0:16} TYPE=${NAME[$type]:-$type} VALIDATION_CODE=$code STATUS=$st" >> audit-report.txt
  done
done
TOTAL=$(grep -c '^BLOCK=' audit-report.txt); VALID=$(grep -c 'STATUS=VALID$' audit-report.txt); INVALID=$(grep -c 'STATUS=INVALID$' audit-report.txt)
cat audit-report.txt
echo "SUMMARY: blocks $H0..$((H1 - 1)) | total transactions=$TOTAL | valid=$VALID | invalid=$INVALID"
[ "$TOTAL" -ge 5 ] && [ "$INVALID" -ge 1 ] && [ $((VALID + INVALID)) = "$TOTAL" ] && exit 0
echo "unexpected audit result"; exit 1
