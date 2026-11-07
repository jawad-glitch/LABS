# Lab 9 - Collector Pipelines & Processors - completion proof
Completed (UTC): 2026-11-07 00:27:45 | EC2: i-0a5fdb7b9c4427254 | host: ip-172-31-10-192 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 9 - Collector Pipelines & Processors, 2026-11-07 00:27:42 UTC) ==========
PASS: Task 2: config validates in contrib collector (memory_limiter, attributes, batch; debug + file)
PASS: Task 3: collector started via docker compose ('Everything is ready', health 200)
PASS: Task 4: original 16-hex trace id rejected (HTTP 400) - fixed generator accepted
PASS: Task 4.4: traces, metrics AND logs enriched with service.environment/lab.name/lab.number
PASS: Task 5: file exporter wrote to host ./data with all 3 signals
PASS: Task 5.2: analyze-data.py - every exported document carries the added attributes
PASS: Task 6: updated config (batch 512/2s) applied - pipeline.version + processed.timestamp added
PASS: Task 7: stress test - all requests accepted, no memory_limiter refusals
PASS: Task 8.1: validate-config.py has no failures (incl. processor order)
PASS: Task 8.2: health-check.py passed
PASS: Task 9: summary written, collector stopped, archive created
CORE: 11/11 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                                         ID             DISK USAGE   CONTENT SIZE   EXTRA
otel/opentelemetry-collector-contrib:latest   340c9ca6a366        537MB          116MB        
```

## Files
```
./otel-lab9/analyze-data.py
./otel-lab9/config/otel-config.yaml
./otel-lab9/data/otel-data.json
./otel-lab9/docker-compose.yaml
./otel-lab9/generate-test-data.py
./otel-lab9/generate_test_data.py
./otel-lab9/health-check.py
./otel-lab9/lab-summary.md
./otel-lab9/logs/collector-final.log
./otel-lab9/logs/collector-run1.log
./otel-lab9/logs/collector-run2.log
./otel-lab9/logs/otel09-analysis.txt
./otel-lab9/logs/otel09-gen1.txt
./otel-lab9/logs/otel09-gen2.txt
./otel-lab9/logs/otel09-health.txt
./otel-lab9/logs/otel09-memlimit.txt
./otel-lab9/logs/otel09-orig-resp.txt
./otel-lab9/logs/otel09-pull.txt
./otel-lab9/logs/otel09-selfmetrics.txt
./otel-lab9/logs/otel09-stats.txt
./otel-lab9/logs/otel09-stress-full.txt
./otel-lab9/logs/otel09-stress.txt
./otel-lab9/logs/otel09-validate-config.txt
./otel-lab9/logs/otel09-validate.txt
./otel-lab9/stress-test.py
./otel-lab9/validate-config.py
```
