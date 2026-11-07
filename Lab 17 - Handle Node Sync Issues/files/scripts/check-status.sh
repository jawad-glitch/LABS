#!/bin/bash
source "$(dirname "$0")/node_ops.sh"
echo "node   | block     | peers | syncing"
echo "-------|-----------|-------|--------"
for n in node1 node2; do
  bn=$(rpc_call $n eth_blockNumber '[]' | python3 -c 'import sys,json;print(json.load(sys.stdin).get("result","?"))' 2>/dev/null)
  pc=$(rpc_call $n net_peerCount '[]' | python3 -c 'import sys,json;print(json.load(sys.stdin).get("result","?"))' 2>/dev/null)
  sy=$(rpc_call $n eth_syncing '[]' | python3 -c 'import sys,json;r=json.load(sys.stdin).get("result");print("false" if r is False else "object")' 2>/dev/null)
  printf "%-6s | %-9s | %-5s | %s\n" "$n" "$bn" "$pc" "$sy"
done
