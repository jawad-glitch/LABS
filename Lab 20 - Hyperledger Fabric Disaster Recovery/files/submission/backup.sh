#!/bin/bash
set -e
BASE="$HOME/fabric-dr-lab"
T="$BASE/fabric-samples/test-network"
ROOT="$BASE/backups"
mkdir -p "$ROOT" "$BASE/results"

STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
DEST="$ROOT/backup-$STAMP-$$"
mkdir -p "$DEST"/{crypto,channel-config,ledger,chaincode}

echo "Quiescing simulated network..."
touch "$BASE/results/QUIESCED"
cp -a "$T/organizations/." "$DEST/crypto/"
cp -a "$T/channel-artifacts/." "$DEST/channel-config/"
cp -a "$T/ledger/." "$DEST/ledger/"
cp -a "$T/chaincode/." "$DEST/chaincode/"
rm -f "$BASE/results/QUIESCED"

SIZE="$(du -sh "$DEST" | awk '{print $1}')"
{
 echo "Backup timestamp: $STAMP"
 echo "Backup type: Local Fabric disaster-recovery simulation"
 echo "Captured components:"
 echo "- Simulated organization crypto materials"
 echo "- Simulated channel configuration"
 echo "- Simulated peer and orderer ledger data"
 echo "- Simulated chaincode source"
 echo "Total backup size: $SIZE"
} > "$DEST/MANIFEST.txt"

ln -sfn "$DEST" "$ROOT/latest"
echo "Backup created: $DEST"
cat "$DEST/MANIFEST.txt"
