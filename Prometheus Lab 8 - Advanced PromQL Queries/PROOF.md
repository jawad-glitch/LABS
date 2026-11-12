# Prometheus Lab 8 - Advanced PromQL Queries - completion proof
Completed (UTC): 2026-11-12 07:54:26 | EC2: i-06e8c490b4fa1e24d | host: ip-172-31-10-193 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Prometheus Lab 8 - Advanced PromQL Queries, 2026-11-12 07:54:19 UTC) - ALL REAL ==========
PASS: Step 1.1: Prometheus 2.52.0 + node_exporter 1.8.1 sha256-verified, consoles copied, promtool SUCCESS
PASS: Lab bug: root-owned /var/lib/prometheus stops Prometheus started as ubuntu; fixed with chown
PASS: Step 1.2: node_memory_MemTotal_bytes served; up = 1 for prometheus and node
PASS: Lab bug: 'pip3 install' (and --user) hit externally-managed-environment on 24.04; venv has prometheus-client
PASS: Step 2.1: >= 200 requests observed on 2 endpoints with the exact bucket set
PASS: Step 2.2: append + promtool OK, SIGHUP to exactly 1 process, up{job=app} = 1
FAIL: Queries A/B return 2 series each, C returns 1; p99 (C) > p50 (A) by >= 1 bucket boundary
PASS: Step 3.1: all five queries success + non-empty; Q1 one value in 0-100; Q2 <= 5 series from >= 4 metric names
FAIL: Step 3.1: Q3 percentages within 0-100; Q4 has no lo device; Q5 one predicted value for /
PASS: Step 3.2: promtool check rules SUCCESS; config with rule_files valid; API lists all 4 rules (health ok) in system_health
PASS: Lab bug: HighMemoryPressure uses MemTotal/MemAvailable, which are in none of the five Step 3.1 queries
PASS: Time: finished in 171s (<= 300s)
CORE: 10/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./prom-lab8/alert_rules.yml
./prom-lab8/app.pid
./prom-lab8/instrumented_app.py
./prom-lab8/node_exporter.pid
./prom-lab8/prometheus.pid
./prom-lab8/prometheus.yml
./prom-lab8/results/app.log
./prom-lab8/results/bug-pip3-system.txt
./prom-lab8/results/bug-pip3-user.txt
./prom-lab8/results/bug-tsdb-permissions-prometheus.log
./prom-lab8/results/bug-tsdb-permissions.txt
./prom-lab8/results/elapsed.txt
./prom-lab8/results/node_exporter.log
./prom-lab8/results/prometheus.log
./prom-lab8/results/step1.1-download.txt
./prom-lab8/results/step1.1-install.txt
./prom-lab8/results/step1.1-promtool.txt
./prom-lab8/results/step1.2-verify.txt
./prom-lab8/results/step1.3-python.txt
./prom-lab8/results/step2.1-app.txt
./prom-lab8/results/step2.2-histogram.txt
./prom-lab8/results/step2.2-promtool.txt
./prom-lab8/results/step2.2-query-(le)).json
./prom-lab8/results/step2.2-query-(le,.json
./prom-lab8/results/step2.2-query-A.json
./prom-lab8/results/step2.2-query-B.json
./prom-lab8/results/step2.2-query-C.json
./prom-lab8/results/step2.2-query-by.json
./prom-lab8/results/step2.2-query-endpoint)).json
./prom-lab8/results/step2.2-query-sum(rate(http_request_duration_seconds_bucket[5m])).json
./prom-lab8/results/step2.2-reload.txt
./prom-lab8/results/step3.1-query1.json
./prom-lab8/results/step3.1-query2.json
./prom-lab8/results/step3.1-query3.json
./prom-lab8/results/step3.1-query4.json
./prom-lab8/results/step3.1-query5.json
./prom-lab8/results/step3.1-results.txt
./prom-lab8/results/step3.2-constraint.txt
./prom-lab8/results/step3.2-promtool-config.txt
./prom-lab8/results/step3.2-promtool-rules.txt
./prom-lab8/results/step3.2-rule-health.txt
./prom-lab8/results/step3.2-rule-names.txt
./prom-lab8/results/step3.2-rules.json
./prom-lab8/results/step3.2-thresholds-vs-observed.txt
./prom-lab8/step3.1-queries.promql
```
