#!/bin/bash
source "$(dirname "$0")/node_ops.sh"
H=$LAB_ROOT
R=$H/results
DIAG="$H/logs/diagnostic-report.json"
SUM="$H/logs/recovery-summary.txt"
ST="${1:-0}"  # optional start time

bash "$H/scripts/diagnose.sh" || true
faults=$(python3 -c "import json;print(len(json.load(open('$DIAG'))['detected_faults']))")
echo "[recover] $faults faults detected"
if [ "$faults" = 0 ]; then echo "nothing to do" | tee -a "$SUM"; exit 0; fi

declare -a PROCEDURES=()
if grep -qi 'RocksDB\|Corruption' "$DIAG"; then PROCEDURES+=("resync_from_genesis"); fi
if grep -qi 'peer count is 0' "$DIAG"; then PROCEDURES+=("restore_network_and_reconnect"); fi
if grep -qi 'block heights diverge' "$DIAG"; then PROCEDURES+=("restart_with_peer_refresh"); fi

resync_from_genesis() {
  echo "  -> resync_from_genesis: wipe node2 db + restart"
  bash "$H/scripts/fault_db_corruption_restore.sh"
}
restore_network_and_reconnect() {
  echo "  -> restore_network_and_reconnect: flush iptables + restart node2"
  bash "$H/scripts/fault_network_partition_restore.sh" 2>/dev/null || true
  stop_node node2
  [ -f "$H/backups/node2.toml.bak" ] && cp "$H/backups/node2.toml.bak" "$H/config/node2.toml"
  start_node node2 config/node2.toml "$H/logs/node2.log" || true
}
restart_with_peer_refresh() {
  echo "  -> restart_with_peer_refresh: restart node2 with bootnodes"
  stop_node node2
  [ -f "$H/backups/node2.toml.bak" ] && cp "$H/backups/node2.toml.bak" "$H/config/node2.toml"
  start_node node2 config/node2.toml "$H/logs/node2.log" || true
}

for p in "${PROCEDURES[@]}"; do
  echo "  executing: $p"
  $p
  sleep 3
done

# Wait for chain convergence (up to 120s)
echo "[recover] waiting for node2 to catch up..."
END=$((SECONDS+120))
while [ $SECONDS -lt $END ]; do
  bn1=$(rpc_call node1 eth_blockNumber '[]' | python3 -c 'import sys,json;print(int(json.load(sys.stdin)["result"],16))' 2>/dev/null || echo 0)
  bn2=$(rpc_call node2 eth_blockNumber '[]' | python3 -c 'import sys,json;print(int(json.load(sys.stdin)["result"],16))' 2>/dev/null || echo 0)
  if [ "$bn1" -gt 0 ] && [ "$bn1" = "$bn2" ]; then break; fi
  sleep 5
done

bash "$H/scripts/diagnose.sh" || true
faults_after=$(python3 -c "import json;print(len(json.load(open('$DIAG'))['detected_faults']))")
consistent=$(python3 -c "import json;print(json.load(open('$DIAG'))['chain_consistent'])")
final_b1=$(rpc_call node1 eth_blockNumber '[]' | python3 -c 'import sys,json;print(json.load(sys.stdin)["result"])' 2>/dev/null)
final_b2=$(rpc_call node2 eth_blockNumber '[]' | python3 -c 'import sys,json;print(json.load(sys.stdin)["result"])' 2>/dev/null)
now=$(date +%s); dur=$((now-ST))
{
  echo "=== recovery at $(date -u +%Y-%m-%dT%H:%M:%SZ) ==="
  echo "faults_detected_before: ${PROCEDURES[*]}"
  echo "procedures_applied:    ${PROCEDURES[*]}"
  echo "elapsed_seconds:       $dur"
  echo "final_node1_block:     $final_b1"
  echo "final_node2_block:     $final_b2"
  echo "chain_consistent:      $consistent"
  echo "faults_after:          $faults_after"
} | tee -a "$SUM"
