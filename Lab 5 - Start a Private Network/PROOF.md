# Lab 5 - Start a Private Network - completion proof
Completed (UTC): 2026-11-07 14:49:35 | EC2: i-06c27fe0298901ac0 | host: ip-172-31-10-140 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 5 - Start a Private Network, 2026-11-07 14:49:29 UTC) ==========
PASS: Task 1: genesis.json has chainId=1337, clique.period=15, alloc.balance
PASS: Task 2: besu started and RPC answered
PASS: Task 3.2: web3_clientVersion answered with besu version
PASS: Task 3.3: net_version = 1337
PASS: Task 3.4: eth_blockNumber answered
PASS: Task 3.5: eth_getBlockByNumber(0x0) returned genesis
PASS: Task 3.6: eth_getBalance = 0x200000000000000000000
CORE: 7/7 PASS
```

## Files
```
./besu-startup.log
./besu-startup2.log
./genesis.json
./results/step3-2-clientversion.txt
./results/step3-3-netversion.txt
./results/step3-4-blocknumber.txt
./results/step3-5-genesis.txt
./results/step3-6-balance.txt
./results/task1-head.txt
./results/task1-ls.txt
./results/task2-startup-full.txt
./results/task2-startup.txt
```
