# Lab 11 - Metrics to Prometheus - completion proof
Completed (UTC): 2026-11-07 00:41:40 | EC2: i-018036f6665b60b8c | host: ip-172-31-10-188 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 11 - Metrics to Prometheus, 2026-11-07 00:41:35 UTC) ==========
PASS: Task 1.1: lab's original config rejected (removed 'logging' exporter / memory_limiter); fixed config validates
PASS: Task 1.2: collector container running with prometheus exporter ready
PASS: Task 1.3: :9464/metrics serves otelcol_-namespaced httpcheck metrics with environment="lab"
PASS: Task 1/3.1: httpcheck reaches the host app (status series for http_status_code=200 = 1)
PASS: Task 2: Prometheus ready; targets prometheus + otelcol + otelcol-internal all UP
PASS: Task 3.3 Q1: batch processor metric (otelcol_processor_batch_batch_send_size_sum) has data
PASS: Task 3.3 Q2: httpcheck status metric queried in Prometheus
PASS: Task 3.3 Q3: collector memory metric (otelcol_process_memory_rss) has data
PASS: Task 3.3 Q4: rate() over batch sends returns data
PASS: Task 3.4: receiver, processor and exporter metric families present
FAIL: Task 4.2: average batch size, accepted rate and export success ratio all return data
PASS: Task 3: app served /health; traffic generator ran and was stopped
CORE: 11/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                                         ID             DISK USAGE   CONTENT SIZE   EXTRA
otel/opentelemetry-collector-contrib:latest   340c9ca6a366        537MB          116MB        
prom/prometheus:latest                        e04987641b57        389MB          116MB        
```

## Files
```
./otel-prometheus-lab/generate_traffic.sh
./otel-prometheus-lab/original-lab-config.yaml
./otel-prometheus-lab/otelcol-config.yaml
./otel-prometheus-lab/prometheus.yml
./otel-prometheus-lab/results/app.log
./otel-prometheus-lab/results/collector.log
./otel-prometheus-lab/results/exporter-9464.txt
./otel-prometheus-lab/results/health.json
./otel-prometheus-lab/results/httpcheck-200.txt
./otel-prometheus-lab/results/metric-names.txt
./otel-prometheus-lab/results/prometheus.log
./otel-prometheus-lab/results/queries.txt
./otel-prometheus-lab/results/resolved-names.txt
./otel-prometheus-lab/results/targets.json
./otel-prometheus-lab/results/targets.txt
./otel-prometheus-lab/results/traffic.log
./otel-prometheus-lab/results/validate-original.txt
./otel-prometheus-lab/results/validate.txt
./otel-prometheus-lab/simple_app.py
```
