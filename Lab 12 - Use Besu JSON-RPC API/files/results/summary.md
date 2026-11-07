# Lab 12 - Besu JSON-RPC API Summary

## Besu
besu/v23.10.2/linux-x86_64/openjdk-java-17

## RPC results
```
task1.4-clientversion: {"jsonrpc":"2.0","id":1,"result":"besu/v23.10.2/linux-x86_64/openjdk-java-17"}
task2.1-blocknumber: {"jsonrpc":"2.0","id":1,"result":"0x11"}
task2.1-netversion: {"jsonrpc":"2.0","id":1,"result":"2018"}
task2.1-netlistening: {"jsonrpc":"2.0","id":1,"result":true}
task2.2-latest-withtx: {"jsonrpc":"2.0","id":1,"result":{"number":"0x18","hash":"0x3d06d18ec344adb800be3409dddb8f2bb624ba9b762e86b0b1fef782b2ca3b1e","mixHash":"0xfd5bea34a62da6b5b25edb6c3ed31bf4ca728fb7cf9ad9482f355e74ce13722b","parentHash":"0
task2.2-block1: {"jsonrpc":"2.0","id":1,"result":{"number":"0x1","hash":"0x4dc39dcd4c3c854502e2e1f16c9fca0fa1c889e28a6ab2465ce7346a5ac1546a","mixHash":"0x6ddca709051f768900b3a53f471f168491eee2054d1d6bf44e50f382600175ad","parentHash":"0x
task2.2-latest-notx: {"jsonrpc":"2.0","id":1,"result":{"number":"0x18","hash":"0x3d06d18ec344adb800be3409dddb8f2bb624ba9b762e86b0b1fef782b2ca3b1e","mixHash":"0xfd5bea34a62da6b5b25edb6c3ed31bf4ca728fb7cf9ad9482f355e74ce13722b","parentHash":"0
task2.3-balance: {"jsonrpc":"2.0","id":1,"result":"0xdfc78210eb2c80000"}
task2.3-txcount: {"jsonrpc":"2.0","id":1,"result":"0x0"}
task2.4-txbyhash: {"jsonrpc":"2.0","id":1,"result":null}
task2.4-pending: {"jsonrpc":"2.0","id":1,"error":{"code":-32601,"message":"Method not found"}}
task2.5-gasprice: {"jsonrpc":"2.0","id":1,"result":"0x3e8"}
task2.5-chainid: {"jsonrpc":"2.0","id":1,"result":"0x539"}
task2.5-syncing: {"jsonrpc":"2.0","id":1,"result":false}
```

## Deviations
- Lab's --miner-enabled flag conflicts with --network=dev on Besu 23.10.2 (dev mode auto-mines).
  Script attempts lab-exact flags first; if Besu errors, it restarts with --network=dev alone.
  Functionally identical: dev mode uses instant mining and prefunds 0xfe3b...dbd73.
- eth_getTransactionByHash uses a dummy hash (no real transactions yet) → result: null, which
  is the correct JSON-RPC response for a non-existent tx.
