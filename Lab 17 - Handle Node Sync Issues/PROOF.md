# Lab 17 - Handle Node Sync Issues - completion proof
Completed (UTC): 2026-11-07 17:04:00

## Core checks
```
========== CORE CHECKS (Lab 17 - Handle Node Sync Issues, 2026-11-07 17:03:55 UTC) ==========
PASS: Task 1.1: besu 24.x installed and runs
PASS: Task 1.1: java 21
PASS: Task 1.2: toolchain-verify has 6 non-empty entries
PASS: Task 1.2: node_ops.sh executable + 4 functions defined
PASS: Task 2.1: genesis has chainId=1337
PASS: Task 2.1: genesis has clique period 5
FAIL: Task 2.1: extraData is 254 hex chars (2 sealers)
FAIL: Task 2.1: both nodes peered (PEER_READY)
FAIL: Task 2.1: both nodes advancing blocks (BLOCK_READY)
PASS: Task 2.2: 3 fault scripts + 3 restore scripts present
PASS: Task 2.2: fault-network_partition-evidence shows divergence
PASS: Task 2.2: fault-peer_starvation-evidence exists
FAIL: Task 2.2: fault-db_corruption-evidence shows RocksDB/Corruption
PASS: Task 3.1: diagnose.sh produces valid JSON with required schema keys
PASS: Task 3.2: recover.sh exists and executable
FAIL: Task 3.2: cycle1 partition -> recovered chain_consistent
FAIL: Task 3.2: cycle2 starvation -> recovered chain_consistent
FAIL: Task 3.2: cycle3 corruption -> recovered chain_consistent
PASS: Final: chain_consistent=true
FAIL: Final: detected_faults=[] (0 items)
PASS: recovery-summary.txt has 3 cycles
CORE: 13/21 PASS
```
