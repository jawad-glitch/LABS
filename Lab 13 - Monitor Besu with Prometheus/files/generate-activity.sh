#!/bin/bash
echo "Generating blockchain activity..."
for i in {1..5}; do
    curl -s -X POST -H "Content-Type: application/json" \
      -d '{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from":"0xfe3b557e8fb62b89f4916b721be55ceb828dbd73","to":"0x627306090abab3a6e1400e9345bc60c78a8bef57","value":"0x1000000000000000","gas":"0x21000"}],"id":1}' \
      http://localhost:8545 | head -c 200
    echo ""
    sleep 1
done
echo "done"
