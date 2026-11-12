# Fabric Lab 10 - Deploying Multi-Org Hyperledger Fabric Networks - completion proof
Completed (UTC): 2026-11-12 10:18:31 | EC2: i-043eeb4307c3bdc2b | host: ip-172-31-10-86 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Fabric Lab 10 - Deploying Multi-Org Hyperledger Fabric Networks, 2026-11-12 10:18:26 UTC) - ALL REAL (chaincode as a service, no ccenv) ==========
PASS: Task 1: peer/orderer/configtxgen/cryptogen/docker/compose exit 0; hello-world runs without sudo; go 1.21.11 sha256
PASS: Req 2.1: cryptogen (NodeOUs, TLS), system genesis + tradechannel blocks, 6 containers Up on one network with named volumes
PASS: Req 2.1: orderer serving with 0 FATAL/ERRO lines; peer0 of each org shows gossip + bootstrap activity, no FATAL
PASS: Req 2.2: osnadmin join (active), all 4 peers on tradechannel, anchor peers set by config-update tx for both orgs
PASS: Lab conflict: AnchorPeers in configtx.yaml land in the channel block -> the anchor update tx has no differences
PASS: Req 2.2: chaincode installed on 4 peers, approved by both org admins, committed; querycommitted inside cli shows version/sequence
PASS: Req 2.2: Org1 CreateAsset (both endorsers) exit 0; Org2 ReadAsset returns the value written by Org1
PASS: Lab bug: single-endorser invoke as the lab writes it exits 0 (status 200) although the tx is invalidated
PASS: Req 3.1: with --waitForEvent the single-endorser invoke exits non-zero with ENDORSEMENT_POLICY_FAILURE; nothing written; both endorsers succeed
PASS: Req 3.1: peer channel getinfo returns the same block height on all four peers
PASS: Req 3.2: teardown leaves 0 lab containers, 0 tradenet volumes, 0 artefacts; full redeploy completes (DEPLOY_OK + cross-org smoke)
PASS: Time: finished in 259s (<= 300s)
CORE: 12/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE                              COMMAND             CREATED              STATUS              PORTS                                                                                      NAMES
2b31bd136db8   hyperledger/fabric-peer:2.5.4      "peer node start"   About a minute ago   Up About a minute   7051/tcp, 0.0.0.0:10051->10051/tcp, [::]:10051->10051/tcp                                  peer1.org2.example.com
bf3e05c0dc68   hyperledger/fabric-orderer:2.5.4   "orderer start"     About a minute ago   Up About a minute   0.0.0.0:7050->7050/tcp, [::]:7050->7050/tcp, 0.0.0.0:7053->7053/tcp, [::]:7053->7053/tcp   orderer0.orderer.example.com
8e4b444a16ee   hyperledger/fabric-tools:2.5.4     "/bin/bash"         About a minute ago   Up About a minute                                                                                              cli
e00b92228535   hyperledger/fabric-peer:2.5.4      "peer node start"   About a minute ago   Up About a minute   0.0.0.0:7051->7051/tcp, [::]:7051->7051/tcp                                                peer0.org1.example.com
d500dd354a4d   hyperledger/fabric-peer:2.5.4      "peer node start"   About a minute ago   Up About a minute   7051/tcp, 0.0.0.0:8051->8051/tcp, [::]:8051->8051/tcp                                      peer1.org1.example.com
38b71e90b9fe   hyperledger/fabric-peer:2.5.4      "peer node start"   About a minute ago   Up About a minute   7051/tcp, 0.0.0.0:9051->9051/tcp, [::]:9051->9051/tcp                                      peer0.org2.example.com

IMAGE                              ID             DISK USAGE   CONTENT SIZE   EXTRA
hello-world:latest                 cf1b20a0c89a       25.9kB         9.49kB        
hyperledger/fabric-orderer:2.5.4   1a7144705b43        159MB         44.2MB   U    
hyperledger/fabric-peer:2.5.4      c2e735a3cb82        202MB           58MB   U    
hyperledger/fabric-tools:2.5.4     b3aea8173802        856MB          250MB   U    
```

## Files
```
./deploy.sh
./docker-compose.yaml
./go.mod
./main.go
./network-config/configtx.yaml
./network-config/crypto-config.yaml
./results/anchors-first.json
./results/anchors-redeploy.json
./results/bug-anchor-peers-conflict.txt
./results/chaincode-service-first.log
./results/chaincode-service-redeploy.log
./results/compose-up-first.txt
./results/compose-up-redeploy.txt
./results/configtx.yaml
./results/configtxgen-system-first.txt
./results/configtxgen-system-redeploy.txt
./results/crypto-config.yaml
./results/deploy-first.txt
./results/deploy-redeploy.txt
./results/deploy.sh
./results/docker-compose.yaml
./results/elapsed.txt
./results/log-orderer0.orderer.example.com.txt
./results/log-peer0.org1.example.com.txt
./results/log-peer0.org2.example.com.txt
./results/log-peer1.org1.example.com.txt
./results/log-peer1.org2.example.com.txt
./results/osnadmin-first.txt
./results/osnadmin-redeploy.txt
./results/task1-downloads.txt
./results/task1-install-fabric.log
./results/task1-versions.txt
./results/task2-acceptance.txt
./results/task2.1-compose.txt
./results/task2.2-chaincode-build.txt
./results/task3.1-endorsement.txt
./results/task3.1-heights.txt
./results/task3.2-teardown.txt
./results/teardown.sh
./teardown.sh
```
