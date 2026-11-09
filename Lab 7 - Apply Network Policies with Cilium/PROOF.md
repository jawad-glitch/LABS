# Lab 7 - Apply Network Policies with Cilium - completion proof
Completed (UTC): 2026-11-09 14:51:56 | EC2: i-04f157d554ebf2319 | host: ip-172-31-10-7 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 7 - Apply Network Policies with Cilium, 2026-11-09 14:51:51 UTC) ==========
PASS: Task 1: Cilium installation and node health verified
FAIL: Task 2: Namespaces created (development, production, testing)
FAIL: Task 2: Multi-tier applications deployed (frontend, backend, database)
FAIL: Task 4.1: Deny-all backend CiliumNetworkPolicy applied
FAIL: Task 4.3: Ingress allow policy (frontend-to-backend) applied
FAIL: Task 4.5: Cross-namespace database access policy created
FAIL: Task 4.6: Backend egress policy defined and applied
FAIL: Task 5.3: Advanced frontend policy with L4 port rules configured
PASS: Task 6: Verification script executed with authorized and unauthorized checks
PASS: Task 7: Cilium endpoints reflect active policy enforcement state
PASS: Time: Finished in under 300s
CORE: 4/11 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./cilium-lab7/advanced-network-policy.yaml
./cilium-lab7/allow-backend-to-database-policy.yaml
./cilium-lab7/allow-frontend-to-backend-policy.yaml
./cilium-lab7/backend-deployment.yaml
./cilium-lab7/backend-egress-policy.yaml
./cilium-lab7/database-deployment.yaml
./cilium-lab7/deny-all-backend-policy.yaml
./cilium-lab7/frontend-deployment.yaml
./cilium-lab7/results/elapsed.txt
./cilium-lab7/results/task1.1-kube-system-pods.txt
./cilium-lab7/results/task1.1-nodes.txt
./cilium-lab7/results/task1.2-cilium-status.txt
./cilium-lab7/results/task1.2-cli-install.log
./cilium-lab7/results/task2.1-namespaces.txt
./cilium-lab7/results/task2.5-deployments.txt
./cilium-lab7/results/task2.5-pods.txt
./cilium-lab7/results/task2.5-services.txt
./cilium-lab7/results/task3.2-initial-fe-be.txt
./cilium-lab7/results/task6.1-cnp-list.txt
./cilium-lab7/results/task6.2-endpoints.txt
./cilium-lab7/results/task6.3-connectivity-results.txt
./cilium-lab7/test-connectivity.sh
./cilium-lab7/updated-frontend-to-backend-policy.yaml
```
