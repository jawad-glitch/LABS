package main

import (
"encoding/json"
"fmt"
"log"

"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type SmartContract struct {
contractapi.Contract
}

type Asset struct {
ID    string `json:"ID"`
Value string `json:"value"`
}

func (s *SmartContract) CreateAsset(ctx contractapi.TransactionContextInterface, id string, value string) error {
asset := Asset{ID: id, Value: value}
b, err := json.Marshal(asset)
if err != nil {
return err
}
return ctx.GetStub().PutState(id, b)
}

func (s *SmartContract) ReadAsset(ctx contractapi.TransactionContextInterface, id string) (*Asset, error) {
b, err := ctx.GetStub().GetState(id)
if err != nil {
return nil, err
}
if b == nil {
return nil, fmt.Errorf("the asset %s does not exist", id)
}
var asset Asset
if err := json.Unmarshal(b, &asset); err != nil {
return nil, err
}
return &asset, nil
}

func (s *SmartContract) DeleteAsset(ctx contractapi.TransactionContextInterface, id string) error {
return ctx.GetStub().DelState(id)
}

func (s *SmartContract) GetAllAssets(ctx contractapi.TransactionContextInterface) ([]*Asset, error) {
iter, err := ctx.GetStub().GetStateByRange("", "")
if err != nil {
return nil, err
}
defer iter.Close()
var assets []*Asset
for iter.HasNext() {
qr, err := iter.Next()
if err != nil {
return nil, err
}
var a Asset
if err := json.Unmarshal(qr.Value, &a); err != nil {
return nil, err
}
assets = append(assets, &a)
}
return assets, nil
}

func main() {
cc, err := contractapi.NewChaincode(&SmartContract{})
if err != nil {
log.Panicf("error creating chaincode: %v", err)
}
if err := cc.Start(); err != nil {
log.Panicf("error starting chaincode: %v", err)
}
}
