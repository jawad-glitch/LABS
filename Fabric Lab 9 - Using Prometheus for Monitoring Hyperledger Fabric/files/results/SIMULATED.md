# Simulated - Fabric Lab 9 - Using Prometheus for Monitoring Hyperledger Fabric
NOT executed: ./network.sh up createChannel -ca -s couchdb and deployCC (CA + CouchDB + tools + fabric-ccenv images exceed the 5-minute budget).
Swapped: cryptogen instead of Fabric CAs, LevelDB instead of CouchDB, chaincode-go contract run as chaincode-as-a-service instead of a ccenv build.
Real: Fabric 2.5.4 orderer + peer0.org1 + peer0.org2 with operations/metrics on 0.0.0.0 (host 9443/9444/9445), mychannel, asset-transfer-basic,
lab activity_generator.sh (background), Prometheus (72h, lifecycle, host-gateway) + Grafana provisioned as code, panel queries through Grafana,
FabricPeerDown triggered by stopping peer0.org2, the real test-network compose file analysed and merged with the lab override.
## Full mode
cd fabric-samples/test-network && ./network.sh up createChannel -ca -s couchdb && ./network.sh deployCC -ccn basic -ccp ../asset-transfer-basic/chaincode-go -ccl go
(the test network already exposes metrics on 9443 orderer / 9444 org1 / 9445 org2 - scrape those instead of overriding the ports)
docker compose -f docker-compose-monitoring.yml up -d
