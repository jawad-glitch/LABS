# Lab 20 - End-to-End Blockchain Network Setup - completion proof
Completed (UTC): 2026-11-07 17:44:29 | EC2: i-0e3f4d475cda172dc | host: ip-172-31-10-138 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 20 - End-to-End Blockchain Network Setup, 2026-11-07 17:44:25 UTC) ==========
PASS: Task 1.1: docker engine + compose v2 installed
PASS: Task 1.1: hello-world ran (daemon usable)
PASS: Task 1.1: user is in the docker group
PASS: Task 1.2: besu, prometheus, grafana images present
PASS: Task 2: 3 node keys + 3 distinct addresses
PASS: Task 2: genesis extraData is 316 chars (0x + 314)
PASS: Task 2: genesis extraData encodes all 3 signers
PASS: Task 2: genesis alloc funds all 3 signers
FAIL: Task 2: 3 besu nodes + prometheus + grafana running
FAIL: AC 2.1: net_peerCount is 0x2 on all three nodes
FAIL: AC 2.1: eth_blockNumber greater than 0x0 on all three
FAIL: AC 2.2: clique_getSigners returns exactly 3 addresses
FAIL: AC 2.2: signers match genesis addresses exactly
PASS: Task 3A: Counter compiled to bytecode
FAIL: AC 3.1: count() returns 2 on all three RPC ports
FAIL: AC 3.2: Prometheus has all 3 besu targets UP
FAIL: AC 3.2: ethereum_blockchain_height has 3 series
FAIL: AC 3.2: block height is increasing between scrapes
PASS: AC 3.2: Grafana has the Prometheus datasource
PASS: AC 3.2: Grafana dashboard besu-height is provisioned
CORE: 11/20 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE                     COMMAND                  CREATED         STATUS                     PORTS                                         NAMES
261c99dd24ce   grafana/grafana:latest    "/run.sh"                6 minutes ago   Up 6 minutes               0.0.0.0:3000->3000/tcp, [::]:3000->3000/tcp   grafana
3c23e9817f12   hyperledger/besu:latest   "besu-entry.sh --dat…"   6 minutes ago   Exited (2) 5 minutes ago                                                 besu-node2
039b44b68435   hyperledger/besu:latest   "besu-entry.sh --dat…"   6 minutes ago   Exited (2) 5 minutes ago                                                 besu-node3
be7d917b11c1   prom/prometheus:latest    "/bin/prometheus --c…"   6 minutes ago   Up 6 minutes               0.0.0.0:9090->9090/tcp, [::]:9090->9090/tcp   prometheus
6d496aee3bbe   hyperledger/besu:latest   "besu-entry.sh --dat…"   6 minutes ago   Exited (2) 5 minutes ago                                                 besu-node1

IMAGE                     ID             DISK USAGE   CONTENT SIZE   EXTRA
grafana/grafana:latest    488984b716c0       2.01GB          503MB   U    
hello-world:latest        c567b231f656       25.9kB         9.49kB        
hyperledger/besu:latest   3d6ac0368d44        884MB          320MB   U    
prom/prometheus:latest    e04987641b57        389MB          116MB   U    
```

## Files
```
./results/clique-signers.txt
./results/compose-ps.txt
./results/compose-up.txt
./results/compose-version.txt
./results/contract-deploy.log
./results/contract-summary.txt
./results/count-calls-labeled.txt
./results/count-calls.txt
./results/docker-group.txt
./results/docker-images.txt
./results/docker-version.txt
./results/enode.txt
./results/eth-account-version.txt
./results/genesis-clique.txt
./results/genesis-extradata-len.txt
./results/grafana-dashboard.txt
./results/grafana-datasources.txt
./results/hello-world.txt
./results/keys.txt
./results/peer-counts.txt
./results/pip-install.txt
./results/prom-height-progress.txt
./results/prom-height-series.txt
./results/prom-targets.txt
./results/signers-genesis.txt
./results/signers-rpc.txt
./results/solc-compile.txt
./results/solc-version.txt
```
