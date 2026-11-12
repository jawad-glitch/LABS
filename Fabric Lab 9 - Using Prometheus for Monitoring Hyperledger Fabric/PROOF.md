# Fabric Lab 9 - Using Prometheus for Monitoring Hyperledger Fabric - completion proof
Completed (UTC): 2026-11-12 10:08:22 | EC2: i-0460dfaa39fdfffdf | host: ip-172-31-10-141 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Fabric Lab 9 - Using Prometheus for Monitoring Hyperledger Fabric, 2026-11-12 10:08:17 UTC) - network.sh/CA/CouchDB/ccenv SIMULATED, FABRIC + MONITORING REAL ==========
PASS: Task 1: lab 'wget -fsSL' invalid; go 1.21.9 sha256 OK; peer 2.5.x; Fabric + CA binaries; images pulled
PASS: Lab bug: real test-network already exposes metrics (orderer 9443, org1 9444, org2 9445); the lab override makes 2 services bind 9443
FAIL: Step 2.1: all three /metrics endpoints (9443/9444/9445) return 200 with # HELP lines
FAIL: Step 2.2: both peers on mychannel; basic committed; InitLedger OK; activity generator running in the background
FAIL: Step 3.1: prometheus + grafana running on network monitoring; 3 Fabric jobs up; retention 72h
PASS: Step 3.2: both alert rules loaded (health ok, inactive under normal operation)
FAIL: Live data: ledger_block_height and ledger_transaction_count present; endorsements/s > 0 from the generator
PASS: Lab bug: endorser_*_total / gossip_*_total do not exist (0 series); the peers expose them without _total
PASS: Grafana: provisioned datasource (proxy, default, http://prometheus:9090) OK; both dashboards in folder Fabric, refresh 10s, now-30m, 5 panels
FAIL: Grafana panels: lab dashboard shows No data on the 3 _total panels; fixed dashboard has data on block height, tx count, endorsement and gossip panels
PASS: Alerting: stopping peer0.org2 puts FabricPeerDown into pending/firing for job fabric-peer-org2; lab failure-rate expr has 0 series
FAIL: Time: finished in 346s (<= 300s)
CORE: 6/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE                              COMMAND                  CREATED         STATUS                     PORTS                                                                                                NAMES
2b375b34780a   grafana/grafana:latest             "/run.sh"                2 minutes ago   Up 2 minutes               0.0.0.0:3000->3000/tcp, [::]:3000->3000/tcp                                                          grafana
6fd34ca0327d   prom/prometheus:latest             "/bin/prometheus --c…"   2 minutes ago   Up 2 minutes               0.0.0.0:9090->9090/tcp, [::]:9090->9090/tcp                                                          prometheus
cc70f4c42c0f   hyperledger/fabric-orderer:2.5.4   "orderer start"          5 minutes ago   Exited (2) 4 minutes ago                                                                                                        orderer.example.com
d9eb3a9a2a05   hyperledger/fabric-peer:2.5.4      "peer node start"        5 minutes ago   Up 5 minutes               0.0.0.0:7051->7051/tcp, [::]:7051->7051/tcp, 0.0.0.0:9443->9443/tcp, [::]:9443->9443/tcp             peer0.org1.example.com
74c77cea4f02   hyperledger/fabric-peer:2.5.4      "peer node start"        5 minutes ago   Up 9 seconds               0.0.0.0:9051->9051/tcp, [::]:9051->9051/tcp, 7051/tcp, 0.0.0.0:9444->9444/tcp, [::]:9444->9444/tcp   peer0.org2.example.com

IMAGE                              ID             DISK USAGE   CONTENT SIZE   EXTRA
alpine:3.19                        6baf43584bcb       11.6MB         3.51MB        
grafana/grafana:latest             0615ec4fbd40       2.02GB          506MB   U    
hyperledger/fabric-orderer:2.5.4   1a7144705b43        159MB         44.2MB   U    
hyperledger/fabric-peer:2.5.4      c2e735a3cb82        202MB           58MB   U    
prom/prometheus:latest             e04987641b57        389MB          116MB   U    
```

## Files
```
./activity_generator.sh
./docker-compose-fabric.yaml
./docker-compose-monitoring.yml
./lab-override.yaml
./monitoring/grafana/dashboards/fabric-network-fixed.json
./monitoring/grafana/dashboards/fabric-network.json
./monitoring/grafana/provisioning/dashboards/fabric.yml
./monitoring/grafana/provisioning/datasources/prometheus.yml
./monitoring/prometheus/fabric-alerts.fixed.yml
./monitoring/prometheus/fabric-alerts.yml
./monitoring/prometheus/prometheus.yml
./network-config/configtx.yaml
./network-config/crypto-config.yaml
./network-config/orderer.yaml
./results/SIMULATED.md
./results/activity.log
./results/chaincode-service.log
./results/elapsed.txt
./results/log-grafana.txt
./results/log-orderer.example.com.txt
./results/log-peer0.org1.example.com.txt
./results/log-peer0.org2.example.com.txt
./results/log-prometheus.txt
./results/task1-downloads.txt
./results/task1-notes.txt
./results/task1-versions.txt
./results/task2-channel.txt
./results/task2-osnadmin.txt
./results/task2.1-configtxgen.txt
./results/task2.1-metrics-endpoints.txt
./results/task2.1-testnet-compose.txt
./results/task2.2-ccaas-build.txt
./results/task2.2-chaincode.txt
./results/task2.2-commit.txt
./results/task2.2-generator.txt
./results/task2.2-initledger.txt
./results/task3-metric-data.txt
./results/task3-metric-names.txt
./results/task3.1-monitoring.txt
./results/task3.2-alert-test.txt
./results/task3.2-grafana.txt
```
