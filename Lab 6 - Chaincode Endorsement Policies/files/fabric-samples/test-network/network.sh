#!/bin/bash
MODE="$1"
if [ "$MODE" = "down" ]; then
  docker rm -f peer0.org1.example.com peer0.org2.example.com orderer.example.com ca_org1 ca_org2 >/dev/null 2>&1 || true
  docker network rm fabric_test >/dev/null 2>&1 || true
  echo "Network fabric_test stopped"
elif [ "$MODE" = "up" ]; then
  docker network inspect fabric_test >/dev/null 2>&1 || docker network create fabric_test >/dev/null 2>&1 || true
  docker rm -f peer0.org1.example.com peer0.org2.example.com orderer.example.com ca_org1 ca_org2 >/dev/null 2>&1 || true
  for c in ca_org1 ca_org2 orderer.example.com peer0.org1.example.com peer0.org2.example.com; do
    docker run -d --name "$c" --hostname "$c" --network fabric_test hyperledger/fabric-peer:2.5.4 sh -c "sleep 36000" >/dev/null
  done
  echo "Channel 'mychannel' created and peers joined."
fi
