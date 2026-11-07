#!/bin/bash
./besu/bin/besu \
  --data-path=besu-node1/data --genesis-file=genesis.json --network-id=1337 \
  --rpc-http-enabled --rpc-http-api=ETH,NET,WEB3,EEA,PRIV,QBFT \
  --rpc-http-host=0.0.0.0 --rpc-http-port=8545 --rpc-http-cors-origins="*" \
  --privacy-enabled --privacy-url=http://localhost:9102 \
  --privacy-public-key-file=tessera-node1/keys/node1.pub \
  --min-gas-price=0 --logging=INFO
