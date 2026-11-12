#!/bin/bash
echo "Starting batch transaction test..."
for i in {8..12}; do
    echo "Creating asset$i..."
    peer chaincode invoke \
      -o localhost:7050 \
      --ordererTLSHostnameOverride orderer.example.com \
      --tls \
      --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" \
      -C mychannel \
      -n basic \
      --peerAddresses localhost:7051 \
      --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" \
      --peerAddresses localhost:9051 \
      --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" \
      -c "{\"function\":\"CreateAsset\",\"Args\":[\"asset$i\",\"color$i\",\"$((i*10))\",\"Owner$i\",\"$((i*100))\"]}"
done
echo "Batch test completed!"
