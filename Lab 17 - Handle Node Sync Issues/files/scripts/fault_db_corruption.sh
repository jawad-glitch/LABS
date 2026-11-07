#!/bin/bash
source "$(dirname "$0")/node_ops.sh"
H=$LAB_ROOT
BLOCK=$(rpc_call node2 eth_blockNumber '[]' | python3 -c 'import sys,json;print(int(json.load(sys.stdin)["result"],16))' 2>/dev/null)
stop_node node2
SST=$(find "$H/data/node2/database" -name '*.sst' -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -1 | cut -d' ' -f2-)
if [ -z "$SST" ]; then
  SST=$(find "$H/data/node2" -name '*.sst' -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -1 | cut -d' ' -f2-)
fi
if [ -n "$SST" ] && [ -f "$SST" ]; then
  dd if=/dev/zero of="$SST" bs=4096 count=1 conv=notrunc 2>/dev/null
  echo "corrupted $SST" >> "$H/logs/fault-events.log"
else
  echo "no sst found; corrupting a rocksdb header instead" >> "$H/logs/fault-events.log"
  [ -f "$H/data/node2/database/CURRENT" ] && dd if=/dev/zero of="$H/data/node2/database/CURRENT" bs=4096 count=1 conv=notrunc 2>/dev/null
fi
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) FAULT db_corruption at node2 block=$BLOCK" >> "$H/logs/fault-events.log"
start_node node2 config/node2.toml "$H/logs/node2.log" 2>/dev/null || true
echo "db corruption applied"
