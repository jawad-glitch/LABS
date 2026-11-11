# Lab 14 - Distributed Tracing with Istio and Jaeger - completion proof
Completed (UTC): 2026-11-11 15:17:27 | EC2: i-0e88b5cdb573dfc94 | host: ip-172-31-10-80 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 14 - Distributed Tracing with Istio and Jaeger, 2026-11-11 15:17:20 UTC) ==========
FAIL: Setup: Jaeger pod is Running and healthy in namespace jaeger
FAIL: Setup: Jaeger Service exposes ports 16686 (UI) and 9411 (Zipkin)
FAIL: Task 2: Istio control plane configured with Zipkin tracing at 100%
FAIL: Task 3: Bookinfo application running with injected sidecars (2/2 containers)
FAIL: Task 4: Ingress Gateway and VirtualService mapped productpage route
FAIL: Task 5: Jaeger registered productpage.bookinfo as a monitored service
FAIL: Task 6: Distributed traces captured and queryable via Jaeger API
PASS: Time: Lab execution finished in <= 480s
CORE: 1/8 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./istio-lab14/results/elapsed.txt
./istio-lab14/results/env-cluster-info.txt
./istio-lab14/results/env-istio-pods.txt
./istio-lab14/results/env-istio-version.txt
./istio-lab14/results/env-nodes.txt
./istio-lab14/results/gw-pf.log
./istio-lab14/results/jaeger-pf.log
./istio-lab14/results/jaeger-services.json
./istio-lab14/results/recent_traces.json
./istio-lab14/results/service_dependencies.json
./istio-lab14/results/task1-jaeger-deploy.txt
./istio-lab14/results/task1-jaeger-wait.txt
./istio-lab14/results/task2-istioctl-install.txt
./istio-lab14/results/task2-istiod-rollout.txt
./istio-lab14/results/task3-bookinfo-deploy.txt
./istio-lab14/results/task3-bookinfo-wait.txt
./istio-lab14/results/task3-gateway.txt
./istio-lab14/results/task3-pods.txt
```
