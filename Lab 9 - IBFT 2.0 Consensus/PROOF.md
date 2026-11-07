# Lab 9 - IBFT 2.0 Consensus - completion proof
Completed (UTC): 2026-11-07 15:28:09 | EC2: i-01cf992d9848410f3 | host: ip-172-31-10-94 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 9 - IBFT 2.0 Consensus, 2026-11-07 15:28:03 UTC) ==========
PASS: Task 1.1: validator1/2/3 with data dirs exist
PASS: Task 1.2/1.3: 3 addresses exported (40 hex each)
FAIL: Task 1.4/1.5: extraData is 162 bytes (324 hex after 0x)
PASS: Task 1.4: genesis has all 3 validator addresses in extraData
PASS: Task 1.4: genesis has ibft2 config
PASS: Task 1.6: genesis JSON valid
PASS: Task 2.1: per-validator configs exist with distinct RPC ports
FAIL: Task 2.2/2.3: validator1 RPC ready and enode captured
FAIL: Task 2.3: bootnodes updated in v2/v3 configs
FAIL: Task 2.4/2.5: all 3 validators RPC-ready
FAIL: Task 2.5: all 3 respond to eth_blockNumber
FAIL: Task 3 / IBFT: block produced (>0)
FAIL: Task 3.1: net_version = 1337
FAIL: Task 3.1: eth_chainId = 0x539 (=1337)
FAIL: Task 3.2: ibft_getValidatorsByBlockNumber returns 3 validators
FAIL: Task 3.2: ibft_getPendingVotes answered
FAIL: Task 3.3: monitor_blocks.sh printed block numbers
FAIL: Task 3.4: prefunded balance1 non-zero
FAIL: Task 3.4: prefunded balance2 non-zero
FAIL: Task 3.5: latest block has non-zero number
FAIL: Task 3.6: net_peerCount answered, admin_nodeInfo has enode
PASS: Task 6: lab_summary.txt written
CORE: 7/22 PASS
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
./validator1/address
./validator1/config.toml
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
