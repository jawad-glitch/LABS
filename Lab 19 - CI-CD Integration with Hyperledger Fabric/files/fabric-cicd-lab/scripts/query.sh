#!/bin/bash
BASE="$(cd "$(dirname "$0")/.." && pwd)"
[ -s "$BASE/network-state/products.json" ] || exit 1
cat "$BASE/network-state/products.json"
