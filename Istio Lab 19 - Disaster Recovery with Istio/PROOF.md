# Istio Lab 19 - Disaster Recovery with Istio - completion proof
Completed (UTC): 2026-11-11 20:28:23 | EC2: i-0800761c5c39ecd2e | host: ip-172-31-10-195 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Istio Lab 19 - Disaster Recovery with Istio, 2026-11-11 20:28:15 UTC) - CLUSTER/ISTIOD SIMULATED, PODS + GATEWAY ENVOY REAL ==========
PASS: Setup: images + istioctl 1.32.0; fixed manifests (v1 VS/DR, projected-volume Deployment) schema-valid
FAIL: Task 1.5: VS v1 -> 20/20 'Version 1.0' with HTTP 200
FAIL: Lab bug: v2 'failure' is client-side JS - HTTP 200 30/30, curl -f 10/10, '500' only inside <script>
PASS: Lab bug: lab circuit breaker (consecutiveErrors) never ejects v2 (no 5xx ever seen)
PASS: Fixed v2: real server-side 500s (~70% of 100, 3 sigma) visible to curl and Envoy
PASS: Fixed circuit breaker (consecutive5xxErrors) ejects failing v2 pods
FAIL: Task 3.1: rollback restores 20/20 v1 (HTTP 200)
PASS: Task 3.4: canary 90/10 - v2 share 13/200 within 3 sigma of 20
FAIL: Task 3.5: test-version: v2 -> ~50% 503 (46/100, 3 sigma); no header -> v1 only
PASS: Task 4.2 fixed: /health/health.html served (projected volume); nested-mount outcome recorded
PASS: Lab bug: lab DR script calls a DEAD service 'healthy' and rolls back a HEALTHY one
FAIL: Fixed DR script: detects real v2 failure, rolls back, verifies >= 90% (exit 0); final state 10/10 v1
PASS: Time: finished in 73s (<= 300s)
CORE: 8/13 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                  ID             DISK USAGE   CONTENT SIZE   EXTRA
istio/proxyv2:1.32.0   b8d47c6d8d6e        400MB         92.2MB        
nginx:1.27-alpine      65645c7bb6a0       74.5MB         21.9MB        
```

## Files
```
./istio-lab19/envoy/apply-vs.sh
./istio-lab19/envoy/current-dr
./istio-lab19/envoy/current-vs
./istio-lab19/envoy/gateway.yaml
./istio-lab19/envoy/gen.py
./istio-lab19/html/health/health.html
./istio-lab19/html/v1-projected/health/health.html
./istio-lab19/html/v1-projected/index.html
./istio-lab19/html/v1/index.html
./istio-lab19/html/v2/index.html
./istio-lab19/k8s/bookstore-v1-projected.yaml
./istio-lab19/k8s/dr-circuit-breaker.yaml
./istio-lab19/k8s/dr-plain.yaml
./istio-lab19/k8s/gateway.yaml
./istio-lab19/k8s/nginx-v2-failing.conf
./istio-lab19/k8s/vs-canary.yaml
./istio-lab19/k8s/vs-fault.yaml
./istio-lab19/k8s/vs-v1.yaml
./istio-lab19/k8s/vs-v2.yaml
./istio-lab19/lab-original/disaster-recovery.sh
./istio-lab19/lab-original/dr-circuit-breaker.yaml
./istio-lab19/lab-original/dr-plain.yaml
./istio-lab19/lab-original/vs-canary.yaml
./istio-lab19/lab-original/vs-fault.yaml
./istio-lab19/lab-original/vs-v1.yaml
./istio-lab19/lab-original/vs-v2.yaml
./istio-lab19/results/SIMULATED.md
./istio-lab19/results/analyze-fixed.txt
./istio-lab19/results/analyze-lab.txt
./istio-lab19/results/bug-drscript-dead-service.txt
./istio-lab19/results/bug-drscript-healthy-v1.txt
./istio-lab19/results/elapsed.txt
./istio-lab19/results/image-pull.txt
./istio-lab19/results/kubeconform-fixed.txt
./istio-lab19/results/task1-pods.txt
./istio-lab19/results/task1.5-initial.txt
./istio-lab19/results/task2-fixed-disaster.txt
./istio-lab19/results/task2-lab-disaster.txt
./istio-lab19/results/task3.1-rollback.txt
./istio-lab19/results/task3.4-canary.txt
./istio-lab19/results/task3.5-fault.txt
./istio-lab19/results/task4.1-nested-mount.txt
./istio-lab19/results/task4.2-health.txt
./istio-lab19/results/task4.4-drscript.txt
./istio-lab19/results/task4.4-fixed-drscript.txt
./istio-lab19/results/task4.5-final.txt
./istio-lab19/results/tools.txt
./istio-lab19/scripts/disaster-recovery.sh
```
