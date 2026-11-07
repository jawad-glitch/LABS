#!/bin/bash
echo "Monitoring block generation..."
echo "Block Number | Timestamp | Miner"
echo "-------------|-----------|------"
for i in {1..4}; do
    BLOCK_INFO=$(curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest",false],"id":1}' http://localhost:8545)
    BLOCK_NUMBER=$(echo "$BLOCK_INFO" | python3 -c "import sys,json;r=json.load(sys.stdin).get('result');print(int(r['number'],16) if r else -1)" 2>/dev/null || echo -1)
    TIMESTAMP=$(echo "$BLOCK_INFO" | python3 -c "import sys,json;r=json.load(sys.stdin).get('result');print(int(r['timestamp'],16) if r else 0)" 2>/dev/null || echo 0)
    MINER=$(echo "$BLOCK_INFO" | python3 -c "import sys,json;r=json.load(sys.stdin).get('result');print(r['miner'] if r else '?')" 2>/dev/null || echo '?')
    echo "$BLOCK_NUMBER | $TIMESTAMP | $MINER"
    sleep 5
done
