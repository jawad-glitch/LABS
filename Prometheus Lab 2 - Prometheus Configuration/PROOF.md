# Prometheus Lab 2 - Prometheus Configuration - completion proof
Completed (UTC): 2026-11-11 20:39:56 | EC2: i-004ba7956c56605f2 | host: ip-172-31-10-34 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Prometheus Lab 2 - Prometheus Configuration, 2026-11-11 20:39:50 UTC) - ALL REAL ==========
PASS: Setup: prometheus v3.16.0 + node_exporter v1.12.1 sha256-verified; prometheus.service active as user prometheus
PASS: Task 1: /etc/prometheus/prometheus.yml backed up (prometheus.yml.backup)
PASS: Task 3.2: promtool check config SUCCESS on the lab's 4-job config
PASS: Task 3.3: node_exporter service active, serving metrics on :9100
FAIL: Task 4: restart OK, /-/healthy 200, config reload successful = 1, no errors in journal
FAIL: Lab bug: 'journalctl -f' never returns (exit 124 after 5s); 'netstat' not installed
PASS: Task 5.2: prometheus + node-exporter UP; custom-app-fast/slow DOWN with connection refused (no service)
FAIL: Task 5.3: per-job interval/timeout as configured (10s, 15s/10s, 5s/3s, 60s/30s) and paths
PASS: Task 5.4 measured: samples/60s prometheus=6 (~6), node=4 (~4), fast=12 (~12), slow=1 (~1)
PASS: With services started, custom-app-fast (/metrics) and custom-app-slow (/health/metrics) go UP
PASS: Config reload without restart works (systemctl reload / POST /-/reload 200)
PASS: Advanced examples (basic_auth, file_sd, labels) pass promtool; password_file variant valid
PASS: Time: finished in 83s (<= 300s)
CORE: 10/13 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./prometheus-lab2/apps/l2-sample-app.py
./prometheus-lab2/etc/node_exporter.service
./prometheus-lab2/etc/prometheus-advanced-fixed.yml
./prometheus-lab2/etc/prometheus-advanced-lab.yml
./prometheus-lab2/etc/prometheus.service
./prometheus-lab2/etc/prometheus.yml
./prometheus-lab2/etc/prometheus.yml.default
./prometheus-lab2/results/advanced-promtool-fixed.txt
./prometheus-lab2/results/advanced-promtool-lab.txt
./prometheus-lab2/results/advanced.txt
./prometheus-lab2/results/elapsed.txt
./prometheus-lab2/results/setup-node-exporter-download.txt
./prometheus-lab2/results/setup-prometheus-download.txt
./prometheus-lab2/results/setup.txt
./prometheus-lab2/results/task1.1-ls.txt
./prometheus-lab2/results/task1.2-sections.txt
./prometheus-lab2/results/task3.2-promtool.txt
./prometheus-lab2/results/task3.3-node-exporter.txt
./prometheus-lab2/results/task4-reload-alternative.txt
./prometheus-lab2/results/task4-restart.txt
./prometheus-lab2/results/task4.1-journal.txt
./prometheus-lab2/results/task5-targets-final.json
./prometheus-lab2/results/task5-targets-initial.json
./prometheus-lab2/results/task5-targets-initial.txt
./prometheus-lab2/results/task5.4-intervals.txt
```
