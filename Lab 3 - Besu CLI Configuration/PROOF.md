# Lab 3 - Besu CLI Configuration - completion proof
Completed (UTC): 2026-11-07 14:22:07 | EC2: i-0d0a948030b92a410 | host: ip-172-31-10-44 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 3 - Besu CLI Configuration, 2026-11-07 14:22:01 UTC) ==========
PASS: Task 1: besu --version prints a version and Java 21 active
PASS: Task 2.1/2.2: config.toml + dev.json written with expected keys
FAIL: Task 2.3: basic config started and web3_clientVersion answered
PASS: Task 3.1/3.2: debug + warn config files created
FAIL: Task 3.3-3.4: DEBUG config started, RPC answered (web3/net/eth_accounts)
PASS: Task 3.5: WARN config started and RPC answered
PASS: Task 4: advanced RPC on 8546 + txpool_status + GraphQL 8548 + WS 8547
PASS: Task 5: error config produced an error/warning in the log
PASS: Task 5.3/5.4: corrected config started, RPC + WS worked
PASS: Task 6: performance config started; metrics endpoint served data
PASS: Task 7.1: configuration-summary.md written
FAIL: Task 7.2: all 4 tested configs marked OK in final loop
CORE: 9/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./results/advanced-rpc.txt
./results/besu-version.txt
./results/corrected-rpc.txt
./results/debug-rpc.txt
./results/error-result.txt
./results/error-tail.txt
./results/final-test.txt
./results/java-version.txt
./results/performance-rpc.txt
./results/rpc-status.txt
```
