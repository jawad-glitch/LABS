#!/bin/bash
source "$(dirname "$0")/node_ops.sh"
H=$LAB_ROOT
BLOCK=$(rpc_call node2 eth_blockNumber '[]' | python3 -c 'import sys,json;print(int(json.load(sys.stdin)["result"],16))' 2>/dev/null)
stop_node node2
# Add --max-peers=0 AND clear bootnodes
cp "$H/config/node2.toml" "$H/backups/node2.toml.bak" 2>/dev/null
sed -i '/^bootnodes=/d' "$H/config/node2.toml"
grep -q '^max-peers=' "$H/config/node2.toml" || echo "max-peers=0" >> "$H/config/node2.toml"
start_node node2 config/node2.toml "$H/logs/node2.log"
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) FAULT peer_starvation at node2 block=$BLOCK" >> "$H/logs/fault-events.log"
echo "peer starvation applied; max-peers=0, no bootnodes"
