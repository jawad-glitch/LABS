# Lab 9 - Cilium Identity-Based Security - completion proof
Completed (UTC): 2026-11-09 14:59:02 | EC2: i-07f9f1a4ff90a55ff | host: ip-172-31-10-246 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 9 - Cilium Identity-Based Security, 2026-11-09 14:58:56 UTC) ==========
FAIL: Task 1: Environment ready and identity-lab namespace configured
FAIL: Task 2: Deployments configured with tier and security-level labels
PASS: Task 2: Cilium identities registered and listed
FAIL: Task 3.1: Default deny CiliumNetworkPolicy applied
FAIL: Task 3.2: Frontend to backend ingress policy active
FAIL: Task 3.3: Backend to database identity access policy active
PASS: Task 3.4/3.5: DNS and external ingress policies created
PASS: Task 4.7: Dynamic policy addition and revocation verified
PASS: Verification: Identity enforcement test matrix verified
PASS: Reporting: Complete identity summary report generated
PASS: Time: Finished in under 300s
CORE: 6/11 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./cilium-lab9/backend-deployment.yaml
./cilium-lab9/backend-to-database-policy.yaml
./cilium-lab9/cilium-identity-summary.txt
./cilium-lab9/database-deployment.yaml
./cilium-lab9/default-deny-policy.yaml
./cilium-lab9/dns-policy.yaml
./cilium-lab9/external-access-policy.yaml
./cilium-lab9/frontend-deployment.yaml
./cilium-lab9/frontend-to-backend-policy.yaml
./cilium-lab9/results/elapsed.txt
./cilium-lab9/results/task1.1-cilium-status.txt
./cilium-lab9/results/task1.1-nodes.txt
./cilium-lab9/results/task2.1-fe.log
./cilium-lab9/results/task2.2-be.log
./cilium-lab9/results/task2.3-db.log
./cilium-lab9/results/task2.4-pods-labels.txt
./cilium-lab9/results/task2.5-identity-list.txt
./cilium-lab9/results/task3.1-default-deny.log
./cilium-lab9/results/task3.2-fe-be.log
./cilium-lab9/results/task3.3-be-db.log
./cilium-lab9/results/task3.4-dns.log
./cilium-lab9/results/task3.5-ext.log
./cilium-lab9/results/task3.6-cnp-list.txt
./cilium-lab9/results/task4.1-client.log
./cilium-lab9/results/task4.6-endpoints.txt
./cilium-lab9/results/task4.7-dynamic-test.txt
./cilium-lab9/results/task4.7-temp-policy.log
./cilium-lab9/results/task4.8-verification-results.txt
./cilium-lab9/temp-test-policy.yaml
./cilium-lab9/test-client.yaml
```
