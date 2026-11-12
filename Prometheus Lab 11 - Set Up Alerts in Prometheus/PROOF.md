# Prometheus Lab 11 - Set Up Alerts in Prometheus - completion proof
Completed (UTC): 2026-11-12 08:12:42 | EC2: i-0cd53b19525e2467a | host: ip-172-31-10-79 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Prometheus Lab 11 - Set Up Alerts in Prometheus, 2026-11-12 08:12:34 UTC) - ALL REAL ==========
PASS: Task 1.1: 3 binaries sha256-verified; prometheus/alertmanager/node_exporter active as own non-login users; buildinfo has version
PASS: Task 1.2: Postfix local-only active; 9090, 9093, 9100 and 25 listening; node_cpu_seconds_total > 0
PASS: Lab gap: POST /-/reload needs --web.enable-lifecycle (403 without, 200 with)
PASS: Lab gap: Alertmanager without --storage.path (cwd / under systemd) cannot start as its user
PASS: Task 2.1: promtool SUCCESS for both rule files and the config
PASS: Task 2.2: rules API lists 4 alerting rules, all health ok
PASS: Lab bug: 'alertmanager --config.check' is not a flag; amtool check-config validates the config
PASS: Lab gap: with smtp_require_tls left at its default (true) the smoke alert is NOT delivered; with false it is
PASS: Task 3.2: HighCPUUsage reached firing in Prometheus under real CPU load (threshold 80%, adapted: no)
PASS: Task 3.2: /var/mail/ubuntu holds a message whose subject names HighCPUUsage; load processes stopped
PASS: Time: finished in 187s (<= 300s)
CORE: 11/11 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./prom-lab11/etc/alertmanager.lab.yml
./prom-lab11/etc/alertmanager.service
./prom-lab11/etc/alertmanager.yml
./prom-lab11/etc/cpu_alerts.lab.yml
./prom-lab11/etc/cpu_alerts.yml
./prom-lab11/etc/memory_alerts.yml
./prom-lab11/etc/node_exporter.service
./prom-lab11/etc/prometheus.service
./prom-lab11/etc/prometheus.yml
./prom-lab11/load.pids
./prom-lab11/results/SIMULATED.md
./prom-lab11/results/bug-alertmanager-config-check.txt
./prom-lab11/results/elapsed.txt
./prom-lab11/results/gap-alertmanager-storage-path.txt
./prom-lab11/results/gap-reload-lifecycle.txt
./prom-lab11/results/services.log
./prom-lab11/results/task-cpu-cap.txt
./prom-lab11/results/task1.1-downloads.txt
./prom-lab11/results/task1.1-services.txt
./prom-lab11/results/task1.2-ports.txt
./prom-lab11/results/task2.1-promtool.txt
./prom-lab11/results/task2.2-rules.txt
./prom-lab11/results/task3.1-alertmanager.txt
./prom-lab11/results/task3.1-amtool-fixed.txt
./prom-lab11/results/task3.1-amtool-lab.txt
./prom-lab11/results/task3.1-smoke-lab.log
./prom-lab11/results/task3.2-alertmanager-alerts.json
./prom-lab11/results/task3.2-alerts.json
./prom-lab11/results/task3.2-alerts.txt
./prom-lab11/results/task3.2-delivery.txt
./prom-lab11/results/task3.2-load.txt
./prom-lab11/results/task3.2-mailbox.txt
```
