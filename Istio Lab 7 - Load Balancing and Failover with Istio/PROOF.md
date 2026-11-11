# Istio Lab 7 - Load Balancing and Failover with Istio - completion proof
Completed (UTC): 2026-11-11 14:45:57 | EC2: i-04b3d3f6a8569d26f | host: ip-172-31-10-228 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Istio Lab 7 - Load Balancing and Failover with Istio, 2026-11-11 14:45:49 UTC) - CLUSTER/ISTIOD SIMULATED, PODS + ENVOY REAL (run 1 + resume) ==========
PASS: Setup: details image (docker.io/istio/examples-bookinfo-details-v1:1.17.0), proxyv2 1.32.0; fixed DR/VS schema-valid
PASS: Task 1: 3 details pods serve /details/1; /health answers (probe path valid)
PASS: Lab bug: details response has no hostname field - lab RR test prints 'Request failed' 9/9
PASS: Task 1.2: ROUND_ROBIN spreads requests evenly (each endpoint within +-3 of mean: 33 32 34)
PASS: Task 1.4: LEAST_REQUEST (+ circuit breaker) serves all 90 concurrent requests across all 3 endpoints
FAIL: Task 2a crash, Istio defaults: no ejection - dead endpoint keeps costing a ~1s connect timeout (slow >= 6/30)
FAIL: Task 2a crash, lab DR: consecutiveErrors (gateway failures) ejects the crashed pod (slow <= 3)
FAIL: Task 2a crash, fixed DR + retries: 0 errors, ejected (slow <= 3)
PASS: Lab bug: lab DR never ejects a pod answering HTTP 500 (consecutiveErrors = gateway errors only) -> users get 500s
PASS: Fixed DR (consecutive5xxErrors) + VS retries on 5xx: 0 errors, bad pod ejected
PASS: Lab bug: lab metrics grep matches 0 Envoy stats; analyze-results.sh then divides by zero
PASS: Task 3.5 fixed analysis from Envoy per-endpoint counts: balanced across 3 endpoints
PASS: Corrections to disproved claims recorded (consecutiveErrors, Prometheus flags, RR exactness)
PASS: Time: first run 59s, resume 19s (both <= 300s)
CORE: 11/14 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                                       ID             DISK USAGE   CONTENT SIZE   EXTRA
istio/examples-bookinfo-details-v1:1.17.0   2b081e3c86dd        232MB         62.5MB        
istio/proxyv2:1.32.0                        b8d47c6d8d6e        400MB         92.2MB        
nginx:1.27-alpine                           65645c7bb6a0       74.5MB         21.9MB        
prom/prometheus:latest                      e04987641b57        389MB          116MB        
```

## Files
```
./istio-lab7/envoy/bad-pod-nginx.conf
./istio-lab7/envoy/dr2envoy.py
./istio-lab7/envoy/sidecar-bad-fixed.yaml
./istio-lab7/envoy/sidecar-bad-lab.yaml
./istio-lab7/envoy/sidecar-crash-default.yaml
./istio-lab7/envoy/sidecar-crash-fixed.yaml
./istio-lab7/envoy/sidecar-crash-lab.yaml
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
./istio-lab7/results/corrections.txt
./istio-lab7/results/elapsed-resume.txt
./istio-lab7/results/elapsed.txt
./istio-lab7/results/image-details.txt
./istio-lab7/results/image-pull.txt
./istio-lab7/results/kubeconform-fixed.txt
./istio-lab7/results/task1-pods.txt
./istio-lab7/results/task1.2-roundrobin.txt
./istio-lab7/results/task1.4-leastrequest.txt
./istio-lab7/results/task2-bad-fixed.txt
./istio-lab7/results/task2-bad-lab.txt
./istio-lab7/results/task2-crash-default.txt
./istio-lab7/results/task2-crash-fixed.txt
./istio-lab7/results/task2-crash-lab.txt
./istio-lab7/results/task2-failover.txt
./istio-lab7/results/task2-pods.txt
./istio-lab7/results/task3.5-analysis.txt
./istio-lab7/results/tools.txt
./istio-lab7/scripts/analyze-results-lab.sh
./istio-lab7/scripts/analyze-results.sh
```
