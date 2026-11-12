#!/bin/bash
ORDERER_CA="${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"
ORG1_TLS="${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt"
ORG2_TLS="${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt"

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE="$ORG1_TLS"
export CORE_PEER_MSPCONFIGPATH="${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp"
export CORE_PEER_ADDRESS=localhost:7051

echo "=== Scenario A: Invoke cc-or on Org1 peer only (Expected: SUCCESS) ==="
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "$ORDERER_CA" \
  -C mychannel -n cc-or --peerAddresses localhost:7051 --tlsRootCertFiles "$ORG1_TLS" \
  -c '{"function":"CreateAsset","Args":["or-asset-1","written-by-org1"]}'
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "$ORDERER_CA" \
  -C mychannel -n cc-or --peerAddresses localhost:7051 --tlsRootCertFiles "$ORG1_TLS" \
  -c '{"function":"CreateAsset","Args":["or-asset-3","written-by-org1-extra"]}'
peer chaincode query -C mychannel -n cc-or -c '{"function":"ReadAsset","Args":["or-asset-1"]}'

echo "=== Scenario B: Invoke cc-or on Org2 peer only (Expected: SUCCESS) ==="
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE="$ORG2_TLS"
export CORE_PEER_MSPCONFIGPATH="${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp"
export CORE_PEER_ADDRESS=localhost:9051
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "$ORDERER_CA" \
  -C mychannel -n cc-or --peerAddresses localhost:9051 --tlsRootCertFiles "$ORG2_TLS" \
  -c '{"function":"CreateAsset","Args":["or-asset-2","written-by-org2"]}'
peer chaincode query -C mychannel -n cc-or -c '{"function":"ReadAsset","Args":["or-asset-2"]}'

echo "=== Scenario C: Invoke cc-and on Org1 peer only (Expected: ENDORSEMENT_POLICY_FAILURE) ==="
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE="$ORG1_TLS"
export CORE_PEER_MSPCONFIGPATH="${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp"
export CORE_PEER_ADDRESS=localhost:7051
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "$ORDERER_CA" \
  -C mychannel -n cc-and --peerAddresses localhost:7051 --tlsRootCertFiles "$ORG1_TLS" \
  -c '{"function":"CreateAsset","Args":["and-asset-1","should-fail"]}' 2>&1 || true
peer chaincode query -C mychannel -n cc-and -c '{"function":"ReadAsset","Args":["and-asset-1"]}' 2>&1 || true

echo "=== Scenario D: Invoke cc-and on BOTH Org1 and Org2 peers (Expected: SUCCESS) ==="
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "$ORDERER_CA" \
  -C mychannel -n cc-and \
  --peerAddresses localhost:7051 --tlsRootCertFiles "$ORG1_TLS" \
  --peerAddresses localhost:9051 --tlsRootCertFiles "$ORG2_TLS" \
  -c '{"function":"CreateAsset","Args":["and-asset-1","endorsed-by-both-orgs"]}'
peer chaincode query -C mychannel -n cc-and -c '{"function":"ReadAsset","Args":["and-asset-1"]}'
