# Istio Lab 2 - Istio Architecture and Components - completion proof
Completed (UTC): 2026-11-10 10:11:35 | EC2: i-002c7645dd90420e8 | host: ip-172-31-10-199 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Istio Lab 2 - Istio Architecture and Components, 2026-11-10 10:11:28 UTC) - CLUSTER SIMULATED, ISTIO TOOLING + ENVOY REAL ==========
PASS: Task 1: istioctl 1.32.0 (sha256) works offline; istio/pilot + istio/proxyv2 1.32.0 images pulled
PASS: Task 2.1: istio-system = istiod + istio-ingressgateway only (lab expected-output 'istio-proxy-xxx' pod does not exist)
PASS: Task 2.2-2.4: istiod label app=istiod; service exposes 15010/15012/15014 (+443 webhook)
PASS: Lab bug: istiod readiness is :8080/ready, not 15014/ready
FAIL: Lab bug: istiod image is distroless - no sh/curl (kubectl exec ... curl fails)
FAIL: Task 3.3/3.4 (real injector): istio-proxy gets admin/status/metrics ports; readiness 15021/healthz/ready
PASS: Task 5.2 (real Envoy version: 74027068e941c7a295be2bb7938f53fe4722a593/1.40.3-dev/Clean/RELEASE/BoringSSL): admin /ready LIVE; virtualInbound listener; inbound|80|| cluster healthy
PASS: Task 6.1: 5 requests through the Envoy sidecar -> 5 x HTTP 200; Envoy stats count them
PASS: Lab bug: default mesh accessLogFile empty -> no access logs (0 lines for 5 requests)
FAIL: Fix: access logging enabled (Telemetry resource, schema-valid) -> 5 access log lines
PASS: Tool availability in proxyv2 recorded (curl/netstat/pilot-agent); istioctl flags recorded; full-mode script parses
PASS: Time: finished in 115s (<= 300s)
CORE: 9/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                    ID             DISK USAGE   CONTENT SIZE   EXTRA
curlimages/curl:8.11.1   c1fe1679c34d       32.3MB         9.56MB        
istio/pilot:1.32.0       5383df363d97        325MB         76.2MB        
istio/proxyv2:1.32.0     b8d47c6d8d6e        400MB         92.2MB        
nginx:1.27-alpine        65645c7bb6a0       74.5MB         21.9MB        
```

## Files
```
./istio-lab2/envoy/envoy-default-no-accesslog.yaml
./istio-lab2/envoy/envoy-with-accesslog.yaml
./istio-lab2/full-mode.sh
./istio-lab2/k8s/nginx-test-injected.yaml
./istio-lab2/k8s/nginx-test.yaml
./istio-lab2/k8s/telemetry-access-logs.yaml
./istio-lab2/rendered/default.yaml.gz
./istio-lab2/results/SIMULATED.md
./istio-lab2/results/elapsed.txt
./istio-lab2/results/image-pull.txt
./istio-lab2/results/inject.err
./istio-lab2/results/k8s-kubeconform.txt
./istio-lab2/results/render.err
./istio-lab2/results/task1-istioctl-version.txt
./istio-lab2/results/task2-control-plane.txt
./istio-lab2/results/task3-dataplane.txt
./istio-lab2/results/task4-envoy-admin.txt
./istio-lab2/results/task4-istioctl-flags.txt
./istio-lab2/results/task5-envoy-version.txt
./istio-lab2/results/task5-image-tools.txt
./istio-lab2/results/task6-accesslog-default.txt
./istio-lab2/results/task6-accesslog-fixed.txt
./istio-lab2/results/task6-accesslog-sample.txt
./istio-lab2/results/task6-requests-default.txt
./istio-lab2/results/task6-requests-fixed.txt
./istio-lab2/results/tools.txt
```
