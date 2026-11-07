# Lab 20 - End-to-End Incident Drill - completion proof
Completed (UTC): 2026-11-07 01:50:07 | EC2: i-0edbfec56266958c6 | host: ip-172-31-10-185 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 20 - End-to-End Incident Drill, 2026-11-07 01:49:53 UTC) ==========
PASS: Task 1: Node 22 (tarball) + app deps installed (express, winston, OTel SDK, OTLP + Prometheus exporters)
FAIL: Task 3: jaeger + prometheus + grafana running; Prometheus scrapes the app (up)
PASS: Task 3.2: app healthy
FAIL: Task 4.1: baseline p95 < 0.25s
PASS: Task 4.2/4.3: latency (2000ms) and error injection enabled
PASS: Task 5: Jaeger shows service incident-drill-app with slow (>=2s) AND failed /work traces
FAIL: Task 6: Prometheus p95 during incident >= 2s (spike from baseline)
FAIL: Task 6: Grafana dashboard provisioned; its P95 panel (via Grafana) shows the spike
PASS: Task 7: slow trace ID from Jaeger found in logs ('Injecting artificial latency', 2000ms)
PASS: Task 7: failed trace ID from Jaeger found in logs ('Injected error occurred')
PASS: Task 7.3: analyze_logs.sh counts latency events and errors (lowercase level fixed)
PASS: Task 8: rollback - 15 recovery requests all 200 and < 0.5s
FAIL: Task 8.3: recovery p95 back < 0.25s; Jaeger recovery traces fast with 0 errors
PASS: Task 8.4: recovery report shows app healthy
CORE: 9/14 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                           ID             DISK USAGE   CONTENT SIZE   EXTRA
grafana/grafana:10.1.0          047c1c5aa6fe        529MB          109MB        
jaegertracing/all-in-one:1.50   d589499a01e1       90.1MB         30.1MB        
prom/prometheus:v2.47.0         c5dd35038287        347MB         98.2MB        
```

## Files
```
./incident-drill-lab/analyze_logs.sh
./incident-drill-lab/app/app.js
./incident-drill-lab/app/package-lock.json
./incident-drill-lab/app/package.json
./incident-drill-lab/config/dashboard.json
./incident-drill-lab/config/grafana-dashboards.yml
./incident-drill-lab/config/grafana-datasources.yml
./incident-drill-lab/config/prometheus.yml
./incident-drill-lab/docker-compose.yml
./incident-drill-lab/generate_load.sh
./incident-drill-lab/generate_problem_traffic.sh
./incident-drill-lab/logs/app.log
./incident-drill-lab/recovery_report.sh
./incident-drill-lab/results/app-console.log
./incident-drill-lab/results/app.log
./incident-drill-lab/results/baseline.txt
./incident-drill-lab/results/correlated-error.txt
./incident-drill-lab/results/correlated-slow.txt
./incident-drill-lab/results/grafana-dashboard.json
./incident-drill-lab/results/grafana-p95.txt
./incident-drill-lab/results/grafana-search.json
./incident-drill-lab/results/health.json
./incident-drill-lab/results/inject-disable.json
./incident-drill-lab/results/inject-errors.json
./incident-drill-lab/results/inject-latency.json
./incident-drill-lab/results/jaeger-analysis.txt
./incident-drill-lab/results/jaeger-incident.json
./incident-drill-lab/results/jaeger-recovery.json
./incident-drill-lab/results/jaeger-recovery.txt
./incident-drill-lab/results/jaeger-services.json
./incident-drill-lab/results/jaeger.log
./incident-drill-lab/results/log-analysis.txt
./incident-drill-lab/results/npm-packages.txt
./incident-drill-lab/results/p95-timeline.txt
./incident-drill-lab/results/problem-traffic.txt
./incident-drill-lab/results/prom-targets.txt
./incident-drill-lab/results/recovery-report.txt
./incident-drill-lab/results/recovery.txt
./incident-drill-lab/verify_recovery.sh
```
