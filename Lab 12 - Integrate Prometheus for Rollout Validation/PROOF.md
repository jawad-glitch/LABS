# Lab 12 - Integrate Prometheus for Rollout Validation - completion proof
Completed (UTC): 2026-11-09 12:51:28 | EC2: i-09247d3f903842f30 | host: ip-172-31-10-62 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 12 - Integrate Prometheus for Rollout Validation, 2026-11-09 12:51:23 UTC) - FAST MODE ==========
PASS: Lab bug: prometheus-instance.yaml has duplicate apiVersion key (rejected); all fixed manifests parse strictly
FAIL: Lab bug: operator bundle v0.95.1 largest CRD 0 bytes > 262144 -> server-side apply required; bundle schema-valid
PASS: Lab bug: nginx:1.20 has no nc and sh echo -e prints -e -> the lab metrics server cannot serve /metrics
PASS: Fixed manifests valid (strict): Prometheus CR (+serviceMonitorNamespaceSelector), RBAC, ServiceMonitor, app, AnalysisTemplates (+count), Rollouts
PASS: Task 2.2/2.3 [SIMULATED discovery]: Prometheus v3.16.0 scrapes all 5 app pods (up=5), http_requests_total + response_time_seconds collected
PASS: Task 3.3: lab success-rate query on healthy canary -> 3 measurements >= 0.95 -> Successful
PASS: Task 3.3: lab p95 response-time query -> <= 0.5s on all measurements -> Successful; AnalysisRun Successful
PASS: Task 3.6: strict template on faulty canary (20% 5xx) -> values < 0.99, failures > failureLimit 2 -> AnalysisRun Failed (rollout aborts)
PASS: Time: fast-mode run finished in 74s (<= 300s)
CORE: 8/9 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                     ID             DISK USAGE   CONTENT SIZE   EXTRA
nginx:1.20                38f8c1d9613f        213MB         56.7MB        
prom/prometheus:v3.16.0   e04987641b57        389MB          116MB        
python:3.12-alpine        e064671ca452       74.8MB         18.7MB        
python:3.13-alpine        1e1f6334529d       70.5MB         17.6MB        
```

## Files
```
./prom-rollouts-lab12/analysis-template.yaml
./prom-rollouts-lab12/analyze.py
./prom-rollouts-lab12/app/app.py
./prom-rollouts-lab12/check-metrics.sh
./prom-rollouts-lab12/failing-analysis-template.yaml
./prom-rollouts-lab12/lab-original-prometheus-instance.yaml
./prom-rollouts-lab12/prom/a.yml
./prom-rollouts-lab12/prom/b.yml
./prom-rollouts-lab12/prometheus-instance.yaml
./prom-rollouts-lab12/prometheus-operator-bundle.yaml
./prom-rollouts-lab12/results/SIMULATED.md
./prom-rollouts-lab12/results/bug1-duplicate-apiversion.txt
./prom-rollouts-lab12/results/bug1-fixed-parse.txt
./prom-rollouts-lab12/results/bug2-bundle-crd-sizes.txt
./prom-rollouts-lab12/results/bug2-bundle-kubeconform.txt
./prom-rollouts-lab12/results/bug3-nginx120-metrics-server.txt
./prom-rollouts-lab12/results/elapsed.txt
./prom-rollouts-lab12/results/image-pull.log
./prom-rollouts-lab12/results/install-kubeconform.log
./prom-rollouts-lab12/results/task-kubeconform.txt
./prom-rollouts-lab12/results/task2.3-targets-up-A.json
./prom-rollouts-lab12/results/task3-requests-by-status-A.json
./prom-rollouts-lab12/results/task3-requests-by-status-B.json
./prom-rollouts-lab12/results/task3.3-analysisrun-A-success-rate.txt
./prom-rollouts-lab12/results/task3.5-check-metrics-A.txt
./prom-rollouts-lab12/results/task3.6-analysisrun-B-strict.txt
./prom-rollouts-lab12/results/versions.txt
./prom-rollouts-lab12/rollout-strict-analysis.yaml
./prom-rollouts-lab12/rollout-with-analysis.yaml
./prom-rollouts-lab12/sample-app.yaml
./prom-rollouts-lab12/strictyaml.py
```
