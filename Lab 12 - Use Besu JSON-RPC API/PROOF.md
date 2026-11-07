# Lab 12 - Use Besu JSON-RPC API - completion proof
Completed (UTC): 2026-11-07 16:00:06 | EC2: i-080867ebb382e57cd | host: ip-172-31-10-207 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 12 - Use Besu JSON-RPC API, 2026-11-07 15:59:58 UTC) ==========
PASS: Task 1.1: besu --version printed
PASS: Task 1.2: working dir + data dir exist
PASS: Task 1.3: besu started with RPC on 8545
PASS: Task 1.4: web3_clientVersion returned result string
PASS: Task 2.1: eth_blockNumber returned hex result
PASS: Task 2.1: net_version returned numeric string
PASS: Task 2.1: net_listening returned boolean
PASS: Task 2.2: latest block with txs returned block object
PASS: Task 2.2: block 0x1 returned block object
PASS: Task 2.2: latest block without txs returned object with number
PASS: Task 2.3: eth_getBalance returned non-zero balance for coinbase
PASS: Task 2.3: eth_getTransactionCount returned hex result
PASS: Task 2.4: eth_getTransactionByHash returned (result:null or result:obj, no RPC error)
FAIL: Task 2.4: eth_pendingTransactions returned an array
PASS: Task 2.5: eth_gasPrice returned hex
FAIL: Task 2.5: eth_chainId returned 0x7e2 (dev=2018)
PASS: Task 2.5: eth_syncing returned false or sync object
PASS: Verification: all 3 verify commands returned valid JSON
PASS: Summary.md generated
CORE: 17/19 PASS
```

## Files
```
./results/besu-version.txt
./results/besu.log
./results/java-version.txt
./results/summary.md
./results/task1.2-dirs.txt
./results/task1.4-clientversion.txt
./results/task2.1-blocknumber.txt
./results/task2.1-netlistening.txt
./results/task2.1-netversion.txt
./results/task2.2-block1.txt
./results/task2.2-latest-notx.txt
./results/task2.2-latest-withtx.txt
./results/task2.3-balance.txt
./results/task2.3-txcount.txt
./results/task2.4-pending.txt
./results/task2.4-txbyhash.txt
./results/task2.5-chainid.txt
./results/task2.5-gasprice.txt
./results/task2.5-syncing.txt
./results/verification.txt
```
