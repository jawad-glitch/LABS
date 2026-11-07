# Lab 17 - Extensions - Health Check & zPages - completion proof
Completed (UTC): 2026-11-07 01:27:58 | EC2: i-026b589b709bfee44 | host: ip-172-31-10-123 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 17 - Extensions - Health Check & zPages, 2026-11-07 01:27:55 UTC) ==========
PASS: Task 1.3: lab's '--config-file ... --dry-run' is invalid; original config rejected
PASS: Task 1: fixed config (health_check + zpages + hostmetrics + otlp) passes 'otelcol-contrib validate'
PASS: Task 2.3: GET /health -> 200 with JSON status 'Server available'
FAIL: Task 3: zPages servicez, pipelinez, extensionz, featurez, tracez all HTTP 200
PASS: Task 3.3: pipelinez shows traces/metrics/logs pipelines with hostmetrics, otlp, memory_limiter, batch, debug
PASS: Task 4.3: 5 test traces accepted (HTTP 200) and printed by the debug exporter
FAIL: Task 4.6: self-metrics on 8888 count the 5 accepted spans + hostmetrics points
PASS: Task 4: hostmetrics data flowed (system.cpu / system.memory in debug output)
PASS: Task 5: monitor script reported the collector healthy
PASS: Task 6.1: endpoint checker (fixed separator) - all 6 endpoints OK
PASS: Task 6.3: extensionz lists health_check and zpages
PASS: Task 7: collector stopped - health endpoint refuses connections
CORE: 10/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./otel-lab17/check-endpoints.sh
./otel-lab17/collector-config.yaml
./otel-lab17/collector.log
./otel-lab17/generate-traces.py
./otel-lab17/monitor-collector.sh
./otel-lab17/original-lab-config.yaml
./otel-lab17/results/collector.log
./otel-lab17/results/endpoints.txt
./otel-lab17/results/extensions-loaded.txt
./otel-lab17/results/generate-traces.txt
./otel-lab17/results/health.json
./otel-lab17/results/health.txt
./otel-lab17/results/lab-dryrun-command.txt
./otel-lab17/results/monitor.txt
./otel-lab17/results/pipelinez-components.txt
./otel-lab17/results/selfmetrics-key.txt
./otel-lab17/results/selfmetrics.txt
./otel-lab17/results/validate-original.txt
./otel-lab17/results/validate.txt
./otel-lab17/results/version.txt
./otel-lab17/results/zpages-extensionz.html
./otel-lab17/results/zpages-featurez.html
./otel-lab17/results/zpages-links.txt
./otel-lab17/results/zpages-pipelinez.html
./otel-lab17/results/zpages-root.html
./otel-lab17/results/zpages-servicez.html
./otel-lab17/results/zpages-status.txt
./otel-lab17/results/zpages-tracez.html
```
