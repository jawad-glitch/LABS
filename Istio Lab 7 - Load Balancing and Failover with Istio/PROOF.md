# Istio Lab 7 - Load Balancing and Failover with Istio - completion proof
Completed (UTC): 2026-11-11 14:43:31 | EC2: i-04b3d3f6a8569d26f | host: ip-172-31-10-228 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Istio Lab 7 - Load Balancing and Failover with Istio, 2026-11-11 14:43:23 UTC) - CLUSTER/ISTIOD SIMULATED, PODS + ENVOY REAL ==========
PASS: Setup: details image (docker.io/istio/examples-bookinfo-details-v1:1.17.0), proxyv2 1.32.0; fixed DR/VS schema-valid
PASS: Task 1: 3 details pods serve /details/1; /health answers (probe path valid)
PASS: Lab bug: details response has no hostname field - lab RR test prints 'Request failed' 9/9
FAIL: Task 1.2: ROUND_ROBIN spreads 90 requests 30/30/30 across the 3 endpoints (33 32 34)
PASS: Task 1.4: LEAST_REQUEST (+ circuit breaker) serves all 90 concurrent requests across all 3 endpoints
FAIL: Lab bug: outlierDetection.consecutiveErrors fails the v1 schema (field removed)
FAIL: Task 2 (lab DR): crashed pod keeps costing ~1s on every 3rd request (no working outlier detection)
FAIL: Task 2 (fixed DR + retries): 0 errors, crashed pod ejected after 3 failures (slow <= 3/30)
PASS: Lab bug: lab metrics grep matches 0 Envoy stats; analyze-results.sh then divides by zero
FAIL: Lab bug: prom/prometheus:latest rejects the lab --web.console.* flags and exits
PASS: Task 3.5 fixed analysis from Envoy per-endpoint counts: balanced across 3 endpoints
PASS: Time: finished in 59s (<= 300s)
CORE: 7/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                                       ID             DISK USAGE   CONTENT SIZE   EXTRA
istio/examples-bookinfo-details-v1:1.17.0   2b081e3c86dd        232MB         62.5MB        
istio/proxyv2:1.32.0                        b8d47c6d8d6e        400MB         92.2MB        
prom/prometheus:latest                      e04987641b57        389MB          116MB        
```

## Files
```
./istio-lab7/envoy/dr2envoy.py
./istio-lab7/envoy/sidecar-dr-failover+retries.yaml
./istio-lab7/envoy/sidecar-dr-failover.yaml
./istio-lab7/envoy/sidecar-dr-leastrequest.yaml
./istio-lab7/envoy/sidecar-dr-roundrobin.yaml
./istio-lab7/envoy/sidecar.yaml
./istio-lab7/k8s/dr-failover.yaml
./istio-lab7/k8s/dr-leastrequest.yaml
./istio-lab7/k8s/dr-roundrobin.yaml
./istio-lab7/k8s/prometheus-scrape-sidecars.yaml
./istio-lab7/k8s/vs-details.yaml
./istio-lab7/lab-original/dr-failover.yaml
./istio-lab7/lab-original/dr-leastconn.yaml
./istio-lab7/lab-original/dr-roundrobin.yaml
./istio-lab7/results/SIMULATED.md
./istio-lab7/results/bug-analyze-zero.txt
./istio-lab7/results/bug-consecutiveErrors.txt
./istio-lab7/results/bug-hostname-test.txt
./istio-lab7/results/bug-metrics-grep.txt
./istio-lab7/results/bug-prometheus-flags.txt
./istio-lab7/results/elapsed.txt
./istio-lab7/results/image-details.txt
./istio-lab7/results/image-pull.txt
./istio-lab7/results/kubeconform-fixed.txt
./istio-lab7/results/task1-pods.txt
./istio-lab7/results/task1.2-roundrobin.txt
./istio-lab7/results/task1.4-leastrequest.txt
./istio-lab7/results/task2-failover.txt
./istio-lab7/results/task3.5-analysis.txt
./istio-lab7/results/tools.txt
./istio-lab7/scripts/analyze-results-lab.sh
./istio-lab7/scripts/analyze-results.sh
```
