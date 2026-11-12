# Prometheus Lab 6 - Prometheus Metric Types - completion proof
Completed (UTC): 2026-11-12 07:26:18 | EC2: i-04866ede888af9c85 | host: ip-172-31-10-52 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Prometheus Lab 6 - Prometheus Metric Types, 2026-11-12 07:26:14 UTC) - ALL REAL ==========
FAIL: Task 1.1: venv with prometheus-client, psutil, flask importable
PASS: Lab bug: 'wget -fsSL' is invalid (curl flags) and downloads nothing; curl + sha256 OK; prometheus 2.52.0 runs
FAIL: Task 2.1: each service exposes its type (counter/gauge/histogram/summary), >= 2 # TYPE lines, PID files written
FAIL: Task 2.2: all 5 targets up
FAIL: Task 3.1: counter queries (rate, by status_code, increase of errors) non-empty
FAIL: Task 3.1: gauge queries (active_sessions, sum(queue_depth), memory MiB) non-empty
FAIL: Task 3.1: histogram queries (p50, p99, mean, db p95) non-empty
FAIL: Lab bug: Python client Summary has no quantiles -> both quantile queries EMPTY (sum/count mean works)
FAIL: Fixed summary (client-side sliding-window quantiles): quantile 0.5 and 0.99 queries non-empty
FAIL: Objective 3: aggregated histogram p99 lands in the true p99 bucket; avg() of summary p99s misses the true p99 by > 15%
PASS: Task 3.2: histogram_vs_summary.md filled, 0 placeholder comments
PASS: Time: finished in 234s (<= 300s)
CORE: 3/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./prom-lab/apps/counter_app.py
./prom-lab/apps/gauge_app.py
./prom-lab/apps/histogram_app.py
./prom-lab/apps/summary_app.py
./prom-lab/config/prometheus.yml
./prom-lab/data/lock
./prom-lab/data/queries.active
./prom-lab/data/wal/00000000
./prom-lab/histogram_vs_summary.md
./prom-lab/logs/counter.log
./prom-lab/logs/gauge.log
./prom-lab/logs/histogram.log
./prom-lab/logs/histogram2.log
./prom-lab/logs/prometheus.log
./prom-lab/logs/summary.log
./prom-lab/logs/summary2.log
./prom-lab/results/bug-python-summary-no-quantiles.txt
./prom-lab/results/bug-wget-fsSL.txt
./prom-lab/results/elapsed.txt
./prom-lab/results/fixed-summary-exposition.txt
./prom-lab/results/objective3-aggregation.txt
./prom-lab/results/port-9090.txt
./prom-lab/results/task-aggregation-promtool.txt
./prom-lab/results/task1.1-versions.txt
./prom-lab/results/task1.2-prometheus.txt
./prom-lab/results/task2.1-compile.txt
./prom-lab/results/task2.1-types.txt
./prom-lab/results/task2.2-targets.txt
./prom-lab/results/task3.1-counts-fixed.txt
./prom-lab/results/task3.1-counts-lab.txt
./prom-lab/results/task3.1-queries-fixed.txt
./prom-lab/results/task3.1-queries-lab.txt
./prom-lab/results/task3.1-summary-fixed.txt
./prom-lab/results/task3.1-summary-lab.txt
./prom-lab/results/task3.2-md-check.txt
```
