#!/bin/bash
# node_ops.sh - interface contract per lab spec
# Source this: source scripts/node_ops.sh

BESU_BIN="${BESU_BIN:-$(command -v besu || echo /opt/besu-24.3.3/bin/besu)}"
LAB_ROOT="${LAB_ROOT:-$HOME/besu-sync-lab}"
declare -A NODE_RPC_PORT=( [node1]=8545 [node2]=8546 )

rpc_call() {
  local node="$1" method="$2" params="${3:-[]}" port
  port="${NODE_RPC_PORT[$node]:-}"
  [ -z "$port" ] && { echo "rpc_call: unknown node $node" >&2; return 1; }
  curl -s -m 3 -X POST -H "Content-Type: application/json" \
    -d "{\"jsonrpc\":\"2.0\",\"method\":\"$method\",\"params\":$params,\"id\":1}" \
    "http://127.0.0.1:$port" || return 1
}

await_rpc() {
  local node="$1" timeout="${2:-30}" i port
  port="${NODE_RPC_PORT[$node]}"
  for i in $(seq 1 $((timeout/2))); do
    if curl -s -m 1 -o /dev/null -X POST -H "Content-Type: application/json" \
      -d '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":1}' \
      "http://127.0.0.1:$port" 2>/dev/null; then return 0; fi
    sleep 2
  done
  return 1
}

start_node() {
  local node="$1" cfg="$2" log="$3"
  ( cd "$LAB_ROOT" && "$BESU_BIN" --config-file="$cfg" > "$log" 2>&1 & echo $! > "$LAB_ROOT/logs/${node}.pid" )
  sleep 2
  await_rpc "$node" 30 || { echo "start_node: $node RPC not ready" >&2; return 1; }
  return 0
}

stop_node() {
  local node="$1" pid i
  pid=$(cat "$LAB_ROOT/logs/${node}.pid" 2>/dev/null) || return 0
  kill -0 "$pid" 2>/dev/null || { rm -f "$LAB_ROOT/logs/${node}.pid"; return 0; }
  kill -TERM "$pid" 2>/dev/null
  for i in $(seq 1 15); do kill -0 "$pid" 2>/dev/null || { rm -f "$LAB_ROOT/logs/${node}.pid"; return 0; }; sleep 2; done
  kill -KILL "$pid" 2>/dev/null; sleep 1; rm -f "$LAB_ROOT/logs/${node}.pid"
}
