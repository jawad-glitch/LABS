# Lab 9 - IBFT 2.0 Consensus - completion proof
Completed (UTC): 2026-11-07 15:31:43 | EC2: i-01cf992d9848410f3 | host: ip-172-31-10-94 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 9 - IBFT 2.0 Consensus, 2026-11-07 15:31:37 UTC) ==========
PASS: Task 1.1: validator1/2/3 with data dirs exist
PASS: Task 1.2/1.3: 3 addresses exported (40 hex each)
PASS: Task 1.4/1.5: extraData file is 326 bytes (0x + 324 hex + newline)
sed: -e expression #1, char 1: unknown command: `"'
sed: -e expression #1, char 1: unknown command: `"'
sed: -e expression #1, char 1: unknown command: `"'
PASS: Task 1.4: genesis has all 3 validator addresses in extraData
PASS: Task 1.4: genesis has ibft2 config
PASS: Task 1.6: genesis JSON valid
PASS: Task 2.1: configs exist with distinct RPC ports
FAIL: Task 2.2/2.3: v1 RPC ready and enode captured
FAIL: Task 2.3: bootnodes patched (no placeholder left)
FAIL: Task 2.4/2.5: v2 and v3 RPC-ready
FAIL: Task 2.5: all 3 respond to eth_blockNumber
FAIL: Task 3: IBFT produced a block
FAIL: Task 3.1: net_version = 1337
FAIL: Task 3.1: eth_chainId = 0x539
FAIL: Task 3.2: ibft_getValidatorsByBlockNumber returns all 3
FAIL: Task 3.2: ibft_getPendingVotes answered
FAIL: Task 3.3: monitor_blocks shows positive block numbers
FAIL: Task 3.4: balance1 non-zero
FAIL: Task 3.4: balance2 non-zero
FAIL: Task 3.5: latest block has non-zero number
FAIL: Task 3.6: net_peerCount answered; admin_nodeInfo has enode
PASS: Task 6: lab_summary.txt written
CORE: 8/22 PASS
```

## Files
```
./genesis.json
./lab_summary.txt
./monitor_blocks.sh
./results/genesis-with-validators.json
./results/task1.1-dirs.txt
./results/task1.2-v1-addr.log
./results/task1.2-v1-pub.log
./results/task1.2-v2-addr.log
./results/task1.2-v2-pub.log
./results/task1.2-v3-addr.log
./results/task1.2-v3-pub.log
./results/task1.3-addresses.txt
./results/task1.5-extraData.txt
./results/task1.6-genesis-head.txt
./results/task1.6-validate.txt
./results/task2.1-configs.txt
./results/task2.3-enode.txt
./results/task2.5-ports.txt
./results/task3.1-blocknumber.txt
./results/task3.1-chainid.txt
./results/task3.1-netversion.txt
./results/task3.2-pendingvotes.txt
./results/task3.2-validators.txt
./results/task3.3-monitor.txt
./results/task3.4-balance1.txt
./results/task3.4-balance2.txt
./results/task3.5-latestblock.txt
./results/task3.6-nodeinfo.txt
./results/task3.6-peercount.txt
./results/v1.log
./results/v2.log
./results/v3.log
./validator1/address
./validator1/config.toml
./validator1/data/DATABASE_METADATA.json
./validator1/data/database/000004.log
./validator1/data/database/CURRENT
./validator1/data/database/IDENTITY
./validator1/data/database/LOCK
./validator1/data/database/LOG
./validator1/data/database/MANIFEST-000005
./validator1/data/database/OPTIONS-000055
./validator1/data/database/OPTIONS-000057
./validator1/data/key
./validator1/publickey
./validator2/address
./validator2/config.toml
./validator2/data/key
./validator2/publickey
./validator3/address
./validator3/config.toml
./validator3/data/key
./validator3/publickey
```
