# Lab 15 - Resource Detection & Attributes - completion proof
Completed (UTC): 2026-11-07 01:15:02 | EC2: i-058d5c42ec7d37697 | host: ip-172-31-10-110 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 15 - Resource Detection & Attributes, 2026-11-07 01:14:49 UTC) ==========
PASS: Task 1.1: lab's 'wget -fsSL' fails (curl-only flags) - curl used instead
PASS: Task 1.1: otelcol-contrib 0.100.0, Jaeger 1.57.0, Prometheus 2.52.0 installed
PASS: Task 1.2: Jaeger query API + Prometheus ready
FAIL: Task 2.1: lab's detector list [env,system,host,process] rejected; fixed config validates
PASS: Task 2.1: both pipelines use [resourcedetection, resource, attributes, batch]; override: false
PASS: Task 2.1: collector health_check :13133 OK
PASS: Task 2.2: TelemetryGenerator implements the interface and ran >= 90s without export errors
FAIL: Task 2.2: KeyboardInterrupt path flushed providers cleanly
PASS: Task 3.1: validate-jaeger.sh - all 6 resource attributes present
PASS: Task 3.1: process metadata present (SDK process detector -> process.pid)
PASS: Task 3.1: attributes processor put deployment.environment/team.owner/region on spans
PASS: Task 3.2: validate-prometheus.sh - all 4 labels present
PASS: Task 3.2: resource attrs promoted to labels (host_name, lab_id, cluster_name)
CORE: 11/13 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./otel-lab15/app.py
./otel-lab15/configs/lab-spec-detectors.yaml
./otel-lab15/configs/otel-collector-lab15.yaml
./otel-lab15/configs/prometheus.yml
./otel-lab15/data/prometheus/queries.active
./otel-lab15/data/prometheus/wal/00000000
./otel-lab15/logs/app.log
./otel-lab15/logs/collector.log
./otel-lab15/logs/jaeger.log
./otel-lab15/logs/prometheus.log
./otel-lab15/prometheus-2.52.0.linux-amd64/LICENSE
./otel-lab15/prometheus-2.52.0.linux-amd64/NOTICE
./otel-lab15/prometheus-2.52.0.linux-amd64/console_libraries/menu.lib
./otel-lab15/prometheus-2.52.0.linux-amd64/console_libraries/prom.lib
./otel-lab15/prometheus-2.52.0.linux-amd64/consoles/index.html.example
./otel-lab15/prometheus-2.52.0.linux-amd64/consoles/node-cpu.html
./otel-lab15/prometheus-2.52.0.linux-amd64/consoles/node-disk.html
./otel-lab15/prometheus-2.52.0.linux-amd64/consoles/node-overview.html
./otel-lab15/prometheus-2.52.0.linux-amd64/consoles/node.html
./otel-lab15/prometheus-2.52.0.linux-amd64/consoles/prometheus-overview.html
./otel-lab15/prometheus-2.52.0.linux-amd64/consoles/prometheus.html
./otel-lab15/prometheus-2.52.0.linux-amd64/prometheus.yml
./otel-lab15/results/app.log
./otel-lab15/results/collector.log
./otel-lab15/results/jaeger-span-tags.txt
./otel-lab15/results/jaeger-traces.json
./otel-lab15/results/jaeger.log
./otel-lab15/results/pkgs.txt
./otel-lab15/results/prometheus.log
./otel-lab15/results/validate-jaeger.txt
./otel-lab15/results/validate-lab-detectors.txt
./otel-lab15/results/validate-prometheus.txt
./otel-lab15/results/validate.txt
./otel-lab15/results/versions.txt
./otel-lab15/results/wget-lab-command.txt
./otel-lab15/validate-jaeger.sh
./otel-lab15/validate-prometheus.sh
```
