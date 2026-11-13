#!/bin/bash
BASE="$(cd "$(dirname "$0")/.." && pwd)"
[ -s "$BASE/packages/inventory_1.0.tar.gz" ] || exit 1
mkdir -p "$BASE/network-state"
echo 1 > "$BASE/network-state/sequence.txt"
printf '[{"id":"P100","name":"Laptop","quantity":25,"owner":"Alice"},{"id":"P200","name":"Monitor","quantity":15,"owner":"Bob"}]\n' > "$BASE/network-state/products.json"
echo "Inventory chaincode deployed (local simulation)."
echo "InitLedger equivalent completed."
