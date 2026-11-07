#!/bin/bash
echo "=== Besu Node Monitoring Dashboard ==="
echo "Timestamp: $(date)"
echo "=================================="
q() {
  local q="$1" label="$2"
  result=$(curl -s "http://localhost:9090/api/v1/query?query=$(python3 -c "import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1]))" "$q")" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    r = data['data']['result']
    if r:
        print('$label:', r[0]['value'][1])
    else:
        print('$label: no data')
except Exception:
    print('$label: query failed')
")
  echo "$result"
}
q "up{job='besu-node'}" "Node Status (1=up, 0=down)"
q "ethereum_blockchain_height" "Current Block Height"
q "ethereum_peer_count" "Connected Peers"
q "ethereum_transaction_pool_transactions" "Pending Transactions"
q "process_cpu_seconds_total" "CPU seconds (cumulative)"
q "process_resident_memory_bytes" "Memory (bytes)"
echo "=================================="
