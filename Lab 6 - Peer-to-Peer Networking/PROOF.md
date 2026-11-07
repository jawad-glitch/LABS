# Lab 6 - Peer-to-Peer Networking - completion proof
Completed (UTC): 2026-11-07 15:03:06 | EC2: i-06bf2956f3c6a8ed8 | host: ip-172-31-10-175 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 6 - Peer-to-Peer Networking, 2026-11-07 15:03:01 UTC) ==========
PASS: Task 1.1: besu --version worked
PASS: Task 1.2: dirs exist
PASS: Task 1.3: config/nodekey.pub non-empty
PASS: Task 2.1: config.toml has required keys
PASS: Task 2.2: genesis.json valid JSON, chainId=1337, clique.period=15
PASS: Task 3.2: static-nodes.json has 2 enodes
PASS: Task 3.3: config.toml has bootnodes and static-nodes-file
PASS: Task 3.4: scripts/peer-discovery.sh executable
PASS: Task 4.1: start-node.sh executable
FAIL: Task 4.2: besu started (RPC_READY=1)
FAIL: Task 4.3: web3_clientVersion answered
FAIL: Task 4.3: net_version = 1337
FAIL: Task 4.3: net_listening = true
FAIL: Task 4.4: net_peerCount answered
FAIL: Task 4.4: admin_nodeInfo has enode
FAIL: Task 4.4: admin_peers answered
PASS: Task 4.5: monitor-network.sh produced output
PASS: Task 5.1: advanced-config.toml exists
PASS: Task 5.2: test-p2p-network.sh ran
PASS: Task 5.3: troubleshoot-p2p.sh ran
PASS: Task 6.1: cleanup.sh executable
PASS: Task 6.2: P2P-SETUP-DOCUMENTATION.md non-empty
CORE: 15/22 PASS
```

## Files
```
./results/genesis-lab-verbatim.json
./results/genesis-runtime.json
./results/step4-3-clientversion.txt
./results/step4-3-net_listening.txt
./results/step4-3-netversion.txt
./results/step4-4-nodeinfo.txt
./results/step4-4-peercount.txt
./results/step4-4-peers.txt
./results/task1-dirs.txt
./results/task1-java.txt
./results/task1-nodekey.txt
./results/task1-version.txt
./results/task2-config-head.txt
./results/task2-config-verbatim.toml
./results/task2-runtime-genesis.txt
./results/task2-validate.txt
./results/task3-scripts.txt
./results/task3-static-nodes.txt
./results/task4-monitor.txt
./results/task4-nodeinfo-script.txt
./results/task4-peercount-script.txt
./results/task4-peers-script.txt
./results/task4-start.log
./results/task5-test.txt
./results/task5-troubleshoot.txt
./results/task6-doc.txt
```
