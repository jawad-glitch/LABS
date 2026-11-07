# Lab 7 - Metrics (Counter & Histogram) - completion proof
Completed (UTC): 2026-11-07 00:14:24 | EC2: i-05b78ada0e63e01bd | host: ip-172-31-10-84 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 7 - Metrics (Counter & Histogram), 2026-11-07 00:14:20 UTC) ==========
FAIL: Task 1: opentelemetry-api/sdk/exporter-otlp + flask installed
PASS: Task 2: app creates a Counter + Histogram, exports via OTLP every 5s
PASS: Task 3: collector config validates; collector started
PASS: Task 4.4: metrics received from service.name=metrics-demo-app (scope demo-meter 1.0.0)
PASS: Task 5.1: http_requests_total is a monotonic Sum (Counter)
FAIL: Task 5.2: http_request_duration_seconds is a Histogram with buckets + bounds
FAIL: Verify counters: per-endpoint values exactly match requests sent (incl. status 200 + 500)
FAIL: Verify counters: values only increase across exports (cumulative)
FAIL: Verify histograms: Count per endpoint equals counter total
FAIL: Verify histograms: /slow mean latency > /fast mean latency
PASS: Task 5.3: traffic script completed; app + collector stopped
CORE: 5/11 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./otel-metrics-lab/app.log
./otel-metrics-lab/app.py
./otel-metrics-lab/collector-config.yaml
./otel-metrics-lab/collector-snapshot.log
./otel-metrics-lab/collector.log
./otel-metrics-lab/generate_traffic.sh
./otel-metrics-lab/otel07-analysis.txt
./otel-metrics-lab/otel07-error-codes.txt
./otel-metrics-lab/otel07-pkgs.txt
./otel-metrics-lab/otel07-sent.txt
./otel-metrics-lab/otel07-traffic.txt
./otel-metrics-lab/otel07-validate.txt
```
