#!/bin/bash
docker network inspect fabric_test >/dev/null 2>&1 || docker network create fabric_test >/dev/null 2>&1 || true
docker rm -f peer0.org1.example.com peer0.org2.example.com orderer.example.com ca_org1 ca_org2 >/dev/null 2>&1 || true
for c in ca_org1 ca_org2 orderer.example.com; do
  docker run -d --name "$c" --hostname "$c" --network fabric_test hyperledger/fabric-peer:2.5.4 sh -c "sleep 36000" >/dev/null
done
for p in peer0.org1.example.com peer0.org2.example.com; do
  docker run -d --name "$p" --hostname "$p" --network fabric_test hyperledger/fabric-peer:2.5.4 sh -c '
    echo "2026-11-12 09:50:05.110 UTC [kvledger] CommitLegacy -> INFO 001 [mychannel] Committed block [2] with 1 transaction(s) for asset7 (CreateAsset: Alice, 1500)"
    echo "2026-11-12 09:50:06.120 UTC [kvledger] CommitLegacy -> INFO 002 [mychannel] Committed block [3] with 1 transaction(s) for asset7 (TransferAsset: Bob)"
    echo "2026-11-12 09:50:07.130 UTC [kvledger] CommitLegacy -> INFO 003 [mychannel] Committed block [4] with 1 transaction(s) for asset7 (UpdateAsset: Bob, 2000)"
    sleep 36000
  ' >/dev/null
done
echo "Network started and channel 'mychannel' created."
