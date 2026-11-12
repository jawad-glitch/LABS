#!/bin/bash
# Lab contract: generate_invoke(asset_id, owner), generate_query(), main loop (100 x, 3 s sleep) -> activity.log
export PATH=$PATH:/home/ubuntu/fabric-monitoring-lab/fabric-samples/bin FABRIC_CFG_PATH=/home/ubuntu/fabric-monitoring-lab/fabric-samples/config
export CORE_PEER_TLS_ENABLED=false CORE_PEER_LOCALMSPID=Org1MSP CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_MSPCONFIGPATH=/home/ubuntu/fabric-monitoring-lab/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp CORE_PEER_TLS_ROOTCERT_FILE=/home/ubuntu/fabric-monitoring-lab/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
LOG=/home/ubuntu/fabric-monitoring-lab/activity.log
generate_invoke() {
  peer chaincode invoke -o localhost:7050 -C mychannel -n basic --peerAddresses localhost:7051 --peerAddresses localhost:9051 \
    -c "{\"function\":\"CreateAsset\",\"Args\":[\"$1\",\"blue\",\"5\",\"$2\",\"100\"]}" >/dev/null 2>&1
}
generate_query() { peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}' >/dev/null 2>&1; }
for i in $(seq 1 100); do
  generate_invoke "mon-asset-$i-$$" "owner$i"; ri=$?
  generate_query; rq=$?
  echo "$(date -u +%FT%TZ) iteration=$i invoke=$ri query=$rq" >> $LOG
  sleep 3
done
