#!/bin/bash
CMD="$1"
case "$CMD" in
  up)
    echo "Using docker and docker-compose"
    echo "Starting nodes with CLI timeout of '5' tries and CLI delay of '3' seconds and using database 'leveldb'"
    echo "LOCAL_VERSION=2.4.7"
    echo "DOCKER_IMAGE_VERSION=2.4.7"
    echo "Creating network \"fabric_test\" with the default driver"
    echo "Creating volume \"compose_orderer.example.com\" with default driver"
    echo "Creating volume \"compose_peer0.org1.example.com\" with default driver"
    echo "Creating volume \"compose_peer0.org2.example.com\" with default driver"
    echo "Creating ca_org1 ... done"
    echo "Creating ca_org2 ... done"
    echo "Creating orderer.example.com    ... done"
    echo "Creating peer0.org1.example.com ... done"
    echo "Creating peer0.org2.example.com ... done"
    ;;
  createChannel)
    echo "Creating channel 'mychannel'."
    echo "Using organization 1"
    echo "Channel 'mychannel' created"
    echo "Joiningamoto org1 peer to the channel..."
    echo "Joining org2 peer to the channel..."
    echo "Setting anchor peer for org1..."
    echo "Setting anchor peer for org2..."
    echo "Channel 'mychannel' joined"
    ;;
  deployCC)
    echo "deploying chaincode on channel 'mychannel'"
    echo "Vendoring Go dependencies at ../asset-transfer-basic/chaincode-go"
    echo "Chaincode is packaged"
    echo "Installing chaincode on peer0.org1..."
    echo "Installing chaincode on peer0.org2..."
    echo "Querying installed chaincodes on peer0.org1... PackageID: basic_1.0:4ec191e793b27e953dff2ed5a8ab02c27f81d18a922d0b0976f97654c8f11b7e"
    echo "Approving chaincode definition for org1..."
    echo "Approving chaincode definition for org2..."
    echo "Committing chaincode definition on channel 'mychannel'..."
    echo "Chaincode definition committed on channel 'mychannel'"
    ;;
  down)
    echo "Stopping network"
    echo "Stopping peer0.org1.example.com ... done"
    echo "Stopping peer0.org2.example.com ... done"
    echo "Stopping orderer.example.com    ... done"
    echo "Stopping ca_org1                ... done"
    echo "Stopping ca_org2                ... done"
    echo "Removing network fabric_test"
    rm -f /tmp/fabric_ledger_state.json
    ;;
esac
