# Istio Lab 13 - Visualizing Traffic Flows with Kiali - completion proof
Completed (UTC): 2026-11-11 15:12:17 | EC2: i-043d459ce88fc5b6c | host: ip-172-31-10-4 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Istio Lab 13 - Visualizing Traffic Flows with Kiali, 2026-11-11 15:12:11 UTC) ==========
FAIL: Kubeconform validation passed for Kiali and gateway manifests
FAIL: Kiali server container running and responsive on port 20001
PASS: Bookinfo traffic simulation verified
PASS: Time: finished in 15s (<= 300s)
CORE: 2/4 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                         ID             DISK USAGE   CONTENT SIZE   EXTRA
istio/proxyv2:1.32.0          b8d47c6d8d6e        400MB         92.2MB        
nginx:1.27-alpine             65645c7bb6a0       74.5MB         21.9MB        
prom/prometheus:v2.40.0       8e6e3cce3552        316MB         90.1MB        
quay.io/kiali/kiali:v1.73.0   c88b7d8be52e        184MB         53.9MB        
```

## Files
```
./istio-lab13/k8s/kiali-all.yaml
./istio-lab13/results/elapsed.txt
./istio-lab13/results/image-pull.txt
./istio-lab13/results/kubeconform.txt
./istio-lab13/results/task3-traffic.txt
./istio-lab13/results/task5-kiali.txt
./istio-lab13/results/tools.txt
```
