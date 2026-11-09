# Lab 8 - L7-Aware Network Policies - completion proof
Completed (UTC): 2026-11-09 14:55:10 | EC2: i-085413f222327aaaf | host: ip-172-31-10-199 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 8 - L7-Aware Network Policies, 2026-11-09 14:55:04 UTC) ==========
PASS: Task 1: Environment verified and test apps deployed in l7-policy-demo
PASS: Task 2: L7 HTTP policy defined and applied
PASS: Task 3: Allowed vs blocked HTTP method/path enforcement validated
PASS: Task 4: DNS-based egress policy created for client pod
PASS: Task 5: Header-based L7 CiliumNetworkPolicy applied
PASS: Task 6: Cilium policy tracing verified L7 verdict
PASS: Task 7: Optimized L7 policy created and applied
PASS: Task 8: Comprehensive test script executed with all checks passing
PASS: Reporting: Complete L7 policy audit report generated
PASS: Time: Finished in under 300s
CORE: 10/10 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./cilium-lab8/cilium-l7-audit-report.txt
./cilium-lab8/client-deployment.yaml
./cilium-lab8/httpbin-deployment.yaml
./cilium-lab8/l7-dns-policy.yaml
./cilium-lab8/l7-header-policy.yaml
./cilium-lab8/l7-http-policy.yaml
./cilium-lab8/l7-optimized-policy.yaml
./cilium-lab8/results/elapsed.txt
./cilium-lab8/results/task1.1-cilium-status.txt
./cilium-lab8/results/task1.1-kube-system-pods.txt
./cilium-lab8/results/task1.1-nodes.txt
./cilium-lab8/results/task1.2-client.log
./cilium-lab8/results/task1.2-httpbin.log
./cilium-lab8/results/task1.3-pod-names.txt
./cilium-lab8/results/task1.3-pods.txt
./cilium-lab8/results/task2.2-apply-http-policy.log
./cilium-lab8/results/task2.3-cnp-describe.txt
./cilium-lab8/results/task2.3-cnp-list.txt
./cilium-lab8/results/task3.1-allowed-tests.txt
./cilium-lab8/results/task3.2-blocked-tests.txt
./cilium-lab8/results/task4.1-dns-policy.log
./cilium-lab8/results/task4.2-dns-test.txt
./cilium-lab8/results/task5.1-header-policy.log
./cilium-lab8/results/task5.2-header-test.txt
./cilium-lab8/results/task6.1-policy-trace.txt
./cilium-lab8/results/task6.2-endpoints.txt
./cilium-lab8/results/task7.2-optimized.log
./cilium-lab8/results/task8.1-test-l7-output.txt
./cilium-lab8/test-l7-policies.sh
```
