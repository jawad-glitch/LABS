# Prometheus Lab 7 - Write Basic PromQL Queries - completion proof
Completed (UTC): 2026-11-12 07:47:53 | EC2: i-0788e599e00fe300c | host: ip-172-31-10-94 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Prometheus Lab 7 - Write Basic PromQL Queries, 2026-11-12 07:47:48 UTC) - ALL REAL ==========
PASS: Task 1: prometheus + node_exporter installed (sha256), started with the lab commands, both targets up
PASS: Lab bug: test_promql.sh as written has a bash syntax error (bare " in the python -c string) - every lab query fails
PASS: Task 2 (fixed script): CPU queries 1-5 return data
PASS: Task 3: memory queries 6-13 return data; total GB > 0 and usage % in 0-100
PASS: Task 4: aggregation queries 14-19 return data; by(mode) >= 5 modes, by(cpu) = 2 cores
PASS: Task 6: time ranges (1m/5m/10m), math and label-filter queries return data
PASS: Task 5.2: dashboard runs (exit 0), 9 sections, no 'No data'/'Error' lines
PASS: Lab bug: stress-ng was not installed (Subtask 5.3 fails as written); installed here
PASS: Task 5.3: under load the [1m] CPU usage rises clearly (> 5 points) and [5m] lags behind [1m]
PASS: Lab bug: 'prometheus --dry-run' is not a flag (exit != 0); promtool check config SUCCESS
PASS: Lab verify script passes 5/5, but a non-existent metric also returns status success (check is weak)
PASS: Time: finished in 97s (<= 300s)
CORE: 12/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./promql-lab/monitoring_dashboard.sh
./promql-lab/node_exporter.pid
./promql-lab/prometheus.pid
./promql-lab/prometheus.yml
./promql-lab/results/bug-test_promql-run.txt
./promql-lab/results/bug-test_promql-syntax.txt
./promql-lab/results/elapsed.txt
./promql-lab/results/node_exporter.log
./promql-lab/results/prometheus.log
./promql-lab/results/task1-install.txt
./promql-lab/results/task1.1-version.txt
./promql-lab/results/task1.2-console-flags.txt
./promql-lab/results/task1.4-services.txt
./promql-lab/results/task2-6-queries.txt
./promql-lab/results/task2-6-sanity.txt
./promql-lab/results/task2-6-table.txt
./promql-lab/results/task2.1-3.1-metrics.txt
./promql-lab/results/task2.2-lab-script.txt
./promql-lab/results/task5.2-dashboard-idle.txt
./promql-lab/results/task5.2-dashboard-summary.txt
./promql-lab/results/task5.3-dashboard-load-10s.txt
./promql-lab/results/task5.3-load.txt
./promql-lab/results/task5.3-stress-ng.log
./promql-lab/results/task5.3-stress-ng.txt
./promql-lab/results/task7.1-verify-summary.txt
./promql-lab/results/task7.1-verify.txt
./promql-lab/results/troubleshooting-promtool.txt
./promql-lab/results/troubleshooting.txt
./promql-lab/test_promql.sh
./promql-lab/test_promql_lab.sh
./promql-lab/verify_queries.sh
```
