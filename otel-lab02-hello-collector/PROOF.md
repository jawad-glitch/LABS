# otel-lab02-hello-collector - completion proof
Completed (UTC): 2026-11-06 23:41:03 | EC2: i-0f240755ce4c10c48 | host: ip-172-31-10-233 | user: ubuntu

## Core checks
```
========== CORE CHECKS (otel-lab02-hello-collector, 2026-11-06 23:41:00 UTC) ==========
PASS: Task 1: config has OTLP gRPC :4317 + HTTP :4318, debug exporter, traces/metrics/logs pipelines
PASS: Task 1: 'otelcol validate' accepts the config
PASS: Task 1: lab's original 'logging' exporter is rejected by current collector
PASS: Task 2: collector started ('Everything is ready')
PASS: Task 3: ports 4317 and 4318 listening
PASS: Task 3: GET /v1/traces returns 405 (endpoint alive, POST-only)
PASS: Task 4: trace accepted (200) and printed by debug exporter (test-span, service test-service)
PASS: Task 4: metric accepted (200) and printed (lab2.test.counter)
PASS: Task 4: log accepted (200) and printed ('hello from lab 2')
PASS: Task 5: collector container removed after stop (--rm)
CORE: 10/10 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                                 ID             DISK USAGE   CONTENT SIZE   EXTRA
otel/opentelemetry-collector:latest   28b6d41ac51b        232MB         48.3MB        
```

## Files
```
./otel-lab2/collector-logs.txt
./otel-lab2/original-logging-config.yaml
./otel-lab2/otel-config.yaml
./otel-lab2/otel02-ports.txt
./otel-lab2/otel02-trace-resp.txt
./otel-lab2/otel02-validate-logging.txt
./otel-lab2/otel02-validate.txt
```
