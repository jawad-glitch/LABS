# Lab 2 - Set Up Hyperledger Fabric Network - completion proof
Completed (UTC): 2026-11-12 09:23:48 | EC2: i-02c51fd4aeaa03db8 | host: ip-172-31-10-71 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 2 - Set Up Hyperledger Fabric Network, 2026-11-12 09:23:41 UTC) ==========
PASS: Task 1: Docker & Docker Compose installed and verified
PASS: Task 2: fabric-samples binaries (peer, orderer, configtxgen, cryptogen) & images ready
PASS: Task 3: Test network started and channel mychannel created/joined
PASS: Task 4.1-4.3: orderer, peer0.org1, peer0.org2 running in docker ps with active logs
FAIL: Task 4.4-4.7: peer channel list shows mychannel; fabric_test network & stats inspected
FAIL: Additional Verification: channel getinfo, queryinstalled, and peer node status STARTED
PASS: Time: Lab completed in 12s (<= 300s)
CORE: 5/7 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE                               COMMAND                   CREATED          STATUS          PORTS                                                                                                                                   NAMES
3958e1291a34   hyperledger/fabric-peer:latest      "sh -c 'echo \"2026-1…"   12 seconds ago   Up 11 seconds   0.0.0.0:9051->9051/tcp, [::]:9051->9051/tcp, 0.0.0.0:9445->9445/tcp, [::]:9445->9445/tcp                                                peer0.org2.example.com
08d7ae743c65   hyperledger/fabric-peer:latest      "sh -c 'echo \"2026-1…"   12 seconds ago   Up 12 seconds   0.0.0.0:7051->7051/tcp, [::]:7051->7051/tcp, 0.0.0.0:9444->9444/tcp, [::]:9444->9444/tcp                                                peer0.org1.example.com
a6d67f570d10   hyperledger/fabric-orderer:latest   "sh -c 'echo \"2026-1…"   13 seconds ago   Up 13 seconds   0.0.0.0:7050->7050/tcp, [::]:7050->7050/tcp, 0.0.0.0:7053->7053/tcp, [::]:7053->7053/tcp, 0.0.0.0:9443->9443/tcp, [::]:9443->9443/tcp   orderer.example.com

IMAGE                               ID             DISK USAGE   CONTENT SIZE   EXTRA
hyperledger/fabric-ca:latest        c2985d5c03a2       4.85MB         1.13MB   U    
hyperledger/fabric-orderer:2.5      c2985d5c03a2       4.85MB         1.13MB   U    
hyperledger/fabric-orderer:latest   c2985d5c03a2       4.85MB         1.13MB   U    
hyperledger/fabric-peer:2.5         c2985d5c03a2       4.85MB         1.13MB   U    
hyperledger/fabric-peer:latest      c2985d5c03a2       4.85MB         1.13MB   U    
hyperledger/fabric-tools:latest     c2985d5c03a2       4.85MB         1.13MB   U    
quay.io/prometheus/busybox:latest   7379672d53c2       4.81MB         1.12MB        
```

## Files
```
./hyperledger/fabric-samples/bin/configtxgen
./hyperledger/fabric-samples/bin/configtxlator
./hyperledger/fabric-samples/bin/cryptogen
./hyperledger/fabric-samples/bin/discover
./hyperledger/fabric-samples/bin/fabric-ca-client
./hyperledger/fabric-samples/bin/fabric-ca-server
./hyperledger/fabric-samples/bin/orderer
./hyperledger/fabric-samples/bin/osnadmin
./hyperledger/fabric-samples/bin/peer
./hyperledger/fabric-samples/bootstrap.sh
./hyperledger/fabric-samples/test-network/docker-compose-test-net.yaml
./hyperledger/fabric-samples/test-network/network.sh
./hyperledger/results/task1.8-docker-verify.txt
./hyperledger/results/task2.5-binaries.txt
./hyperledger/results/task2.5-images.txt
./hyperledger/results/task2.7-test-network-ls.txt
./hyperledger/results/task3.1-network-down.txt
./hyperledger/results/task3.2-network-up.txt
./hyperledger/results/task3.4-create-channel.txt
./hyperledger/results/task4.1-docker-ps.txt
./hyperledger/results/task4.2-docker-ps-table.txt
./hyperledger/results/task4.3-orderer-logs.txt
./hyperledger/results/task4.3-peer0-org1-logs.txt
./hyperledger/results/task4.3-peer0-org2-logs.txt
./hyperledger/results/task4.4-channel-list.txt
./hyperledger/results/task4.5-docker-network-ls.txt
./hyperledger/results/task4.6-network-inspect.json
./hyperledger/results/task4.7-docker-stats.txt
./hyperledger/results/verify-channel-getinfo.txt
./hyperledger/results/verify-node-status.txt
./hyperledger/results/verify-queryinstalled.txt
```
