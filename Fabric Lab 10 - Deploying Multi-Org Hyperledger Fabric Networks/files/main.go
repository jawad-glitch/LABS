// tradecc: minimal asset chaincode (fabric-contract-api-go). Runs as chaincode-as-a-service when CHAINCODE_SERVER_ADDRESS is set.
package main

import (
"fmt"
"log"
"os"

"github.com/hyperledger/fabric-chaincode-go/shim"
"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type TradeContract struct {
contractapi.Contract
}

// CreateAsset writes id -> value; fails if the asset already exists.
func (t *TradeContract) CreateAsset(ctx contractapi.TransactionContextInterface, id string, value string) error {
current, err := ctx.GetStub().GetState(id)
if err != nil {
return fmt.Errorf("read %s: %v", id, err)
}
if current != nil {
return fmt.Errorf("asset %s already exists", id)
}
return ctx.GetStub().PutState(id, []byte(value))
}

// ReadAsset returns the value stored under id.
func (t *TradeContract) ReadAsset(ctx contractapi.TransactionContextInterface, id string) (string, error) {
v, err := ctx.GetStub().GetState(id)
if err != nil {
return "", fmt.Errorf("read %s: %v", id, err)
}
if v == nil {
return "", fmt.Errorf("asset %s does not exist", id)
}
return string(v), nil
}

func main() {
cc, err := contractapi.NewChaincode(&TradeContract{})
if err != nil {
log.Panicf("create chaincode: %v", err)
}
if addr := os.Getenv("CHAINCODE_SERVER_ADDRESS"); addr != "" {
s := &shim.ChaincodeServer{CCID: os.Getenv("CHAINCODE_ID"), Address: addr, CC: cc, TLSProps: shim.TLSProperties{Disabled: true}}
if err := s.Start(); err != nil {
log.Panicf("chaincode server: %v", err)
}
return
}
if err := cc.Start(); err != nil {
log.Panicf("start chaincode: %v", err)
}
}
