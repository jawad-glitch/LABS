# Lab 4 - Manual Tracing (OTLP → Collector) - completion proof
Completed (UTC): 2026-11-06 23:54:18 | EC2: i-0f0914efc7e39f24d | host: ip-172-31-10-146 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 4 - Manual Tracing (OTLP → Collector), 2026-11-06 23:54:14 UTC) ==========
PASS: Task 1: opentelemetry-sdk, -exporter-otlp, -instrumentation-flask + flask installed
PASS: Task 2: app.py has TracerProvider + OTLP gRPC exporter + BatchSpanProcessor
PASS: Task 3: collector binary installed and config validates
PASS: Task 4: collector started ('Everything is ready')
FAIL: Task 5: / and 8x /work returned success
PASS: Task 6: all 4 span names received by collector
PASS: Task 6: resource service.name=manual-tracing-app, service.version=1.0.0
PASS: Task 6: custom attributes + events exported (http.route, data.size, events)
PASS: Task 3/6: attributes processor inserted environment=lab
PASS: Task 6.3: parent-child hierarchy correct (children's Parent ID = work_operation ID)
PASS: Task 8: app and collector stopped
CORE: 10/11 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./collector-config/collector.log
./collector-config/otel-collector-config.yaml
./otlp-manual-tracing/app.log
./otlp-manual-tracing/app.py
./otlp-manual-tracing/collector.log
./otlp-manual-tracing/otel04-hierarchy.txt
./otlp-manual-tracing/otel04-home.json
./otlp-manual-tracing/otel04-pkgs.txt
./otlp-manual-tracing/otel04-validate.txt
./otlp-manual-tracing/otel04-work.txt
```
