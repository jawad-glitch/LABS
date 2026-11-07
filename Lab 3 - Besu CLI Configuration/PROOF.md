# Lab 3 - Besu CLI Configuration - completion proof
Completed (UTC): 2026-11-07 14:17:03 | EC2: i-0d0a948030b92a410 | host: ip-172-31-10-44 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 3 - Besu CLI Configuration, 2026-11-07 14:16:57 UTC) ==========
FAIL: Task 1: besu --version prints a version and Java 17+ is active
PASS: Task 2.1/2.2: config.toml + dev.json written with expected keys
FAIL: Task 2.3: basic config started and web3_clientVersion answered
PASS: Task 3.1/3.2: debug + warn config files created
FAIL: Task 3.3-3.4: DEBUG config started, RPC answered (web3/net/eth_accounts)
FAIL: Task 3.5: WARN config started and RPC answered
FAIL: Task 4: advanced RPC on 8546 + txpool_status + GraphQL 8548 + WS 8547
FAIL: Task 5: error config produced an error/warning in the log
FAIL: Task 5.3/5.4: corrected config started, RPC + WS worked
FAIL: Task 6: performance config started; metrics endpoint served data
PASS: Task 7.1: configuration-summary.md written
FAIL: Task 7.2: all 4 tested configs show ✓ in final loop
CORE: 3/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./results/besu-version.txt
./results/error-result.txt
./results/error-tail.txt
./results/final-test.txt
./results/java-version.txt
./results/rpc-status.txt
```
