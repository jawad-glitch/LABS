# Lab 10 - Traces to Jaeger - completion proof
Completed (UTC): 2026-11-07 00:37:00 | EC2: i-0ec58c2c56056d43f | host: ip-172-31-10-57 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 10 - Traces to Jaeger, 2026-11-07 00:36:54 UTC) ==========
PASS: Task 1: standalone Jaeger served its UI on :16686
PASS: Task 2: lab's original config rejected (removed 'jaeger' exporter); fixed config validates
PASS: Task 2.5: compose stack running (jaeger + otel-collector)
PASS: Task 3: app deps installed in venv and app responded
PASS: Task 4: traffic script completed (20 requests)
FAIL: Task 4.4: Jaeger lists service 'trace-app'
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                                         ID             DISK USAGE   CONTENT SIZE   EXTRA
jaegertracing/jaeger:latest                   3823829974cc        180MB         56.7MB        
otel/opentelemetry-collector-contrib:latest   340c9ca6a366        537MB          116MB        
```

## Files
```
./otel-lab/app/generate_traces.sh
./otel-lab/app/requirements.txt
./otel-lab/app/trace_app.py
./otel-lab/config/original-lab-config.yaml
./otel-lab/config/otel-collector-config.yaml
./otel-lab/docker-compose.yaml
./otel-lab/logs/app.log
./otel-lab/logs/collector.log
./otel-lab/logs/jaeger.log
./otel-lab/logs/otel10-analysis.txt
./otel-lab/logs/otel10-gen.txt
./otel-lab/logs/otel10-home.json
./otel-lab/logs/otel10-ops.json
./otel-lab/logs/otel10-pkgs.txt
./otel-lab/logs/otel10-pull.txt
./otel-lab/logs/otel10-selfmetrics.txt
./otel-lab/logs/otel10-services.json
./otel-lab/logs/otel10-slow.json
./otel-lab/logs/otel10-traces.json
./otel-lab/logs/otel10-validate-original.txt
./otel-lab/logs/otel10-validate.txt
```
