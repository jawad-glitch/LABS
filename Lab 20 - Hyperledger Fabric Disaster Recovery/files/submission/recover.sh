#!/bin/bash
set -e
BASE="$HOME/fabric-dr-lab"
T="$BASE/fabric-samples/test-network"
SRC="$BASE/backups/latest"

[ -d "$SRC" ] || { echo "FAIL: latest backup unavailable"; exit 1; }

mkdir -p "$T/organizations" "$T/channel-artifacts" "$T/ledger" "$T/chaincode"
cp -a "$SRC/crypto/." "$T/organizations/"
cp -a "$SRC/channel-config/." "$T/channel-artifacts/"
cp -a "$SRC/ledger/." "$T/ledger/"
cp -a "$SRC/chaincode/." "$T/chaincode/"

test -s "$T/ledger/peer0/assets.json"
test -s "$T/channel-artifacts/mychannel.block"
echo "PASS: Simulated recovery restored crypto, channel, ledger and chaincode files."
