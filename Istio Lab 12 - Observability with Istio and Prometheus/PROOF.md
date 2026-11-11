# Istio Lab 12 - Observability with Istio and Prometheus - completion proof
Completed (UTC): 2026-11-11 15:08:08 | EC2: i-0b68c1d8288a5e69b | host: ip-172-31-10-139 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Istio Lab 12 - Observability with Istio and Prometheus, 2026-11-11 15:08:01 UTC) ==========
PASS: Kubeconform validation passed for observability manifests
FAIL: Prometheus container running and responsive on port 9090
PASS: Bookinfo application mock deployed and traffic generated
PASS: Time: finished in 18s (<= 300s)
CORE: 3/4 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                     ID             DISK USAGE   CONTENT SIZE   EXTRA
istio/proxyv2:1.32.0      b8d47c6d8d6e        400MB         92.2MB        
nginx:1.27-alpine         65645c7bb6a0       74.5MB         21.9MB        
prom/prometheus:v2.40.0   8e6e3cce3552        316MB         90.1MB        
```

## Files
```
./istio-lab12/k8s/bookinfo-sample.yaml
./istio-lab12/k8s/prometheus-all.yaml
./istio-lab12/results/elapsed.txt
./istio-lab12/results/image-pull.txt
./istio-lab12/results/kubeconform.txt
./istio-lab12/results/task2-observability.txt
./istio-lab12/results/task2-traffic.txt
./istio-lab12/results/tools.txt
```
