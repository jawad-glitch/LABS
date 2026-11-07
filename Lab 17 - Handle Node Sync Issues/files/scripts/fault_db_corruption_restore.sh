#!/bin/bash
source "$(dirname "$0")/node_ops.sh"
H=$LAB_ROOT
stop_node node2
rm -rf "$H/data/node2/database"
start_node node2 config/node2.toml "$H/logs/node2.log" 2>/dev/null || true
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) FAULT db_corruption restored" >> "$H/logs/fault-events.log"
echo "db wiped; node2 will resync from node1"
