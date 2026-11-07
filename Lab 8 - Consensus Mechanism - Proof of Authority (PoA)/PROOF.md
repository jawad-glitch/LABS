# Lab 8 - Consensus Mechanism - Proof of Authority (PoA) - completion proof
Completed (UTC): 2026-11-07 15:19:11 | EC2: i-0065055fa395faaf4 | host: ip-172-31-10-40 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 8 - Consensus Mechanism - Proof of Authority (PoA), 2026-11-07 15:19:06 UTC) ==========
PASS: Task 2.1: working dir + 3 validator dirs exist
PASS: Task 2.2/2.3: 3 validator addresses exported (40 hex each)
PASS: Task 2.4: genesis.json has all 3 validators in extraData + alloc
PASS: Task 2.4: genesis.json has clique period=15, epoch=30000
PASS: Task 2.5: genesis JSON valid
PASS: Task 3.1: init succeeded (log exists)
FAIL: Task 3.2/3.3: besu started (RPC_READY=1)
PASS: Task 3.3: block produced (BLOCK_READY=1)
PASS: Task 3.4: net_version = 1337
PASS: Task 4.1: eth_blockNumber > 0
PASS: Task 4.2: latest block has non-zero number
PASS: Task 4.3: monitor_blocks output shows block numbers
PASS: Task 4.4: clique_getSigners returned 3 validators
PASS: Task 4.4: clique_proposals answered
PASS: Task 4.5: V1 balance non-zero
PASS: Task 4.5: V2 balance non-zero
PASS: Task 5.1: poa_status_check complete
FAIL: Task 5.1: status shows chainId=1337 and Mining: true
FAIL: Task 5.2: block production produced >=1 block in 20s
PASS: Task 6.1: besu stopped (process gone)
PASS: Task 6.2: lab_summary.txt written
CORE: 18/21 PASS
```

## Files
```
./genesis.json
./lab_summary.txt
./monitor_blocks.sh
./poa_status_check.sh
./results/genesis-with-addresses.json
./results/task2.1-dirs.txt
./results/task2.2-v1-address.log
./results/task2.2-v1-pubkey.log
./results/task2.2-v2-address.log
./results/task2.2-v2-pubkey.log
./results/task2.2-v3-address.log
./results/task2.2-v3-pubkey.log
./results/task2.3-addresses.txt
./results/task2.5-genesis-head.txt
./results/task2.5-validate.txt
./results/task3.1-init-tail.txt
./results/task3.1-init.log
./results/task3.2-besu.log
./results/task3.2-pid.txt
./results/task3.4-netversion.txt
./results/task4.1-blocknumber.txt
./results/task4.2-latestblock.txt
./results/task4.3-monitor-blocks.txt
./results/task4.4-proposals.txt
./results/task4.4-signers.txt
./results/task4.5-balance-v1.txt
./results/task4.5-balance-v2.txt
./results/task5.1-status.txt
./results/task5.2-blockrate.txt
./validator1/DATABASE_METADATA.json
./validator1/address
./validator1/caches/CACHE_METADATA.json
./validator1/caches/logBloom-0.cache
./validator1/database/000004.log
./validator1/database/CURRENT
./validator1/database/IDENTITY
./validator1/database/LOCK
./validator1/database/LOG
./validator1/database/MANIFEST-000005
./validator1/database/OPTIONS-000055
./validator1/database/OPTIONS-000057
./validator1/key
./validator1/public_key
./validator2/address
./validator2/key
./validator2/public_key
./validator3/address
./validator3/key
./validator3/public_key
```
