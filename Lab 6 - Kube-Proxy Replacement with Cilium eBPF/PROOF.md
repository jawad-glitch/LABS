# Lab 6 - Kube-Proxy Replacement with Cilium eBPF - completion proof
Completed (UTC): 2026-11-09 14:48:17 | EC2: i-03b5ec9dee20f14bd | host: ip-172-31-10-24 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 6 - Kube-Proxy Replacement with Cilium eBPF, 2026-11-09 14:48:11 UTC) ==========
PASS: Task 1: Kubernetes cluster and node status verified
PASS: Task 2: Test Deployment & Service deployed in cilium-test
PASS: Task 3: Cilium configured with kubeProxyReplacement=strict in values
PASS: Task 3: Kube-proxy DaemonSet disabled or removed
PASS: Task 4: Cilium status confirms KubeProxyReplacement is active
PASS: Task 4: eBPF load balancer table contains active backend mappings
PASS: Task 4: NodePort service created and mapped in eBPF
PASS: Task 5: Hubble UI service configuration validated
PASS: Task 6: Validation script executed and all checks passed
PASS: Task 6: Performance comparison script generated and run
PASS: Time: Finished in under 300s
CORE: 11/11 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./cilium-lab6/cilium-values.yaml
./cilium-lab6/compare-performance.sh
./cilium-lab6/performance-test.sh
./cilium-lab6/results/compare-performance-output.txt
./cilium-lab6/results/elapsed.txt
./cilium-lab6/results/service-ip.txt
./cilium-lab6/results/task1.1-cluster-info.txt
./cilium-lab6/results/task1.1-nodes.txt
./cilium-lab6/results/task1.2-cli-install.log
./cilium-lab6/results/task2.2-endpoints.txt
./cilium-lab6/results/task2.2-svc.txt
./cilium-lab6/results/task2.3-iptables.txt
./cilium-lab6/results/task3.3-helm-upgrade.txt
./cilium-lab6/results/task4.1-bpf-lb.txt
./cilium-lab6/results/task4.1-cilium-status-verbose.txt
./cilium-lab6/results/task4.1-cilium-status.txt
./cilium-lab6/results/task4.3-endpoints.txt
./cilium-lab6/results/task4.3-service-list.txt
./cilium-lab6/results/task5.2-perf-output.txt
./cilium-lab6/results/validate-setup-output.txt
./cilium-lab6/validate-setup.sh
```
