# Lab 12 - Grafana Dashboards for OpenTelemetry - completion proof
Completed (UTC): 2026-11-07 00:49:01 | EC2: i-0c2ddcc739dc71802 | host: ip-172-31-10-9 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 12 - Grafana Dashboards for OpenTelemetry, 2026-11-07 00:48:57 UTC) ==========
PASS: Task 1: Grafana container running; /api/health database ok
PASS: Task 1.3: first-login admin password changed (old rejected, new accepted)
PASS: Task 2: lab URL http://localhost:9090 fails from the Grafana container (evidence)
PASS: Task 2.2: Prometheus data source 'Save & Test' OK (via host.docker.internal)
PASS: Task 2.3: Prometheus has OTel http_requests_total (method/status_code/service_name) + duration histogram
PASS: Task 6: dashboard saved (title, 3 tags, refresh 5s, last 15m, 6 panels, $service variable)
PASS: Task 3.2: request-rate panel returns series per method + status_code
PASS: Task 3.3: rate by status_code shows 200 and 500
PASS: Task 4.1: latency percentiles P50 <= P95 <= P99, all < 1s (second-scale buckets)
PASS: Task 4.3: average latency between 0.01s and 0.5s
PASS: Task 5: error rate % > 0 and total request volume > 0
PASS: Task 8.1: $service variable (label_values) resolves to demo-http-api
CORE: 12/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE                                         COMMAND                  CREATED              STATUS              PORTS                                                                                                           NAMES
163d0d2af35d   grafana/grafana:latest                        "/run.sh"                About a minute ago   Up About a minute   0.0.0.0:3000->3000/tcp, [::]:3000->3000/tcp                                                                     grafana
7756f811c70e   prom/prometheus:latest                        "/bin/prometheus --c…"   About a minute ago   Up About a minute                                                                                                                   prometheus
7804dc859b72   otel/opentelemetry-collector-contrib:latest   "/otelcol-contrib --…"   About a minute ago   Up About a minute   0.0.0.0:4318->4318/tcp, [::]:4318->4318/tcp, 4317/tcp, 55679/tcp, 0.0.0.0:9464->9464/tcp, [::]:9464->9464/tcp   otelcol

IMAGE                                         ID             DISK USAGE   CONTENT SIZE   EXTRA
grafana/grafana:latest                        488984b716c0       2.01GB          503MB   U    
otel/opentelemetry-collector-contrib:latest   340c9ca6a366        537MB          116MB   U    
prom/prometheus:latest                        e04987641b57        389MB          116MB   U    
```

## Files
```
./otel-grafana-lab/demo_app.py
./otel-grafana-lab/otelcol-config.yaml
./otel-grafana-lab/prometheus.yml
./otel-grafana-lab/results/app.log
./otel-grafana-lab/results/collector.log
./otel-grafana-lab/results/dashboard-request.json
./otel-grafana-lab/results/dashboard-save.json
./otel-grafana-lab/results/dashboard-saved.json
./otel-grafana-lab/results/ds-health-localhost.json
./otel-grafana-lab/results/ds-health.json
./otel-grafana-lab/results/grafana-health.json
./otel-grafana-lab/results/grafana.log
./otel-grafana-lab/results/http-metric-names.txt
./otel-grafana-lab/results/panel-results.txt
./otel-grafana-lab/results/series.txt
```
