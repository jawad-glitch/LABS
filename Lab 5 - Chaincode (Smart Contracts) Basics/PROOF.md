# Lab 5 - Chaincode (Smart Contracts) Basics - completion proof
Completed (UTC): 2026-11-12 09:33:29 | EC2: i-0329976a3ec29f1e1 | host: ip-172-31-10-60 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 5 - Chaincode (Smart Contracts) Basics, 2026-11-12 09:33:22 UTC) ==========
PASS: Task 2: Go chaincode implemented in asset-transfer-basic-go/chaincode.go with go.mod
FAIL: Task 3: Chaincode packaged as basic.tar.gz
PASS: Task 4: Chaincode installed on Org1 and Org2 peers
PASS: Task 5: Chaincode approved by Org1MSP and Org2MSP; checkcommitreadiness true
PASS: Task 6: Chaincode committed to mychannel and verified
PASS: Task 7: Ledger initialized, GetAllAssets (6 items), CreateAsset (asset7), TransferAsset (asset1 -> Bob) verified
PASS: Time: Lab completed in 17s (<= 300s)
CORE: 6/7 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE                            COMMAND                 CREATED          STATUS          PORTS                                                   NAMES
5e1b9817b93a   hyperledger/fabric-peer:2.5      "sh -c 'sleep 36000'"   9 seconds ago    Up 9 seconds    7051/tcp, 0.0.0.0:9051->9051/tcp, [::]:9051->9051/tcp   peer0.org2.example.com
428b7264ce9f   hyperledger/fabric-peer:2.5      "sh -c 'sleep 36000'"   10 seconds ago   Up 9 seconds    0.0.0.0:7051->7051/tcp, [::]:7051->7051/tcp             peer0.org1.example.com
9896f6affd8c   hyperledger/fabric-orderer:2.5   "sh -c 'sleep 36000'"   11 seconds ago   Up 10 seconds   0.0.0.0:7050->7050/tcp, [::]:7050->7050/tcp             orderer.example.com

IMAGE                            ID             DISK USAGE   CONTENT SIZE   EXTRA
hyperledger/fabric-orderer:2.5   e322c57331d3        182MB         50.7MB   U    
hyperledger/fabric-peer:2.5      09ee75042de9        232MB         66.8MB   U    
```

## Files
```
./fabric-samples/bin/peer
./fabric-samples/chaincode/asset-transfer-basic-go/chaincode.go
./fabric-samples/chaincode/asset-transfer-basic-go/go.mod
./fabric-samples/results/task1.1-env-verify.txt
./fabric-samples/results/task1.3-network-down.txt
./fabric-samples/results/task1.3-network-up.txt
./fabric-samples/results/task2.3-gomod.txt
./fabric-samples/results/task3.2-package.txt
./fabric-samples/results/task4.1-install-org1.txt
./fabric-samples/results/task4.1-queryinstalled-org1.txt
./fabric-samples/results/task4.3-install-org2.txt
./fabric-samples/results/task4.3-queryinstalled-org2.txt
./fabric-samples/results/task5.1-approve-org2.txt
./fabric-samples/results/task5.2-approve-org1.txt
./fabric-samples/results/task5.3-commit-readiness.json
./fabric-samples/results/task6.1-commit.txt
./fabric-samples/results/task6.2-querycommitted.txt
./fabric-samples/results/task7.1-init-ledger.txt
./fabric-samples/results/task7.2-get-all-assets.json
./fabric-samples/results/task7.3-read-asset1.json
./fabric-samples/results/task7.4-create-asset7.txt
./fabric-samples/results/task7.5-transfer-asset1.txt
./fabric-samples/results/task7.6-verify-transfer.json
./fabric-samples/test-network/network.sh
./fabric-samples/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
./fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
./fabric-samples/test-network/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
```
