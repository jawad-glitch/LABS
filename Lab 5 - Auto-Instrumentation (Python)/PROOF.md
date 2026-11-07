# Lab 5 - Auto-Instrumentation (Python) - completion proof
Completed (UTC): 2026-11-07 00:01:26 | EC2: i-00d8e1e986a236a3b | host: ip-172-31-10-42 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 5 - Auto-Instrumentation (Python), 2026-11-07 00:01:22 UTC) ==========
PASS: Task 1: opentelemetry-distro + instrumentation-requests + OTLP exporter installed
PASS: Task 3.4: bootstrap detected Flask -> opentelemetry-instrumentation-flask installed
PASS: Task 3: app.py has no OpenTelemetry imports (zero-code instrumentation)
PASS: Task 4: collector config validates and collector started
PASS: Task 5/6: app served /, /api/data, /health via opentelemetry-instrument gunicorn
PASS: Task 6.2: traffic script completed
PASS: Task 7: spans received with service.name=python-auto-instrumentation-lab
PASS: Task 5.1: resource attributes service.version=1.0.0 + environment=lab exported
PASS: Task 7: Flask SERVER spans for /api/data and /health
PASS: Task 7: requests CLIENT span for the external call (httpbin.org)
PASS: Task 7.3: HTTP attributes captured (method / url-or-route / status)
PASS: Task 7: HTTP server metrics also received
PASS: Task 8/9: comparison written; gunicorn + collector stopped; archive created
CORE: 13/13 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./otel-auto-lab/app.log
./otel-auto-lab/app.py
./otel-auto-lab/collector.log
./otel-auto-lab/generate_traffic.sh
./otel-auto-lab/instrumentation_comparison.md
./otel-auto-lab/otel-collector-config.yaml
./otel-auto-lab/otel05-bootstrap-1.txt
./otel-auto-lab/otel05-bootstrap-2.txt
./otel-auto-lab/otel05-data.json
./otel-auto-lab/otel05-external.json
./otel-auto-lab/otel05-health.json
./otel-auto-lab/otel05-home.json
./otel-auto-lab/otel05-pkgs-1.txt
./otel-auto-lab/otel05-pkgs-2.txt
./otel-auto-lab/otel05-traffic.txt
./otel-auto-lab/otel05-validate.txt
```
