# Lab 13 - Compare OTLP-gRPC vs OTLP-HTTP - completion proof
Completed (UTC): 2026-11-07 00:59:33 | EC2: i-03ad4041e3d376a45 | host: ip-172-31-10-34 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 13 - Compare OTLP-gRPC vs OTLP-HTTP, 2026-11-07 00:59:29 UTC) ==========
PASS: Task 1: collector config validates; gRPC :4317 + HTTP :4318 receivers listening
PASS: Task 2: gRPC app exported 10 spans + counter metrics (sample-app-grpc)
PASS: Task 2.3: collector shows transport.protocol=grpc resource
PASS: Task 3: app_http.py uses proto.http exporters on :4318/v1/traces + /v1/metrics
PASS: Task 3.3: after clearing, file holds ONLY HTTP data (10 spans + metrics)
PASS: Task 3.3: collector shows transport.protocol=http resource
PASS: Task 4.2: simultaneous run delivered BOTH services (10 spans each) in one file
PASS: Task 4.2: no 'Overriding' of providers affected export (each app uses its own provider)
PASS: Task 4.1/4.3: comparison printed; analysis reports both transports working
CORE: 9/9 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                                         ID             DISK USAGE   CONTENT SIZE   EXTRA
otel/opentelemetry-collector-contrib:latest   340c9ca6a366        537MB          116MB        
```

## Files
```
./otlp-transport-lab/otel-collector-config.yaml
./otlp-transport-lab/python-app/analyze_results.sh
./otlp-transport-lab/python-app/app_grpc.py
./otlp-transport-lab/python-app/app_http.py
./otlp-transport-lab/python-app/compare_transports.py
./otlp-transport-lab/python-app/requirements.txt
./otlp-transport-lab/python-app/test_both_transports.py
./otlp-transport-lab/results/analysis.txt
./otlp-transport-lab/results/census-both.txt
./otlp-transport-lab/results/census-grpc.txt
./otlp-transport-lab/results/census-http.txt
./otlp-transport-lab/results/collector.log
./otlp-transport-lab/results/comparison.txt
./otlp-transport-lab/results/pkgs.txt
./otlp-transport-lab/results/ports.txt
./otlp-transport-lab/results/run-both.txt
./otlp-transport-lab/results/run-grpc.txt
./otlp-transport-lab/results/run-http.txt
./otlp-transport-lab/results/telemetry-data.json
./otlp-transport-lab/results/validate.txt
```
