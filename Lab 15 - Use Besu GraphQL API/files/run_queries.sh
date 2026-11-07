#!/bin/bash
echo "=== Besu GraphQL Query Tests ==="
echo
echo "1. Latest Block Information:"
curl -s -X POST -H "Content-Type: application/json" \
  -d '{"query": "{ block { number hash timestamp } }"}' \
  http://localhost:8547/graphql | jq '.'
echo
echo "2. Network Gas Price:"
curl -s -X POST -H "Content-Type: application/json" \
  -d '{"query": "{ gasPrice }"}' \
  http://localhost:8547/graphql | jq '.'
echo
echo "3. Genesis Block:"
curl -s -X POST -H "Content-Type: application/json" \
  -d '{"query": "{ block(number: 0) { number hash timestamp } }"}' \
  http://localhost:8547/graphql | jq '.'
echo
echo "4. Coinbase Account Balance:"
curl -s -X POST -H "Content-Type: application/json" \
  -d '{"query": "{ account(address: \"0xfe3b557e8fb62b89f4916b721be55ceb828dbd73\") { balance } }"}' \
  http://localhost:8547/graphql | jq '.'
echo
echo "=== Query Tests Complete ==="
