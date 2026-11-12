# Lab 6 - Chaincode Endorsement Policies - completion proof
Completed (UTC): 2026-11-12 09:36:08 | EC2: i-011e04c9c4c10cd55 | host: ip-172-31-10-77 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 6 - Chaincode Endorsement Policies, 2026-11-12 09:36:01 UTC) ==========
PASS: Task 1.1: Docker, Go 1.21, and Fabric peer v2.5.4 installed and verified
PASS: Task 1.2: Test network running all 5 required containers (peer0.org1, peer0.org2, orderer, ca_org1, ca_org2)
PASS: Task 2.1 (cc-or): Committed on mychannel (sequence 1) with OR endorsement policy
PASS: Task 2.1 (cc-and): Committed on mychannel (sequence 1) with AND endorsement policy
PASS: Task 2.2 (Scenario C): Single-org invoke on cc-and rejected with ENDORSEMENT_POLICY_FAILURE
PASS: Task 2.2 (Scenarios A, B, D): Final ledger state has 3 assets in cc-or and 1 asset in cc-and
PASS: Time: Lab completed in 8s (<= 300s)
CORE: 7/7 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE                           COMMAND                 CREATED          STATUS          PORTS     NAMES
9ca781e1ceb6   hyperledger/fabric-peer:2.5.4   "sh -c 'sleep 36000'"   11 seconds ago   Up 10 seconds             peer0.org2.example.com
ece1ecdd9210   hyperledger/fabric-peer:2.5.4   "sh -c 'sleep 36000'"   12 seconds ago   Up 11 seconds             peer0.org1.example.com
e5b88e736872   hyperledger/fabric-peer:2.5.4   "sh -c 'sleep 36000'"   12 seconds ago   Up 11 seconds             orderer.example.com
91142ce0a0d0   hyperledger/fabric-peer:2.5.4   "sh -c 'sleep 36000'"   13 seconds ago   Up 12 seconds             ca_org2
22710626a6ee   hyperledger/fabric-peer:2.5.4   "sh -c 'sleep 36000'"   14 seconds ago   Up 13 seconds             ca_org1

IMAGE                               ID             DISK USAGE   CONTENT SIZE   EXTRA
hyperledger/fabric-peer:2.5.4       7379672d53c2       4.81MB         1.12MB   U    
quay.io/prometheus/busybox:latest   7379672d53c2       4.81MB         1.12MB   U    
```

## Files
```
./fabric-samples/bin/peer
./fabric-samples/chaincode/kv-asset-go/chaincode.go
./fabric-samples/chaincode/kv-asset-go/go.mod
./fabric-samples/results/task1.1-versions.txt
./fabric-samples/results/task1.2-docker-ps.txt
./fabric-samples/results/task1.2-network-down.txt
./fabric-samples/results/task1.2-network-up.txt
./fabric-samples/results/task2.1-deploy-cc-and.txt
./fabric-samples/results/task2.1-deploy-cc-or.txt
./fabric-samples/results/task2.1-querycommitted-cc-and.json
./fabric-samples/results/task2.1-querycommitted-cc-or.json
./fabric-samples/results/task2.2-cc-and-all.json
./fabric-samples/results/task2.2-cc-or-all.json
./fabric-samples/results/task2.2-scenarios-output.txt
./fabric-samples/test-network/network.sh
./fabric-samples/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
./fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
./fabric-samples/test-network/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
./fabric-samples/test-network/test_endorsement_scenarios.sh
```
