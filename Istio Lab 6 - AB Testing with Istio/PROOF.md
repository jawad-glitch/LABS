# Istio Lab 6 - AB Testing with Istio - completion proof
Completed (UTC): 2026-11-11 14:39:01 | EC2: i-013f1ee27f6a0b84b | host: ip-172-31-10-175 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Istio Lab 6 - AB Testing with Istio, 2026-11-11 14:38:53 UTC) - CLUSTER/ISTIOD SIMULATED, PODS + ENVOY REAL ==========
PASS: Setup: istioctl 1.32.0 + proxyv2; fixed manifests (v1 APIs) schema-valid; istioctl analyze clean
PASS: Task 1: backend v1 x2 + v2 x2 running, each serving its own version page
PASS: Task 3.2: lab test script ran (50 requests, both versions seen)
PASS: Task 3.2: 70/30 split within 3 sigma over 200 requests (1.0=148 2.0=52 )
PASS: Task 3.3: user-type: beta -> 20/20 Version 2.0
PASS: Task 3.4/3.5: 50/50 and 90/10 splits within 3 sigma after re-applying the VS
PASS: Lab bug: gateway-only VS (same name) drops the in-mesh split -> plain ~50/50 round robin (1.0=100 2.0=100 )
PASS: Fixed: separate mesh VS restores 70/30 in-mesh (1.0=134 2.0=66 ) and beta header routing
PASS: Lab bug: geo VS never applied - US-WEST/US-EAST follow 70/30; applied -> US-WEST 20/20 v2, US-EAST 20/20 v1
PASS: Lab bug: monitor-ab-testing.sh divides by zero when every request fails; fixed version reports cleanly
PASS: Task 4.2: gateway Envoy stats count requests per subset (v1 and v2 clusters)
PASS: Time: finished in 77s (<= 300s)
CORE: 12/12 PASS
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
./istio-lab6/envoy/l6-ingressgateway.yaml
./istio-lab6/envoy/l6-sidecar.yaml
./istio-lab6/envoy/vs2envoy.py
./istio-lab6/html/v1.html
./istio-lab6/html/v2.html
./istio-lab6/k8s/backend-destination-rule.yaml
./istio-lab6/k8s/backend-gateway.yaml
./istio-lab6/k8s/backend-service.yaml
./istio-lab6/k8s/backend-v1.yaml
./istio-lab6/k8s/backend-v2.yaml
./istio-lab6/k8s/vs-gateway-50-50.yaml
./istio-lab6/k8s/vs-gateway-70-30.yaml
./istio-lab6/k8s/vs-gateway-90-10.yaml
./istio-lab6/k8s/vs-gateway-geo.yaml
./istio-lab6/k8s/vs-mesh-50-50.yaml
./istio-lab6/k8s/vs-mesh-70-30.yaml
./istio-lab6/k8s/vs-mesh-90-10.yaml
./istio-lab6/lab-original/backend-destination-rule.yaml
./istio-lab6/lab-original/backend-gateway.yaml
./istio-lab6/lab-original/backend-service.yaml
./istio-lab6/lab-original/backend-v1.yaml
./istio-lab6/lab-original/backend-v2.yaml
./istio-lab6/lab-original/backend-virtual-service-geo.yaml
./istio-lab6/lab-original/backend-virtual-service-updated.yaml
./istio-lab6/lab-original/backend-virtual-service.yaml
./istio-lab6/results/SIMULATED.md
./istio-lab6/results/analyze-fixed.txt
./istio-lab6/results/analyze-lab.txt
./istio-lab6/results/bug-monitor-dead-url.txt
./istio-lab6/results/elapsed.txt
./istio-lab6/results/fixed-monitor-dead-url.txt
./istio-lab6/results/image-pull.txt
./istio-lab6/results/kubeconform-fixed.txt
./istio-lab6/results/task-geo.txt
./istio-lab6/results/task-mesh-fixed.txt
./istio-lab6/results/task-mesh-lab.txt
./istio-lab6/results/task1-pods.txt
./istio-lab6/results/task3.2-70-30.txt
./istio-lab6/results/task3.2-lab-script-70-30.txt
./istio-lab6/results/task3.3-header.txt
./istio-lab6/results/task3.4-50-50.txt
./istio-lab6/results/task3.5-90-10.txt
./istio-lab6/results/task4.1-monitor-10s.txt
./istio-lab6/results/task4.2-envoy-subset-stats.txt
./istio-lab6/results/tools.txt
./istio-lab6/scripts/monitor-ab-testing-lab.sh
./istio-lab6/scripts/monitor-ab-testing.sh
./istio-lab6/scripts/test-ab-distribution.sh
```
