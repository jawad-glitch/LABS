# Lab 13 - Monitor Besu with Prometheus - completion proof
Completed (UTC): 2026-11-07 16:07:44 | EC2: i-077d3063e874429d6 | host: ip-172-31-10-56 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 13 - Monitor Besu with Prometheus, 2026-11-07 16:06:44 UTC) ==========
PASS: Task 1.1: docker installed and runnable
PASS: Task 2.1: besu 23.10.2 available
PASS: Task 2.2: besu config has metrics-enabled + prometheus protocol
PASS: Task 2.2: besu config data-path is absolute (not '~')
PASS: Task 2.3: besu running (RPC responds)
PASS: Task 2.3: besu metrics endpoint returns HELP lines
PASS: Task 3.1: prometheus.yml created with besu-node job
PASS: Task 3.2: prometheus container running, config endpoint 200
FAIL: Task 3.3: scrape up for besu-node = 1
FAIL: Task 4.2: ethereum_blockchain_height query returned data
FAIL: Task 4.2: process_cpu_seconds_total query returned data
PASS: Task 4.3: monitor-besu.sh ran, printed Node Status line
PASS: Task 5.1: verify-setup reports Besu running + metrics OK
FAIL: Task 5.2: activity generated (eth_sendTransaction responses)
CORE: 10/14 PASS
```

## Files
```
./config/besu-verbatim.toml
./config/besu.toml
./generate-activity.sh
./monitor-besu.sh
./prometheus.yml
./results/besu-version.txt
./results/besu.log
./results/docker-version.txt
./results/java-version.txt
./results/prometheus-pull.log
./results/prometheus-run.log
./results/task2.2-config-keys.txt
./results/task2.3-metrics-head.txt
./results/task3.1-prometheus-validate.txt
./results/task3.2-dockerps.txt
./results/task3.2-promlogs.txt
./results/task3.3-config.txt
./results/task3.3-targets.txt
./results/task3.3-upquery.txt
./results/task4.2-ethereum_blockchain_height_.json
./results/task4.2-ethereum_peer_count_.json
./results/task4.2-ethereum_transaction_pool_transactions_.json
./results/task4.2-process_cpu_seconds_total_.json
./results/task4.2-process_resident_memory_bytes_.json
./results/task4.2-up_.json
./results/task4.3-monitor.txt
./results/task5.1-verify.txt
./results/task5.2-activity.txt
./results/task5.2-monitor-after.txt
./verify-setup.sh
```
