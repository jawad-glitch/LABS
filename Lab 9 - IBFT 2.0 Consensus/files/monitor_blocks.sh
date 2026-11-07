#!/bin/bash
echo "Monitoring block production..."
for i in {1..4}; do
    BLOCK_NUM=$(curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:8545 | python3 -c 'import sys,json;print(int(json.load(sys.stdin).get("result","0x0"),16))' 2>/dev/null || echo -1)
    echo "$(date): Block number: $BLOCK_NUM"
    sleep 2
done
