# Prometheus Lab 4 - Install Node Exporter - completion proof
Completed (UTC): 2026-11-11 20:50:10 | EC2: i-0363d8c8e4a932f69 | host: ip-172-31-10-27 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Prometheus Lab 4 - Install Node Exporter, 2026-11-11 20:50:03 UTC) - ALL REAL ==========
PASS: Task 1: node_exporter 1.6.1 sha256-verified, installed, --version 1.6.1
PASS: Task 2: node_exporter.service enabled + active, running as user node_exporter
PASS: Task 3: :9100 serves node_cpu_seconds_total, node_memory_MemTotal_bytes, node_filesystem_size_bytes
PASS: Task 4: backup made; promtool SUCCESS; lab's 'SUCCESS: 2 rule files found' does not appear (no rule_files)
PASS: Task 5.2: prometheus and node_exporter targets UP (node_exporter every 10s)
PASS: Task 5.3: CPU, memory, disk queries return data
PASS: Lab bug: network query on device="eth0" is empty on this VM ( docker0 ens5 lo); fixed device filter returns data
PASS: Task 6: node_load1, disk read rate, network error rate queries return data
PASS: Lab bug: '--collector.cpu --collector.meminfo --collector.diskstats' keeps all defaults; disable-defaults gives exactly 3
PASS: Lab bug: ufw 'allow from 127.0.0.1' secures nothing - :9100 answered on the private IP (200) before the fix
PASS: Fixed: bound to 127.0.0.1 - private IP refused, localhost 200, Prometheus target still up
FAIL: Lab troubleshooting: 'journalctl -f' never returns (124); netstat missing
PASS: Time: finished in 69s (<= 300s)
CORE: 12/13 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./prometheus-lab4/etc/node_exporter.service.fixed
./prometheus-lab4/etc/node_exporter.service.lab
./prometheus-lab4/etc/prometheus.yml
./prometheus-lab4/results/advanced-collectors.txt
./prometheus-lab4/results/advanced-fs-flag.txt
./prometheus-lab4/results/elapsed.txt
./prometheus-lab4/results/prereq-download.txt
./prometheus-lab4/results/prereq.txt
./prometheus-lab4/results/security.txt
./prometheus-lab4/results/task1-install.txt
./prometheus-lab4/results/task2-status.txt
./prometheus-lab4/results/task3-interfaces.txt
./prometheus-lab4/results/task3-metrics.txt
./prometheus-lab4/results/task4.4-promtool.txt
./prometheus-lab4/results/task4.5-status.txt
./prometheus-lab4/results/task5-6-queries.txt
./prometheus-lab4/results/task5.2-targets.json
./prometheus-lab4/results/task5.2-targets.txt
./prometheus-lab4/results/troubleshooting.txt
```
