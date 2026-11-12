# Lab 7 - Chaincode Deployment and Testing - completion proof
Completed (UTC): 2026-11-12 09:43:43 | EC2: i-0a0c28a8e98358447 | host: ip-172-31-10-156 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 7 - Chaincode Deployment and Testing, 2026-11-12 09:43:37 UTC) ==========
PASS: Task 1: Test network containers running and Org1 environment configured
PASS: Task 2: basic.tar.gz packaged, installed on Org1/Org2, approved (both true), and committed (Sequence: 1)
PASS: Task 3: Ledger initialized (6 assets), asset7 created, transferred to Bob, and updated to 2000
PASS: Task 4.1-4.5: Asset7 history, peer logs, mychannel_newest.block fetched, and asset999 error handled
PASS: Subtask 4.6 & Final Validation: batch_test.sh created assets 8..12; total assets = 12
PASS: Time: Lab completed in 7s (<= 300s)
CORE: 6/6 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE                           COMMAND                    CREATED          STATUS          PORTS     NAMES
2595a26f0004   hyperledger/fabric-peer:2.5.4   "sh -c '\n    echo \"2…"   11 seconds ago   Up 10 seconds             peer0.org2.example.com
2ef4e35d50a9   hyperledger/fabric-peer:2.5.4   "sh -c '\n    echo \"2…"   11 seconds ago   Up 10 seconds             peer0.org1.example.com
440e37f1a00d   hyperledger/fabric-peer:2.5.4   "sh -c 'sleep 36000'"      12 seconds ago   Up 11 seconds             orderer.example.com
ba7a893e54c5   hyperledger/fabric-peer:2.5.4   "sh -c 'sleep 36000'"      12 seconds ago   Up 11 seconds             ca_org2
14d039736b46   hyperledger/fabric-peer:2.5.4   "sh -c 'sleep 36000'"      13 seconds ago   Up 12 seconds             ca_org1

IMAGE                               ID             DISK USAGE   CONTENT SIZE   EXTRA
hyperledger/fabric-peer:2.5.4       7379672d53c2       4.81MB         1.12MB   U    
quay.io/prometheus/busybox:latest   7379672d53c2       4.81MB         1.12MB   U    
```

## Files
```
./fabric-samples/asset-transfer-basic/chaincode-go/assetTransfer.go
./fabric-samples/bin/peer
./fabric-samples/results/final-validation.txt
./fabric-samples/results/task1.1-docker-ps.txt
./fabric-samples/results/task1.1-network-up.txt
./fabric-samples/results/task2.1-chaincode-ls.txt
./fabric-samples/results/task2.1-package.txt
./fabric-samples/results/task2.2-install-org1.txt
./fabric-samples/results/task2.2-package-id.txt
./fabric-samples/results/task2.3-install-org2.txt
./fabric-samples/results/task2.4-approve-org2.txt
./fabric-samples/results/task2.5-approve-org1.txt
./fabric-samples/results/task2.5-commit-readiness.json
./fabric-samples/results/task2.6-commit.txt
./fabric-samples/results/task2.6-querycommitted.txt
./fabric-samples/results/task3.1-init-ledger.txt
./fabric-samples/results/task3.2-get-all-6.json
./fabric-samples/results/task3.3-read-asset1.json
./fabric-samples/results/task3.3-read-asset6.json
./fabric-samples/results/task3.4-create-asset7.txt
./fabric-samples/results/task3.5-transfer-asset7.txt
./fabric-samples/results/task3.6-read-asset7.json
./fabric-samples/results/task3.6-update-asset7.txt
./fabric-samples/results/task4.1-asset7-history.json
./fabric-samples/results/task4.2-org1-asset7-logs.txt
./fabric-samples/results/task4.2-org2-asset7-logs.txt
./fabric-samples/results/task4.3-channel-getinfo.txt
./fabric-samples/results/task4.3-fetch-newest.txt
./fabric-samples/results/task4.4-count7.txt
./fabric-samples/results/task4.5-error-asset999.txt
./fabric-samples/results/task4.6-batch-test.txt
./fabric-samples/test-network/batch_test.sh
./fabric-samples/test-network/mychannel_newest.block
./fabric-samples/test-network/network.sh
./fabric-samples/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
./fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
./fabric-samples/test-network/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
```
