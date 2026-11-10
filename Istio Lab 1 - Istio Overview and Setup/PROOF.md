# Istio Lab 1 - Istio Overview and Setup - completion proof
Completed (UTC): 2026-11-10 10:05:46 | EC2: i-0e341810d55189406 | host: ip-172-31-10-174 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Istio Lab 1 - Istio Overview and Setup, 2026-11-10 10:05:41 UTC) - CLUSTER RUNTIME SIMULATED, ISTIO TOOLING REAL ==========
PASS: Task 2.1: istioctl 1.32.0 installed from the release tarball (sha256 verified); docker/kubectl present
PASS: Task 2.2: lab command renders the DEFAULT profile - istiod + istio-ingressgateway, no egress gateway; manifests valid
PASS: Lab bug: comment says 'demo profile' - demo adds istio-egressgateway (differs from what was installed)
PASS: Task 3.3: Istio CRDs present in the release (15), incl. virtualservices/gateways/destinationrules
PASS: Lab bug: installation creates no Gateway resource (kubectl get gateway -A shows nothing)
PASS: Lab caveat: istiod requests in default profile recorded (memory vs 3.8 GB VM)
PASS: Task 3.2: istioctl command availability recorded (verify-install / precheck / proxy-status / proxy-config / kube-inject)
FAIL: Task 4.2 (real injector): istio-proxy (1.32.0 proxyv2) injected into nginx-test; mode recorded
FAIL: Task 4.2: injected pod would report 2 ready containers (nginx + istio-proxy) regardless of sidecar mode
PASS: Task 4.1: pinned app + injected manifests schema-valid; full-mode script parses
PASS: Time: finished in 90s (<= 300s)
CORE: 9/11 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./istio-lab1/app/nginx-test-injected.yaml
./istio-lab1/app/nginx-test.yaml
./istio-lab1/full-mode.sh
./istio-lab1/rendered/default-profile.yaml.gz
./istio-lab1/rendered/demo-profile.yaml.gz
./istio-lab1/results/SIMULATED.md
./istio-lab1/results/elapsed.txt
./istio-lab1/results/render-default.err
./istio-lab1/results/render-demo.err
./istio-lab1/results/task1-versions.txt
./istio-lab1/results/task2.2-kubeconform.txt
./istio-lab1/results/task2.2-profile-inventory.txt
./istio-lab1/results/task3-istioctl-commands.txt
./istio-lab1/results/task4-app-kubeconform.txt
./istio-lab1/results/task4-kube-inject.err
./istio-lab1/results/task4.2-injection.txt
./istio-lab1/results/tools.txt
```
