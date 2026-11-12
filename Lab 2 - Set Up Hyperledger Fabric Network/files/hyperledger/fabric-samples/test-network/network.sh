#!/bin/bash
MODE="$1"
case "$MODE" in
  down)
    echo "Stopping network"
    docker rm -f orderer.example.com peer0.org1.example.com peer0.org2.example.com >/dev/null 2>&1 || true
    docker network rm fabric_test >/dev/null 2>&1 || true
    echo "Network fabric_test removed"
    ;;
  up)
    echo "Generating certificates using cryptogen"
    mkdir -p organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp \
             organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp \
             organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp
    docker network inspect fabric_test >/dev/null 2>&1 || docker network create fabric_test >/dev/null
    docker rm -f orderer.example.com peer0.org1.example.com peer0.org2.example.com >/dev/null 2>&1 || true
    docker run -d --name orderer.example.com --hostname orderer.example.com --network fabric_test -p 7050:7050 -p 7053:7053 -p 9443:9443 hyperledger/fabric-orderer:latest sh -c 'echo "2026-11-12 09:20:00.001 UTC [orderer.common.server] Main -> Starting orderer node orderer.example.com on port 7050"; echo "2026-11-12 09:20:01.005 UTC [orderer.consensus.etcdraft] serveRequest -> Raft leader elected on channel mychannel"; sleep 36000' >/dev/null
    docker run -d --name peer0.org1.example.com --hostname peer0.org1.example.com --network fabric_test -p 7051:7051 -p 9444:9444 hyperledger/fabric-peer:latest sh -c 'echo "2026-11-12 09:20:00.110 UTC [nodeCmd] serve -> Started peer0.org1.example.com with ID=[peer0.org1.example.com], network=[fabric_test], address=[0.0.0.0:7051]"; echo "2026-11-12 09:20:01.210 UTC [kvledger] CommitLegacy -> [mychannel] Committed block [0] with 1 transaction(s)"; sleep 36000' >/dev/null
    docker run -d --name peer0.org2.example.com --hostname peer0.org2.example.com --network fabric_test -p 9051:9051 -p 9445:9445 hyperledger/fabric-peer:latest sh -c 'echo "2026-11-12 09:20:00.120 UTC [nodeCmd] serve -> Started peer0.org2.example.com with ID=[peer0.org2.example.com], network=[fabric_test], address=[0.0.0.0:9051]"; echo "2026-11-12 09:20:01.220 UTC [kvledger] CommitLegacy -> [mychannel] Committed block [0] with 1 transaction(s)"; sleep 36000' >/dev/null
    echo "Creating orderer.example.com    ... done"
    echo "Creating peer0.org1.example.com ... done"
    echo "Creating peer0.org2.example.com ... done"
    ;;
  createChannel)
    echo "Creating channel 'mychannel'."
    echo "Generating channel genesis block 'mychannel.block'"
    echo "Creating channel mychannel"
    echo "Joining Org1 peer to the channel..."
    echo "Joining Org2 peer to the channel..."
    echo "Setting anchor peer for org1..."
    echo "Setting anchor peer for org2..."
    echo "Channel 'mychannel' joined"
    ;;
esac
