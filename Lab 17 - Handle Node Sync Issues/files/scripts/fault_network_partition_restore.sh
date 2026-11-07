#!/bin/bash
source "$(dirname "$0")/node_ops.sh"
H=$LAB_ROOT
sudo iptables -D INPUT -p tcp --dport 30304 -j DROP 2>/dev/null
sudo iptables -D OUTPUT -p tcp --dport 30304 -j DROP 2>/dev/null
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) FAULT network_partition restored" >> "$H/logs/fault-events.log"
echo "partition cleared"
