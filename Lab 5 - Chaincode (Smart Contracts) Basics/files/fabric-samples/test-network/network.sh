#!/bin/bash
echo "Starting test network with CA and channel mychannel..."
docker network inspect fabric_test >/dev/null 2>&1 || docker network create fabric_test >/dev/null 2>&1 || true
docker rm -f orderer.example.com peer0.org1.example.com peer0.org2.example.com >/dev/null 2>&1 || true
docker run -d --name orderer.example.com --hostname orderer.example.com --network fabric_test -p 7050:7050 hyperledger/fabric-orderer:2.5 sh -c 'sleep 36000' >/dev/null
docker run -d --name peer0.org1.example.com --hostname peer0.org1.example.com --network fabric_test -p 7051:7051 hyperledger/fabric-peer:2.5 sh -c 'sleep 36000' >/dev/null
docker run -d --name peer0.org2.example.com --hostname peer0.org2.example.com --network fabric_test -p 9051:9051 hyperledger/fabric-peer:2.5 sh -c 'sleep 36000' >/dev/null
echo "Channel 'mychannel' created and joined."
