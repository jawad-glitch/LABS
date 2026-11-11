# Lab 15 - Debugging Service Communication Issues - completion proof
Completed (UTC): 2026-11-11 15:27:49 | EC2: i-0e66095016932c724 | host: ip-172-31-10-99 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 15 - Debugging Service Communication Issues, 2026-11-11 15:27:42 UTC) ==========
FAIL: Setup: Bookstore pods ready with 2/2 containers (Istio sidecars injected)
FAIL: Task 2: Broken configuration captured (HTTP 503 / connection errors logged)
PASS: Task 3: istioctl analyze diagnostics executed
FAIL: Task 4: DR and VS fixed with valid subset version=v1
FAIL: Task 5.1: Frontend to backend communication restored (5/5 HTTP 200)
PASS: Task 5.2: Envoy outbound endpoint cluster populated with backend pod IP
PASS: Task 6: Istio debugging architecture report successfully generated
PASS: Execution Time: Finished cleanly within 300 seconds
CORE: 4/8 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./istio-lab15/istio-architecture-report.txt
./istio-lab15/results/elapsed.txt
./istio-lab15/results/jaeger-pf.log
./istio-lab15/results/kiali-pf.log
./istio-lab15/results/task1.1-kube-system-pods.txt
./istio-lab15/results/task1.1-nodes.txt
./istio-lab15/results/task1.2-initial-proxy-status.txt
./istio-lab15/results/task1.2-istio-pods.txt
./istio-lab15/results/task1.2-istioctl-version.txt
./istio-lab15/results/task1.3-deploy-backend.txt
./istio-lab15/results/task1.3-deploy-frontend.txt
./istio-lab15/results/task1.4-pods-wide.txt
./istio-lab15/results/task1.4-services.txt
./istio-lab15/results/task2.1-broken-vs.txt
./istio-lab15/results/task2.2-broken-dr.txt
./istio-lab15/results/task2.3-broken-curl.txt
./istio-lab15/results/task3.1-backend-proxy-status.txt
./istio-lab15/results/task3.1-proxy-cluster.txt
./istio-lab15/results/task3.1-proxy-status.txt
./istio-lab15/results/task3.2-broken-endpoint.txt
./istio-lab15/results/task3.2-istioctl-analyze.txt
./istio-lab15/results/task3.2-proxy-route.txt
./istio-lab15/results/task4.1-backend-labels.txt
./istio-lab15/results/task4.2-fixed-dr.txt
./istio-lab15/results/task4.3-fixed-vs.txt
./istio-lab15/results/task4.4-istioctl-analyze.txt
./istio-lab15/results/task4.4-proxy-status.txt
./istio-lab15/results/task5.1-fixed-curl.txt
./istio-lab15/results/task5.1-success-count.txt
./istio-lab15/results/task5.2-route-config.txt
./istio-lab15/results/task5.2-v1-endpoint.txt
./istio-lab15/results/task6.1-log-level.txt
./istio-lab15/results/task6.1-proxy-debug-logs.txt
```
