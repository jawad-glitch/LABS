# Istio Lab 3 - Deploy a Simple Application with Istio - completion proof
Completed (UTC): 2026-11-10 10:14:46 | EC2: i-0502884116219a2f7 | host: ip-172-31-10-235 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Istio Lab 3 - Deploy a Simple Application with Istio, 2026-11-10 10:14:38 UTC) - CLUSTER/ISTIOD SIMULATED, PODS + ENVOY GATEWAY REAL ==========
PASS: Task 1: hello-app 1.0/2.0 images pulled (source recorded); istioctl 1.32.0 + proxyv2 available
PASS: Tasks 1-2: Deployments/Services/Gateway/VirtualService/DestinationRules (networking.istio.io/v1) schema-valid
PASS: Validation: istioctl analyze (offline, incl. real ingressgateway workload) reports no errors on the fixed set
PASS: Task 3.1: 2 frontend + 2 backend pods running
PASS: Task 3.4: via gateway / and /frontend -> Version 1.0.0 (frontend); /backend -> Version 2.0.0 (backend); all HTTP 200
PASS: DestinationRules applied: requests spread across both frontend pods and both backend pods
PASS: Lab bug: hello-app ignores MESSAGE - 'Hello from Backend Service!' never appears in the response
FAIL: Task 3.5: gateway stats count upstream requests per cluster; 4 endpoints discovered via Service DNS
FAIL: Task 3.6: app logs and gateway access log captured
PASS: Full-mode script parses (NodePort GATEWAY_URL, rollout status, no -it)
PASS: Time: finished in 33s (<= 300s)
CORE: 9/11 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                                 ID             DISK USAGE   CONTENT SIZE   EXTRA
gcr.io/google-samples/hello-app:1.0   649188051906       19.1MB         5.36MB        
gcr.io/google-samples/hello-app:2.0   9b987009d04e       19.1MB         5.36MB        
istio/proxyv2:1.32.0                  b8d47c6d8d6e        400MB         92.2MB        
```

## Files
```
./istio-lab3/envoy/ingressgateway.yaml
./istio-lab3/full-mode.sh
./istio-lab3/k8s/hello-backend.yaml
./istio-lab3/k8s/hello-destinationrule.yaml
./istio-lab3/k8s/hello-frontend.yaml
./istio-lab3/k8s/hello-gateway.yaml
./istio-lab3/k8s/hello-virtualservice.yaml
./istio-lab3/lab-original/hello-backend.yaml
./istio-lab3/lab-original/hello-destinationrule.yaml
./istio-lab3/lab-original/hello-frontend.yaml
./istio-lab3/lab-original/hello-gateway.yaml
./istio-lab3/lab-original/hello-virtualservice.yaml
./istio-lab3/results/SIMULATED.md
./istio-lab3/results/elapsed.txt
./istio-lab3/results/proxyv2-pull.txt
./istio-lab3/results/task1-image-source.txt
./istio-lab3/results/task2-kubeconform-fixed.txt
./istio-lab3/results/task2-kubeconform-lab.txt
./istio-lab3/results/task2.4-gateway.txt
./istio-lab3/results/task3-analyze-k8s.txt
./istio-lab3/results/task3-analyze-lab-original.txt
./istio-lab3/results/task3.1-pods.txt
./istio-lab3/results/task3.4-backend-body.txt
./istio-lab3/results/task3.4-connectivity.txt
./istio-lab3/results/task3.4-loadbalancing.txt
./istio-lab3/results/task3.5-cluster-endpoints.txt
./istio-lab3/results/task3.5-envoy-stats.txt
./istio-lab3/results/task3.6-app-logs.txt
./istio-lab3/results/task3.6-gateway-access-log.txt
./istio-lab3/results/tools.txt
```
