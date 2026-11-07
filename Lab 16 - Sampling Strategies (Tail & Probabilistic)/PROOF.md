# Lab 16 - Sampling Strategies (Tail & Probabilistic) - completion proof
Completed (UTC): 2026-11-07 01:22:18 | EC2: i-00e329379f237ddbf | host: ip-172-31-10-38 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 16 - Sampling Strategies (Tail & Probabilistic), 2026-11-07 01:22:12 UTC) ==========
PASS: Task 1.1: lab's 'wget -fsSL' fails; otelcol-contrib installed (has tail_sampling + file exporter)
PASS: Task 1.2: python3, flask and the OTel SDK import in the venv
PASS: Task 2: app uses ParentBased(TraceIdRatioBased(0.20)); 4 routes each with >= 2 custom attributes
PASS: Task 2: load generator sent 200 requests across >= 2 routes with running status counts
PASS: Task 2 accept: < 60 traces exported for 200 requests (>= 70% reduction)
PASS: Task 3: collector config validates with keep_errors, keep_slow, keep_critical_attribute, default_sample (8%)
PASS: Task 3: collector health_check OK; 200 more requests sent
PASS: Task 3: every SDK-sampled trace reached the collector (received == SDK count)
PASS: Task 2/3 accept: custom attributes present and non-empty in the output file
PASS: Task 3 accept: 100% of ERROR traces kept (keep_errors)
PASS: Task 3 accept: 100% of >1500ms traces kept (keep_slow)
PASS: Task 3: 100% of priority=high traces kept (keep_critical_attribute)
PASS: Task 3 accept: overall retention < 35% of requests sent (>= 65% reduction)
CORE: 13/13 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./otel-sampling-lab/analyze_sampling.py
./otel-sampling-lab/app.py
./otel-sampling-lab/configs/otel-collector-sampling.yaml
./otel-sampling-lab/loadgen.py
./otel-sampling-lab/logs/app-run1.log
./otel-sampling-lab/logs/app-run2.log
./otel-sampling-lab/logs/collector.log
./otel-sampling-lab/output/received-traces.json
./otel-sampling-lab/output/sampled-traces.json
./otel-sampling-lab/results/analysis.txt
./otel-sampling-lab/results/app-run1.log
./otel-sampling-lab/results/app-run2.log
./otel-sampling-lab/results/collector.log
./otel-sampling-lab/results/loadgen-run1.txt
./otel-sampling-lab/results/loadgen-run2.txt
./otel-sampling-lab/results/otel-collector-sampling.yaml
./otel-sampling-lab/results/pip.txt
./otel-sampling-lab/results/validate.txt
./otel-sampling-lab/results/verify.txt
./otel-sampling-lab/results/wget-lab-command.txt
```
