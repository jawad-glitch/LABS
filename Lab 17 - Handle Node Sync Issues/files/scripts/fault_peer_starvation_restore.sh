#!/bin/bash
source "$(dirname "$0")/node_ops.sh"
H=$LAB_ROOT
stop_node node2
[ -f "$H/backups/node2.toml.bak" ] && cp "$H/backups/node2.toml.bak" "$H/config/node2.toml"
start_node node2 config/node2.toml "$H/logs/node2.log"
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) FAULT peer_starvation restored" >> "$H/logs/fault-events.log"
echo "peer starvation cleared"
