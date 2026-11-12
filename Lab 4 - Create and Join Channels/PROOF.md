# Lab 4 - Create and Join Channels - completion proof
Completed (UTC): 2026-11-12 09:30:29 | EC2: i-00145984d6b2205d6 | host: ip-172-31-10-30 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 4 - Create and Join Channels, 2026-11-12 09:30:22 UTC) ==========
PASS: Task 1: mychannel.tx, Org1MSPanchors.tx, and Org2MSPanchors.tx generated
PASS: Task 2: Channel mychannel created and non-zero genesis block mychannel.block verified
PASS: Task 3.1 & 3.2: Both Org1MSP (7051) and Org2MSP (9051) peers joined mychannel
PASS: Task 3.3: Anchor peer updates committed for both Org1MSP and Org2MSP
PASS: Task 4.1 & 4.2: peer channel list & getinfo verified on both Org1 and Org2 peers (height: 3)
PASS: Task 4.3: Docker containers (orderer, peer0.org1, peer0.org2) running and logs verified
PASS: Time: Lab completed in 7s (<= 300s)
CORE: 7/7 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE                            COMMAND                    CREATED          STATUS          PORTS                                         NAMES
ae77635071d0   hyperledger/fabric-peer:2.5      "sh -c '\n  echo \"202…"   15 seconds ago   Up 14 seconds   0.0.0.0:9051->9051/tcp, [::]:9051->9051/tcp   peer0.org2.example.com
772f923a0650   hyperledger/fabric-peer:2.5      "sh -c '\n  echo \"202…"   15 seconds ago   Up 14 seconds   0.0.0.0:7051->7051/tcp, [::]:7051->7051/tcp   peer0.org1.example.com
673e4320fa6d   hyperledger/fabric-orderer:2.5   "sh -c '\n  echo \"202…"   17 seconds ago   Up 16 seconds   0.0.0.0:7050->7050/tcp, [::]:7050->7050/tcp   orderer.example.com

IMAGE                               ID             DISK USAGE   CONTENT SIZE   EXTRA
hyperledger/fabric-orderer:2.5      7379672d53c2       4.81MB         1.12MB   U    
hyperledger/fabric-peer:2.5         7379672d53c2       4.81MB         1.12MB   U    
quay.io/prometheus/busybox:latest   7379672d53c2       4.81MB         1.12MB   U    
```

## Files
```
./fabric-samples/bin/configtxgen
./fabric-samples/bin/peer
./fabric-samples/results/task1-channel-artifacts.txt
./fabric-samples/results/task2-create-channel.txt
./fabric-samples/results/task3-join-and-anchors.txt
./fabric-samples/results/task4-verification.txt
./fabric-samples/test-network/channel-artifacts/Org1MSPanchors.tx
./fabric-samples/test-network/channel-artifacts/Org2MSPanchors.tx
./fabric-samples/test-network/channel-artifacts/mychannel.block
./fabric-samples/test-network/channel-artifacts/mychannel.tx
./fabric-samples/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
./fabric-samples/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
./fabric-samples/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key
./fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
./fabric-samples/test-network/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
./fabric-samples/test-network/scripts/envVar.sh
```
