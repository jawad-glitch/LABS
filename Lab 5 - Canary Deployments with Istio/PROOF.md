# Lab 5 - Canary Deployments with Istio - completion proof
Completed (UTC): 2026-11-10 10:23:00 | EC2: i-00845319a6e9ea237 | host: ip-172-31-10-219 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 5 - Canary Deployments with Istio, 2026-11-10 10:22:53 UTC) ==========
FAIL: Task 1: Namespace canary-demo created with Istio injection enabled
FAIL: Task 1: Backend v1 and v2 deployments deployed with version labels
FAIL: Task 1: Backend ClusterIP service created
FAIL: Task 2: DestinationRule backend-destination-rule subsets v1/v2 defined
PASS: Task 2: Initial VirtualService configured for 100% v1 routing
FAIL: Task 2: Ingress Gateway and VirtualService mapped
PASS: Task 3: 10% Canary traffic splitting VirtualService applied
PASS: Task 3: Header-based routing verified (canary: true routes to v2)
PASS: Task 3: Gradual rollout stages created (25% and 50% manifests)
FAIL: Task 3: Final 100% canary rollout manifest deployed
PASS: Task 3: Operational scripts generated (monitor, rollback, health, cleanup)
PASS: Reporting: Lab summary report generated
PASS: Time: Lab completed in under 300s
CORE: 7/13 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./istio-lab5/backend-destination-rule.yaml
./istio-lab5/backend-gateway.yaml
./istio-lab5/backend-service.yaml
./istio-lab5/backend-v1.yaml
./istio-lab5/backend-v2.yaml
./istio-lab5/backend-virtual-service-10.yaml
./istio-lab5/backend-virtual-service-100.yaml
./istio-lab5/backend-virtual-service-25.yaml
./istio-lab5/backend-virtual-service-50.yaml
./istio-lab5/backend-virtual-service-v1.yaml
./istio-lab5/cleanup-old-version.sh
./istio-lab5/health-monitor.sh
./istio-lab5/istio-canary-summary.txt
./istio-lab5/monitor-traffic.sh
./istio-lab5/results/elapsed.txt
./istio-lab5/results/task1.1-cluster-info.txt
./istio-lab5/results/task1.1-istio-pods.txt
./istio-lab5/results/task1.2-backend-v1.log
./istio-lab5/results/task1.3-backend-v2.log
./istio-lab5/results/task1.4-backend-service.log
./istio-lab5/results/task1.5-deployments.txt
./istio-lab5/results/task1.5-pods-labels.txt
./istio-lab5/results/task1.5-services.txt
./istio-lab5/results/task2.1-dr.log
./istio-lab5/results/task2.2-vs-v1.log
./istio-lab5/results/task2.3-gateway.log
./istio-lab5/results/task2.4-initial-test.txt
./istio-lab5/results/task3.1-vs-10.log
./istio-lab5/results/task3.3-header-test.txt
./istio-lab5/results/task3.4-vs-25.log
./istio-lab5/results/task3.5-vs-50.log
./istio-lab5/results/task3.6-vs-100.log
./istio-lab5/rollback-canary.sh
```
