# Lab 14 - Logs via Collector (Filelog Receiver) - completion proof
Completed (UTC): 2026-11-07 01:06:42 | EC2: i-0201f62bf0895ba8e | host: ip-172-31-10-173 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 14 - Logs via Collector (Filelog Receiver), 2026-11-07 01:06:37 UTC) ==========
PASS: Task 3: lab's original config rejected (removed logging/jaeger exporters); fixed config validates
PASS: Task 4.1: stack deployed (jaeger + otel-collector running; sample-app built and ran)
PASS: Task 2/4.3: app.log is valid JSON lines with 32-hex trace_id + 16-hex span_id
PASS: Task 2: app ran its 50 requests (INFO + WARNING + ERROR levels present)
PASS: Task 3: filelog parsed each line - message in Body, severity set, service.name=sample-app
FAIL: Task 3: log record timestamp parsed from JSON (not epoch 0)
PASS: Task 5: collector log records carry the app's trace_id (log-trace context set)
PASS: Task 5.3: collector accepted log records (self-metric > 0)
FAIL: Task 5.1: Jaeger lists service 'sample-app' (not overwritten to log-collector)
PASS: Task 5.2: the trace_id from app.log exists in Jaeger with user_request/database_query spans
PASS: Task 5.2: an ERROR log's trace is also in Jaeger
PASS: Task 6.2: analyze_logs.sh report produced
CORE: 10/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                                         ID             DISK USAGE   CONTENT SIZE   EXTRA
busybox:latest                                a46257e06c82       6.81MB         2.23MB        
jaegertracing/jaeger:latest                   3823829974cc        180MB         56.7MB        
otel-logs-lab-sample-app:latest               77fe02fa5f2d        238MB           58MB        
otel/opentelemetry-collector-contrib:latest   340c9ca6a366        537MB          116MB        
python:3.12-slim                              4840d514c583        180MB         45.5MB        
```

## Files
```
./otel-logs-lab/analyze_logs.sh
./otel-logs-lab/app/Dockerfile
./otel-logs-lab/app/app.py
./otel-logs-lab/app/requirements.txt
./otel-logs-lab/collector/original-lab-config.yaml
./otel-logs-lab/collector/otel-collector-config.yaml
./otel-logs-lab/docker-compose.yml
./otel-logs-lab/logs/app.log
./otel-logs-lab/results/analysis.txt
./otel-logs-lab/results/app.log
./otel-logs-lab/results/collector.log
./otel-logs-lab/results/jaeger-sample.txt
./otel-logs-lab/results/jaeger-services.json
./otel-logs-lab/results/jaeger-trace-error.json
./otel-logs-lab/results/jaeger-trace-sample.json
./otel-logs-lab/results/jaeger.log
./otel-logs-lab/results/sample-app-console.log
./otel-logs-lab/results/selfmetrics.txt
./otel-logs-lab/results/validate-original.txt
./otel-logs-lab/results/validate.txt
```
