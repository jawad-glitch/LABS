# Prometheus Lab 14 - Prometheus Storage and Performance Tuning - completion proof
Completed (UTC): 2026-11-12 08:29:15 | EC2: i-0181790a94bb6930b | host: ip-172-31-10-253 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Prometheus Lab 14 - Prometheus Storage and Performance Tuning, 2026-11-12 08:29:09 UTC) - ALL REAL ==========
PASS: Install: Prometheus 2.47.0, node_exporter 1.6.1, Thanos 0.32.4 sha256-verified
PASS: Lab bug: Task 1.2 'storage.tsdb' retention/block keys are flags, not config - promtool rejects, Prometheus fails to start
PASS: Task 2.7 config valid; Prometheus active with the lab's storage flags (retention 30d/10GB, wal-compression)
PASS: Lab bug: sidecar with an upload bucket refuses Prometheus max-block-duration=25h (compaction must be off)
PASS: Fixed (min = max = 2h): sidecar, store, querier active; querier sees sidecar + store; 'up' via Thanos carries external labels
PASS: Task 3.6: 4 performance rules loaded, health ok
FAIL: Lab bug: query_duration is a summary - PrometheusSlowQueries/_bucket query returns 0 series; summary form returns a value
PASS: Lab bug: raw URLs - curl globbing breaks {..} and [..] queries; most lab monitor/query lines fail
PASS: Lab bug: the lab load script's range queries never reach Prometheus; the fixed load's do (+60)
PASS: Fixed monitor reports memory, CPU, head series, ingestion rate
PASS: Verification script: 5 services running, 5 endpoints accessible, all targets up
PASS: Time: finished in 121s (<= 300s)
CORE: 11/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./prom-lab14/etc/bucket.yml
./prom-lab14/etc/performance.yml
./prom-lab14/etc/prometheus.service
./prom-lab14/etc/prometheus.service.lab
./prom-lab14/etc/prometheus.task1.2.yml
./prom-lab14/etc/prometheus.yml
./prom-lab14/etc/thanos-querier.service
./prom-lab14/etc/thanos-sidecar.service
./prom-lab14/etc/thanos-store.service
./prom-lab14/results/bug-raw-url-globbing.txt
./prom-lab14/results/bug-task1-start.txt
./prom-lab14/results/bug-task1.2-promtool.txt
./prom-lab14/results/bug-thanos-sidecar-blocks.txt
./prom-lab14/results/elapsed.txt
./prom-lab14/results/install.txt
./prom-lab14/results/services.log
./prom-lab14/results/setup-resources.txt
./prom-lab14/results/task2.7-prometheus.txt
./prom-lab14/results/task2.7-promtool.txt
./prom-lab14/results/task2.9-stores.json
./prom-lab14/results/task2.9-thanos.txt
./prom-lab14/results/task3-lab-script-summary.txt
./prom-lab14/results/task3.1-monitor-fixed-baseline.txt
./prom-lab14/results/task3.1-monitor-lab.txt
./prom-lab14/results/task3.2-queries-lab.txt
./prom-lab14/results/task3.3-load-lab.txt
./prom-lab14/results/task3.4-load.txt
./prom-lab14/results/task3.4-monitor-after-load.txt
./prom-lab14/results/task3.4-monitor-during-load.txt
./prom-lab14/results/task3.5-storage.txt
./prom-lab14/results/task3.6-promtool.txt
./prom-lab14/results/task3.6-rules.txt
./prom-lab14/results/verify-setup.txt
./prom-lab14/scripts/generate_load.sh
./prom-lab14/scripts/generate_load_fixed.sh
./prom-lab14/scripts/performance_queries.sh
./prom-lab14/scripts/prometheus_performance_monitor.sh
./prom-lab14/scripts/prometheus_performance_monitor_fixed.sh
./prom-lab14/scripts/storage_analysis.sh
./prom-lab14/scripts/verify_setup.sh
```
