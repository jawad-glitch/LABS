# Peer CLI environment for the endorsement lab (Org1 client user1 enrolled from ca_org1).
export PATH=$PATH:/home/ubuntu/fabric-lab12/bin FABRIC_CFG_PATH=/home/ubuntu/fabric-lab12/config
export CHANNEL_NAME=mychannel CC_NAME=basic ORDERER_ADDRESS=localhost:7050
export ORDERER_CA=/home/ubuntu/fabric-lab12/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem
export PEER0_ORG1_ADDRESS=localhost:7051 PEER0_ORG1_CA=/home/ubuntu/fabric-lab12/organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem PEER0_ORG2_ADDRESS=localhost:9051 PEER0_ORG2_CA=/home/ubuntu/fabric-lab12/organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem
export CORE_PEER_TLS_ENABLED=true CORE_PEER_LOCALMSPID=Org1MSP CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_TLS_ROOTCERT_FILE=/home/ubuntu/fabric-lab12/organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem CORE_PEER_MSPCONFIGPATH=/home/ubuntu/fabric-lab12/organizations/fabric-ca-identities/org1/user1/msp
