# Simulated - Fabric Lab 12 - Endorsement and Validation in Hyperledger Fabric
NOT executed: ./network.sh up createChannel -ca and network.sh deployCC (ccenv build) - time budget.
Swapped: cryptogen node identities + two LIVE Fabric CAs rooted in the same keys (user1 enrolled from ca_org1 is the client for every script);
asset-transfer-basic chaincode-go served as chaincode-as-a-service from container 'dev-peer0-basic-ccaas' (one service shared by both peers, not a peer-built dev-peer image).
Real: bootstrap.sh binaries (bit.ly), TLS network, mychannel, lifecycle seq 1 + seq 2 AND('Org1MSP.member','Org2MSP.member'), all four scripts, MVCC, block fetch/decode.
## Full mode
cd fabric-samples/test-network && ./network.sh up createChannel -ca && ./network.sh deployCC -ccn basic -ccp ../asset-transfer-basic/chaincode-go -ccl go
