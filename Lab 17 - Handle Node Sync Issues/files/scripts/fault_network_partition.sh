#!/bin/bash
source "$(dirname "$0")/node_ops.sh"
H=$LAB_ROOT
BLOCK=$(rpc_call node2 eth_blockNumber '[]' | python3 -c 'import sys,json;print(int(json.load(sys.stdin)["result"],16))' 2>/dev/null)
sudo iptables -I INPUT -p tcp --dport 30304 -j DROP 2>/dev/null
sudo iptables -I OUTPUT -p tcp --dport 30304 -j DROP 2>/dev/null
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) FAULT network_partition injected at node2 block=$BLOCK" >> "$H/logs/fault-events.log"
echo "partition applied, node2 froze at $BLOCK"
