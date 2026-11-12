# Fabric Lab 12 - Endorsement and Validation in Hyperledger Fabric - completion proof
Completed (UTC): 2026-11-12 10:44:29 | EC2: i-009cc3fbe290e4484 | host: ip-172-31-10-188 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Fabric Lab 12 - Endorsement and Validation in Hyperledger Fabric, 2026-11-12 10:44:24 UTC) - network.sh/ccenv SIMULATED, NETWORK + POLICIES + VALIDATION REAL ==========
PASS: Req 1: bootstrap.sh (bit.ly) binaries; docker, compose, go, peer 2.5, configtxlator, jq answer with exit 0
PASS: Req 2: orderer + 2 peers + 2 CAs + chaincode container (dev-peer0..basic) Up; both peers on mychannel; user1 from Org1 CA
PASS: Req 2: basic committed (seq 1), InitLedger OK, GetAllAssets | jq . valid JSON array
PASS: Task 2: upgraded to seq 2; querycommitted decodes to AND('Org1MSP.member','Org2MSP.member')
PASS: two-org.sh: exit 0 on both runs (idempotent), Status: 200, txid from CLI found in peer log, ReadAsset fields match
PASS: single-org.sh: exit 1 on both runs with a line containing ENDORSEMENT_POLICY_FAILURE; asset not written
PASS: Lab gap: the same single-org invoke without --waitForEvent exits 0 (status 200) although the tx is invalidated
PASS: mvcc.sh: exit 0 on both runs; exactly one of the two concurrent transfers MVCC_READ_CONFLICT, confirmed in the peer validation log
PASS: instrument.sh without configtxlator/jq on PATH prints MISSING DEPENDENCY and exits 1
FAIL: instrument.sh: exit 0; >= 5 lines in the exact format; >= 1 STATUS=INVALID (codes 10 and 11 seen); valid + invalid = total
PASS: Every block in the report exists as blocks/block_<n>.pb (kept); metadata[2] is a base64 string, not an integer
PASS: Time: finished in 32s (<= 300s)
CORE: 11/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE                              COMMAND                  CREATED         STATUS         PORTS                                                                                      NAMES
a262ec5e5a64   alpine:3.19                        "/basic-ccaas"           4 minutes ago   Up 4 minutes                                                                                              dev-peer0-basic-ccaas
76d7ce2e1871   hyperledger/fabric-orderer:2.5.4   "orderer start"          6 minutes ago   Up 6 minutes   0.0.0.0:7050->7050/tcp, [::]:7050->7050/tcp, 0.0.0.0:7053->7053/tcp, [::]:7053->7053/tcp   orderer.example.com
a1ebe967de37   hyperledger/fabric-peer:2.5.4      "peer node start"        6 minutes ago   Up 6 minutes   0.0.0.0:7051->7051/tcp, [::]:7051->7051/tcp                                                peer0.org1.example.com
e706348bebd8   hyperledger/fabric-peer:2.5.4      "peer node start"        6 minutes ago   Up 6 minutes   7051/tcp, 0.0.0.0:9051->9051/tcp, [::]:9051->9051/tcp                                      peer0.org2.example.com
cb9b9c265af4   hyperledger/fabric-ca:1.5.7        "sh -c 'fabric-ca-se…"   6 minutes ago   Up 6 minutes   7054/tcp, 0.0.0.0:8054->8054/tcp, [::]:8054->8054/tcp                                      ca_org2
c9f76103c694   hyperledger/fabric-ca:1.5.7        "sh -c 'fabric-ca-se…"   6 minutes ago   Up 6 minutes   0.0.0.0:7054->7054/tcp, [::]:7054->7054/tcp                                                ca_org1

IMAGE                              ID             DISK USAGE   CONTENT SIZE   EXTRA
alpine:3.19                        6baf43584bcb       11.6MB         3.51MB   U    
hyperledger/fabric-ca:1.5.7        db814e013fc2        346MB          110MB   U    
hyperledger/fabric-orderer:2.5.4   1a7144705b43        159MB         44.2MB   U    
hyperledger/fabric-peer:2.5.4      c2e735a3cb82        202MB           58MB   U    
```

## Files
```
./blocks/block_16.json
./blocks/block_16.pb
./blocks/block_17.json
./blocks/block_17.pb
./blocks/block_18.json
./blocks/block_18.pb
./blocks/block_19.json
./blocks/block_19.pb
./blocks/block_20.json
./blocks/block_20.pb
./env.sh
./instrument.sh
./lib.sh
./mvcc.sh
./policy-decode.py
./results/SIMULATED.md
./results/audit-report.txt
./results/bug-metadata2-format.txt
./results/bug-single-org-no-wait.txt
./results/configtx.yaml
./results/crypto-config.yaml
./results/docker-compose.yaml
./results/elapsed.txt
./results/identity-check.txt
./results/log-ca_org1.txt
./results/log-dev-peer0-basic-ccaas.txt
./results/log-orderer.example.com.txt
./results/log-peer0.org1.example.com.txt
./results/log-peer0.org2.example.com.txt
./results/task1-bootstrap-url.txt
./results/task1-bootstrap.log
./results/task1-chaincode-build.txt
./results/task1-downloads.txt
./results/task1-versions.txt
./results/task2-channel-ca.txt
./results/task2-configtxgen.txt
./results/task2-deploy.txt
./results/task2-getallassets.json
./results/task2-mvcc-run1.txt
./results/task2-mvcc-run2.txt
./results/task2-osnadmin.txt
./results/task2-querycommitted.json
./results/task2-querycommitted.txt
./results/task2-single-org-run1.txt
./results/task2-single-org-run2.txt
./results/task2-two-org-run1.txt
./results/task2-two-org-run2.txt
./results/task2-upgrade.txt
./results/task3-instrument.txt
./results/task3-missing-dep.txt
./single-org.sh
./two-org.sh
```
