# Lab 7 - Set Up Public Ethereum Network - completion proof
Completed (UTC): 2026-11-07 15:11:17 | EC2: i-0ee536bcee8b1da27 | host: ip-172-31-10-199 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 7 - Set Up Public Ethereum Network, 2026-11-07 15:11:11 UTC) ==========
PASS: Task 1.1: besu --version worked
FAIL: Task 1.1: java --version worked (17+)
PASS: Task 1.2: dirs exist (config data logs)
PASS: Task 2.1: genesis.json valid JSON, chainId=11155111
PASS: Task 2.2: config.toml has network, sync-mode, rpc-http, p2p, ws
PASS: Task 2.3: genesis JSON validated by python3
FAIL: Task 3.1: besu started (RPC_READY=1)
PASS: Task 3.2: log captured (>0 lines)
FAIL: Task 3.3: web3_clientVersion answered
FAIL: Task 3.3: net_version = 11155111
PASS: Task 3.3: eth_syncing answered
PASS: Task 4.1: net_peerCount answered
PASS: Task 4.1: admin_peers answered
PASS: Task 4.2: eth_blockNumber answered
PASS: Task 4.2: eth_getBlockByNumber(latest) answered
PASS: Task 4.3: monitor_sync.sh produced output with Peers
PASS: Task 5.1: eth_gasPrice answered
PASS: Task 5.1: eth_chainId = 0xaa36a7
PASS: Task 5.1: eth_protocolVersion answered (result or error object)
PASS: Task 5.2: network_info.sh ran and got real net_version
PASS: Task 6.1: diagnose.sh ran, printed Report header + RPC reachable
PASS: Task 6.2: performance_test.sh ran, produced timings
PASS: Task 7.1: final status report generated with chainId
PASS: Task 7.2: lab_report.md non-empty
PASS: Task 7.3: cleanup.sh executable
CORE: 21/25 PASS
```

## Files
```
./results/config-lab-verbatim.toml
./results/genesis-lab-verbatim.json
./results/task1-besu-version.txt
./results/task1-dirs.txt
./results/task1-java-version.txt
./results/task2-config-head.txt
./results/task2-genesis-head.txt
./results/task2-runtime-keys.txt
./results/task2-validate.txt
./results/task3-logtail.txt
./results/task3-p2p-lines.txt
./results/task3-startup-tail.txt
./results/task3.3-clientversion.txt
./results/task3.3-netversion.txt
./results/task3.3-syncing.txt
./results/task4.1-peercount.txt
./results/task4.1-peers.txt
./results/task4.2-blocknumber.txt
./results/task4.2-latestblock.txt
./results/task4.3-monitor-sample.txt
./results/task4.3-monitor.txt
./results/task5.1-chainid.txt
./results/task5.1-gasprice.txt
./results/task5.1-protocolversion.txt
./results/task5.2-networkinfo.txt
./results/task6.1-diagnose.txt
./results/task6.2-perf.txt
./results/task7.1-final.txt
./results/task7.2-report.txt
./results/task7.3-scripts.txt
```
