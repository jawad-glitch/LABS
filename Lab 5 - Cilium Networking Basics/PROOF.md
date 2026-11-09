# Lab 5 - Cilium Networking Basics - completion proof
Completed (UTC): 2026-11-09 14:44:53 | EC2: i-0cd47ba56b5a576b6 | host: ip-172-31-10-153 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 5 - Cilium Networking Basics, 2026-11-09 14:44:47 UTC) ==========
PASS: Task 1: Cilium CLI installed and checksum verified
PASS: Task 1: Cilium deployed and running as CNI
FAIL: Task 2: Test pods created (nginx, nginx2, busybox, alpine)
PASS: Task 2: Pod network configuration inspected (IP address and routes)
PASS: Task 3: Pod-to-pod ping connectivity successful
PASS: Task 3: Pod-to-pod HTTP connectivity verified
PASS: Task 3: DNS resolution verified within cluster
PASS: Task 4: Cilium endpoints (CEP) registered and active
PASS: Task 5: Cilium configuration & logs captured
PASS: Verification: Connectivity test script executed with all checks passing
PASS: Reporting: Complete summary report generated
PASS: Time: Finished in under 300s
CORE: 11/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./cilium-lab5/cilium-networking-summary.txt
./cilium-lab5/connectivity_test.sh
./cilium-lab5/results/connectivity-test-output.txt
./cilium-lab5/results/elapsed.txt
./cilium-lab5/results/pod-ips.txt
./cilium-lab5/results/task1.1-cluster-info.txt
./cilium-lab5/results/task1.1-kube-system-pods.txt
./cilium-lab5/results/task1.1-nodes.txt
./cilium-lab5/results/task1.2-cilium-version.txt
./cilium-lab5/results/task1.2-cli-install.log
./cilium-lab5/results/task1.3-cilium-pods.txt
./cilium-lab5/results/task1.3-cilium-status.txt
./cilium-lab5/results/task1.3-install.log
./cilium-lab5/results/task2.1-nginx-describe.txt
./cilium-lab5/results/task2.2-pods-wide.txt
./cilium-lab5/results/task2.3-nginx-ip-addr.txt
./cilium-lab5/results/task2.3-nginx-ip-route.txt
./cilium-lab5/results/task3.1-ping-nginx.txt
./cilium-lab5/results/task3.1-ping-nginx2.txt
./cilium-lab5/results/task3.2-http-nginx.txt
./cilium-lab5/results/task3.3-dns.txt
./cilium-lab5/results/task4.1-cilium-status-verbose.txt
./cilium-lab5/results/task4.2-cep.txt
./cilium-lab5/results/task4.2-endpoint-list.txt
./cilium-lab5/results/task4.3-identities.txt
./cilium-lab5/results/task4.3-policies.txt
./cilium-lab5/results/task5.2-cilium-config.yaml
./cilium-lab5/results/task5.2-cilium-logs.txt
```
