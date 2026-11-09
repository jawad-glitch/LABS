# Lab 11 - Cilium Observability with Hubble - completion proof
Completed (UTC): 2026-11-09 15:04:55 | EC2: i-0ac609d2447057d33 | host: ip-172-31-10-234 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 11 - Cilium Observability with Hubble, 2026-11-09 15:04:49 UTC) ==========
PASS: Task 1: Cilium pods and cluster node readiness verified
PASS: Task 2: Hubble Relay and UI components enabled in cluster
PASS: Task 2: Hubble CLI installed and version verified
PASS: Task 3: Hubble CLI successfully connects to Relay service
PASS: Task 4: Hubble UI dashboard accessible via port-forward
PASS: Task 5: Test workloads deployed and HTTP traffic generated
PASS: Task 6: Real-time network & HTTP flows captured via Hubble CLI
PASS: Task 7: Packet drops observed under deny-all policy
PASS: Task 7: Allowed flows observed under permissive policy
PASS: Task 8: Hubble metrics and service dependencies analyzed
PASS: Reporting: Complete Hubble observability summary generated
PASS: Time: Finished in under 300s
CORE: 12/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./cilium-lab11/cilium-hubble-observability-summary.txt
./cilium-lab11/results/elapsed.txt
./cilium-lab11/results/task1.1-cilium-pods.txt
./cilium-lab11/results/task1.2-nodes.txt
./cilium-lab11/results/task2.1-helm-upgrade.txt
./cilium-lab11/results/task2.2-hubble-pods.txt
./cilium-lab11/results/task2.3-hubble-install.log
./cilium-lab11/results/task2.3-hubble-version.txt
./cilium-lab11/results/task3.2-hubble-status.txt
./cilium-lab11/results/task4.2-ui-code.txt
./cilium-lab11/results/task5.1-client-pod.txt
./cilium-lab11/results/task5.2-http-200.txt
./cilium-lab11/results/task5.2-http-404.txt
./cilium-lab11/results/task6.1-flows.txt
./cilium-lab11/results/task6.1-http-flows.txt
./cilium-lab11/results/task7.2-dropped-flows.txt
./cilium-lab11/results/task7.3-allowed-flows.txt
./cilium-lab11/results/task8.1-hubble-metrics.txt
./cilium-lab11/results/task8.2-service-dependencies.txt
```
