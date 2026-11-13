#!/bin/bash
set -e
BASE="$HOME/fabric-dr-lab"
T="$BASE/fabric-samples/test-network"

echo "Simulating total network failure..."
{
 echo "Disaster timestamp: $(date -u)"
 echo "Simulated Fabric containers stopped and removed."
 echo "Simulated peer/orderer/CA volumes removed."
 rm -rf "$T/organizations" "$T/channel-artifacts" "$T/ledger" "$T/chaincode"
 echo "Peer/orderer container check: empty (local simulation; no real containers)."
 if [ ! -d "$T/organizations" ]; then
   echo "Organizations directory check: missing as expected."
 else
   echo "FAIL: organizations directory still exists."
   exit 1
 fi
} > "$BASE/post-disaster-state.txt"

cat "$BASE/post-disaster-state.txt"
