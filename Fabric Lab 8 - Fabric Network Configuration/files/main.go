// Runs the lab's chaincode-go SmartContract as a chaincode-as-a-service server (peers use their built-in ccaas_builder).
package main

import (
"log"
"os"

"github.com/hyperledger/fabric-contract-api-go/v2/contractapi"
"github.com/hyperledger/fabric-samples/asset-transfer-basic/chaincode-go/chaincode"
"github.com/hyperledger/fabric-chaincode-go/v2/shim"
)

func main() {
cc, err := contractapi.NewChaincode(&chaincode.SmartContract{})
if err != nil {
log.Panicf("create chaincode: %v", err)
}
server := &shim.ChaincodeServer{
CCID:     os.Getenv("CHAINCODE_ID"),
Address:  os.Getenv("CHAINCODE_SERVER_ADDRESS"),
CC:       cc,
TLSProps: shim.TLSProperties{Disabled: true},
}
if err := server.Start(); err != nil {
log.Panicf("chaincode server: %v", err)
}
}
