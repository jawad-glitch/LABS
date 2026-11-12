# Prometheus Lab 15 - Troubleshooting Prometheus Scraping Issues - completion proof
Completed (UTC): 2026-11-12 08:33:29 | EC2: i-06d67ff2f79771116 | host: ip-172-31-10-139 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Prometheus Lab 15 - Troubleshooting Prometheus Scraping Issues, 2026-11-12 08:33:23 UTC) - ALL REAL ==========
PASS: Tasks 1-2: Prometheus 2.47.0 + node_exporter 1.6.1 sha256-verified, systemd services active
PASS: Task 3.2: prometheus + node-exporter UP, broken-target DOWN (connection refused)
PASS: Lab bug: 'systemctl reload' without ExecReload fails and the new jobs never load; with ExecReload they do
FAIL: Task 4: broken-port refused, wrong-path 404, non-existent-host DNS failure
FAIL: Lab bug: 'timeout-issue' is really a 404 (path /slow-metrics), not a timeout; a real timeout = context deadline exceeded
PASS: Lab bug: scrape failures are not in the logs at info level (0 lines mention the broken jobs); journalctl -f never returns
PASS: Lab bug: prometheus_target_scrape_duration_seconds / _scrapes_total / _last_scrape_timestamp_seconds do not exist (0 series)
PASS: Task 5: corrected config valid; all 7 targets UP; relabeled 8080->9100; location=dc1-r1; nonexistent host dropped
PASS: Task 7: 3 rules loaded health ok; ScrapeDurationHigh (lab metric) evaluates 0 series - cannot fire; fixed name has series
FAIL: Lab validate_fixes.sh: config valid, service running, targets 7/7 up
PASS: Task 8: runbook written; every query in the fixed query file returns success
PASS: Time: finished in 75s (<= 300s)
CORE: 9/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./prom-lab15/etc/prometheus.final.yml
./prom-lab15/etc/prometheus.initial.yml
./prom-lab15/etc/prometheus.problematic.yml
./prom-lab15/etc/prometheus.service
./prom-lab15/etc/prometheus.service.lab
./prom-lab15/etc/scraping_alerts.fixed.yml
./prom-lab15/etc/scraping_alerts.lab.yml
./prom-lab15/l15-slow-endpoint.py
./prom-lab15/prometheus_troubleshooting_runbook.md
./prom-lab15/results/bug-systemctl-reload.txt
./prom-lab15/results/elapsed.txt
./prom-lab15/results/prometheus.log
./prom-lab15/results/task1-install.txt
./prom-lab15/results/task3.2-initial-targets.txt
./prom-lab15/results/task4-target-errors.txt
./prom-lab15/results/task4-targets.json
./prom-lab15/results/task4.1-logs.txt
./prom-lab15/results/task4.2-metric-names.txt
./prom-lab15/results/task4.4-summary.txt
./prom-lab15/results/task4.4-troubleshoot.txt
./prom-lab15/results/task5.4-promtool.txt
./prom-lab15/results/task6.1-up.txt
./prom-lab15/results/task6.2-relabeling.txt
./prom-lab15/results/task6.3-validate.txt
./prom-lab15/results/task7-promtool-rules.txt
./prom-lab15/results/task7-rules.txt
./prom-lab15/results/task8-queries.txt
./prom-lab15/scraping_monitoring_queries.txt
./prom-lab15/slow-endpoint.pid
./prom-lab15/troubleshoot_prometheus.sh
./prom-lab15/validate_fixes.sh
```
