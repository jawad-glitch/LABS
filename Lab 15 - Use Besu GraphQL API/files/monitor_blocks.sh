#!/bin/bash
echo "Monitoring block generation (3 iterations)..."
for i in 1 2 3; do
  BLOCK_INFO=$(curl -s -X POST -H "Content-Type: application/json" \
    -d '{"query": "{ block { number timestamp } }"}' \
    http://localhost:8547/graphql)
  BLOCK_NUMBER=$(echo "$BLOCK_INFO" | jq -r '.data.block.number' 2>/dev/null)
  TIMESTAMP=$(echo "$BLOCK_INFO" | jq -r '.data.block.timestamp' 2>/dev/null)
  echo "Block: $BLOCK_NUMBER, Timestamp: $TIMESTAMP, Time: $(date)"
  sleep 3
done
