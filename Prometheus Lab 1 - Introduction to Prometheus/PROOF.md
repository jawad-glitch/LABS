# Prometheus Lab 1 - Introduction to Prometheus - completion proof
Completed (UTC): 2026-11-11 20:36:01 | EC2: i-0a9697b14efd24f6f | host: ip-172-31-10-143 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Prometheus Lab 1 - Introduction to Prometheus, 2026-11-11 20:35:53 UTC) - ALL REAL ==========
PASS: Download: prometheus-2.45.0 tarball present and sha256 verified against release sha256sums.txt
PASS: Extract: prometheus, promtool, prometheus.yml, consoles/, console_libraries/ present
PASS: Start: server ready, 'Start listening for connections' 0.0.0.0:9090 logged
PASS: Port 9090 listening (ss) by prometheus
FAIL: Lab bug: 'netstat' not installed on this Ubuntu - Subtask 4.3 fails
FAIL: Lab bug: 'curl -I /' returns 302 -> /graph (lab expects 200 OK); following it gives 200
PASS: API returns valid JSON: metric names > 50, build_info version 2.45.0
PASS: Prometheus monitors itself: 1 active target (job prometheus) health up, up = 1
PASS: Task 6: range query returns a matrix with samples; config_last_reload_successful = 1
PASS: promtool: config valid; lab's expected 'SUCCESS: 1 rule files found' does NOT appear (rule_files commented out)
PASS: Task 7.2/7.3: runtimeinfo and TSDB status endpoints return status success
PASS: Time: finished in 16s (<= 300s)
CORE: 10/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./prometheus-lab/prometheus-2.45.0.linux-amd64/LICENSE
./prometheus-lab/prometheus-2.45.0.linux-amd64/NOTICE
./prometheus-lab/prometheus-2.45.0.linux-amd64/console_libraries/menu.lib
./prometheus-lab/prometheus-2.45.0.linux-amd64/console_libraries/prom.lib
./prometheus-lab/prometheus-2.45.0.linux-amd64/consoles/index.html.example
./prometheus-lab/prometheus-2.45.0.linux-amd64/consoles/node-cpu.html
./prometheus-lab/prometheus-2.45.0.linux-amd64/consoles/node-disk.html
./prometheus-lab/prometheus-2.45.0.linux-amd64/consoles/node-overview.html
./prometheus-lab/prometheus-2.45.0.linux-amd64/consoles/node.html
./prometheus-lab/prometheus-2.45.0.linux-amd64/consoles/prometheus-overview.html
./prometheus-lab/prometheus-2.45.0.linux-amd64/consoles/prometheus.html
./prometheus-lab/prometheus-2.45.0.linux-amd64/data/lock
./prometheus-lab/prometheus-2.45.0.linux-amd64/data/queries.active
./prometheus-lab/prometheus-2.45.0.linux-amd64/data/wal/00000000
./prometheus-lab/prometheus-2.45.0.linux-amd64/prometheus.yml
./prometheus-lab/prometheus.pid
./prometheus-lab/results/elapsed.txt
./prometheus-lab/results/task1-download.txt
./prometheus-lab/results/task2-default-prometheus.yml
./prometheus-lab/results/task2-files.txt
./prometheus-lab/results/task3-prometheus.log
./prometheus-lab/results/task3-startup.txt
./prometheus-lab/results/task4-verify.txt
./prometheus-lab/results/task5-6-api.txt
./prometheus-lab/results/task5.2-metric-names.json
./prometheus-lab/results/task5.3-build-info.json
./prometheus-lab/results/task5.4-targets.json
./prometheus-lab/results/task6.1-up.json
./prometheus-lab/results/task6.2-up-range.json
./prometheus-lab/results/task6.3-reload.json
./prometheus-lab/results/task7-status.txt
./prometheus-lab/results/task7.1-promtool.txt
./prometheus-lab/results/task7.2-runtimeinfo.json
./prometheus-lab/results/task7.3-tsdb.json
./prometheus-lab/sha256sums.txt
```
