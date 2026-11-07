# Lab 14 - Monitor Besu with Grafana - completion proof
Completed (UTC): 2026-11-07 16:15:53 | EC2: i-09bfa9d256e7674ef | host: ip-172-31-10-24 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 14 - Monitor Besu with Grafana, 2026-11-07 16:15:47 UTC) ==========
PASS: Task 1.1: docker installed and runnable
FAIL: Task 1.1: grafana container started (health=ok)
PASS: Task 1.1: grafana logs show HTTP listener
PASS: Besu prerequisites (needed for metrics): besu running
PASS: Besu prerequisites: metrics endpoint responding
PASS: Prometheus prerequisites: container up
FAIL: Prometheus prerequisites: scraping besu-node target = up
PASS: Task 2.1: datasource 'Prometheus-Besu' created
FAIL: Task 2.1: datasource test succeeded
PASS: Task 3.1-3.5: dashboard created via API (uid=besu-monitoring)
PASS: Task 3.1-3.5: dashboard contains 5 metric panels
PASS: Task 4.1: 'Connected Peers' gauge panel present with min=0 max=25
PASS: Task 4.2: dashboard auto-refresh set to 5s
PASS: Task 4.2: time range is now-1h to now
PASS: Task 4.2: variable time_range interval present (via refresh+time)
FAIL: Block Height query returns >=1 result
FAIL: Block Rate query returns >=1 result
FAIL: Peers query returns >=1 result
PASS: TxPool query returns >=1 result (0 value is fine)
FAIL: Gas Used query returns >=1 result
FAIL: Task 5.1: activity generated (eth_sendTransaction response)
FAIL: Task 5.1: block height advanced after activity
CORE: 13/22 PASS
```

## Files
```
./config/besu.toml
./dashboard-final.json
./prometheus.yml
./results/besu-metrics-raw.txt
./results/besu-version.txt
./results/besu.log
./results/dashboard-final.json
./results/dashboard-from-grafana.json
./results/dashboard.json
./results/docker-version.txt
./results/grafana-health.txt
./results/grafana-logs.txt
./results/grafana-pull.log
./results/grafana-run.log
./results/metric-names.txt
./results/prometheus-pull.log
./results/prometheus-run.log
./results/task2-datasource-create.txt
./results/task2-datasource-test.txt
./results/task3-dashboard-create.txt
./results/task3-query-results.txt
./results/task5-activity-1.txt
./results/task5-activity-2.txt
./results/task5-activity-3.txt
./results/task5-activity-head.txt
./results/task5-height-after.txt
```
