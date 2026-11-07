# Lab 14 - Monitor Besu with Grafana - completion proof
Completed (UTC): 2026-11-07 16:19:10 | EC2: i-09bfa9d256e7674ef | host: ip-172-31-10-24 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 14 - Monitor Besu with Grafana, 2026-11-07 16:19:05 UTC) ==========
PASS: Task 1.1: docker installed and runnable
PASS: Task 1.1: grafana container health returned {database:ok}
PASS: Task 1.1: grafana logs show HTTP listener
PASS: Besu prerequisite: running
PASS: Besu prerequisite: metrics endpoint responded
PASS: Prometheus prerequisite: up
PASS: Prometheus prerequisite: scraping besu-node = up (via --network=host)
PASS: Task 2.1: datasource created
FAIL: Task 2.1: datasource test success
PASS: Task 3.1-3.5: dashboard created (uid=besu-monitoring)
PASS: Task 3.1-3.5: dashboard has 5+ panels
PASS: Task 4.1: Connected Peers gauge min=0 max=25
PASS: Task 4.2: auto-refresh=5s
PASS: Task 4.2: time range now-1h..now
PASS: Query: block_height returns data
PASS: Query: block_rate returns data
PASS: Query: gas_used returns data
PASS: Query: pending returns data (0 value OK)
PASS: Query: peers returns data
FAIL: Task 5.1: block height advanced (activity proof)
CORE: 18/20 PASS
```

## Files
```
./config/besu.toml
./dashboard-final.json
./prometheus.yml
./results/activity-block-1.txt
./results/activity-block-2.txt
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
./results/prometheus-run-host.log
./results/prometheus-run.log
./results/task2-datasource-create.txt
./results/task2-datasource-test.txt
./results/task3-dashboard-create.txt
./results/task3-query-results.txt
./results/task5-activity-1.txt
./results/task5-activity-2.txt
./results/task5-activity-3.txt
./results/task5-activity-head.txt
./results/task5-activity-summary.txt
./results/task5-height-after.txt
./results/task5-rawtx-attempt.txt
```
