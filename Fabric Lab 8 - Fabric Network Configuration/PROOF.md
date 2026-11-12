# Fabric Lab 8 - Fabric Network Configuration - completion proof
Completed (UTC): 2026-11-12 09:58:40 | EC2: i-083bc7348d9cb5a25 | host: ip-172-31-10-76 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Fabric Lab 8 - Fabric Network Configuration, 2026-11-12 09:58:35 UTC) - ALL REAL ==========
PASS: Task 1: docker, compose v2, go 1.21.11 (sha256), peer + orderer 2.5.x, fabric-ca-client 1.5.x
PASS: Req 2.1: custom core.yaml + orderer.yaml carry every table value (gossip 5s/25s/50, exec 120s, goleveldb, 50000, metrics disabled)
PASS: Req 2.1: configtxgen exit 0, labchannel.block > 0 bytes; BatchTimeout 2s, MaxMessageCount 10, AbsoluteMaxBytes 99 MB, etcdraft
PASS: Lab bug: inspectBlock JSON uses proto field names - the lab's '"BatchTimeout": "2s"' / '"MaxMessageCount": 10' strings never appear
PASS: Lab bug: Raft orderer with TLS fully disabled (no cluster TLS) cannot join labchannel
PASS: Req 2.2: orderer + 2 peers Up within 60s on fabric_lab; custom core.yaml mounted (values visible in the container)
PASS: Req 2.2: peer0.org1 log has gossip lines and 0 configuration-parse errors
PASS: Req 3.1: orderer joined (active, etcdraft consenter); both peers list labchannel
PASS: Golang install without a Docker socket in the peer fails (why the contract runs as a service)
PASS: Req 3.2: installed on both peers, approved by both orgs, committed with AND(Org1,Org2); Org2 sees approvals true/true
PASS: Req 3.2: InitLedger committed; Org2 ReadAsset asset1 exits 0 with "ID":"asset1" (no 'assetId' key); Org2 height > 1
PASS: Time: finished in 102s (<= 300s)
CORE: 12/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE                              COMMAND             CREATED              STATUS              PORTS                                                                                      NAMES
d7fb34efcf2b   hyperledger/fabric-peer:2.5.9      "peer node start"   About a minute ago   Up About a minute   7051/tcp, 0.0.0.0:9051->9051/tcp, [::]:9051->9051/tcp                                      peer0.org2.example.com
e79c197328a8   hyperledger/fabric-peer:2.5.9      "peer node start"   About a minute ago   Up About a minute   0.0.0.0:7051->7051/tcp, [::]:7051->7051/tcp                                                peer0.org1.example.com
a8c650cf1518   hyperledger/fabric-orderer:2.5.9   "orderer start"     About a minute ago   Up About a minute   0.0.0.0:7050->7050/tcp, [::]:7050->7050/tcp, 0.0.0.0:7053->7053/tcp, [::]:7053->7053/tcp   orderer.example.com

IMAGE                              ID             DISK USAGE   CONTENT SIZE   EXTRA
hyperledger/fabric-orderer:2.5.9   de0c97002679        166MB           46MB   U    
hyperledger/fabric-peer:2.5.9      4cd768f0e023        212MB         60.8MB   U    
```

## Files
```
./custom-config/configtx.yaml
./custom-config/core.yaml
./custom-config/crypto-config.yaml
./custom-config/orderer.tls-off-no-cluster.yaml
./custom-config/orderer.yaml
./docker-compose-lab.yaml
./main.go
./results/bug-raft-tls-off.txt
./results/chaincode-service.log
./results/configtx.yaml
./results/core.yaml
./results/crypto-config.yaml
./results/docker-compose-lab.yaml
./results/elapsed.txt
./results/labchannel-block.json
./results/log-orderer.example.com.txt
./results/log-peer0.org1.example.com.txt
./results/log-peer0.org2.example.com.txt
./results/orderer.tls-off-no-cluster.yaml
./results/orderer.yaml
./results/task1-downloads.txt
./results/task1-notes.txt
./results/task1-versions.txt
./results/task2-cryptogen.txt
./results/task2.1-block.txt
./results/task2.1-config-values.txt
./results/task2.1-configtxgen.txt
./results/task2.2-network.txt
./results/task3-ccaas-build.txt
./results/task3.1-channel.txt
./results/task3.1-join-org1.txt
./results/task3.1-join-org2.txt
./results/task3.1-osnadmin-join.txt
./results/task3.2-approve-ORG1.txt
./results/task3.2-approve-ORG2.txt
./results/task3.2-approve.txt
./results/task3.2-commit.txt
./results/task3.2-committed.json
./results/task3.2-getinfo-org2.json
./results/task3.2-golang-install.txt
./results/task3.2-initledger.txt
./results/task3.2-install-org1.txt
./results/task3.2-install-org2.txt
./results/task3.2-install.txt
./results/task3.2-readasset-org2.txt
./results/task3.2-readiness.json
./results/task3.2-result.txt
```
