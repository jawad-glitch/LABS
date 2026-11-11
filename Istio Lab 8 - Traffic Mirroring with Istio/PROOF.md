# Istio Lab 8 - Traffic Mirroring with Istio - completion proof
Completed (UTC): 2026-11-11 14:50:29 | EC2: i-03a2eebeb2171fc4f | host: ip-172-31-10-214 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Istio Lab 8 - Traffic Mirroring with Istio, 2026-11-11 14:50:20 UTC) - CLUSTER/ISTIOD SIMULATED, PODS + ENVOY REAL ==========
PASS: Setup: productpage image (docker.io/istio/examples-bookinfo-productpage-v1:1.17.0) v1+v2 serve /productpage 200; fixed manifests schema-valid
FAIL: Task 3.1: 50% rule - v1 gets all 100, v2 receives ~50 mirrored copies (3 sigma) all marked -shadow; client only ever sees 200
FAIL: Task 3.1: end-user: jason -> 100% mirrored (20/20); mirrored copy carries the same x-request-id as the original
FAIL: Task 5.1: 25% rule -> ~25 mirrored of 100 (3 sigma)
FAIL: Task 5.2: conditional - beta-tester 20/20 mirrored, no header 0 mirrored
FAIL: Lab bug: lab gateway VS (no subset) sends LIVE traffic to v2 (~50%) and mirrors nothing
FAIL: Fixed gateway VS (subset v1 + mirror v2): v1 100, v2 only shadow copies (100)
PASS: Lab bug: v2 RESPONSE_HEADER env is ignored by the app (no mirror-version header)
FAIL: Lab bug: 'grep -c ... || echo 0' yields two zeros on no match -> integer expression error
PASS: Lab bug: traffic generator prints a literal $(date) (single-quoted)
PASS: Lab bug: IstioOperator via kubectl is not reconciled ( 'operator' command NOT present (in-clus); fixed Telemetry access logging valid
PASS: Time: finished in 66s (<= 300s)
CORE: 5/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                                           ID             DISK USAGE   CONTENT SIZE   EXTRA
istio/examples-bookinfo-productpage-v1:1.17.0   6668bcf42ef0        296MB         67.5MB        
istio/proxyv2:1.32.0                            b8d47c6d8d6e        400MB         92.2MB        
```

## Files
```
./istio-lab8/envoy/inbound.yaml
./istio-lab8/envoy/l8-gateway-gateway.yaml
./istio-lab8/envoy/l8-sidecar-virtual-service-conditional.yaml
./istio-lab8/envoy/l8-sidecar-virtual-service-mirror.yaml
./istio-lab8/envoy/l8-sidecar-virtual-service-percentage.yaml
./istio-lab8/envoy/vs2envoy.py
./istio-lab8/k8s/destination-rule.yaml
./istio-lab8/k8s/gateway.yaml
./istio-lab8/k8s/telemetry-access-log.yaml
./istio-lab8/k8s/virtual-service-conditional.yaml
./istio-lab8/k8s/virtual-service-mirror.yaml
./istio-lab8/k8s/virtual-service-percentage.yaml
./istio-lab8/lab-original/destination-rule.yaml
./istio-lab8/lab-original/gateway.yaml
./istio-lab8/lab-original/virtual-service-conditional.yaml
./istio-lab8/lab-original/virtual-service-mirror.yaml
./istio-lab8/lab-original/virtual-service-percentage.yaml
./istio-lab8/results/SIMULATED.md
./istio-lab8/results/bug-grep-count.txt
./istio-lab8/results/bug-istiooperator.txt
./istio-lab8/results/bug-traffic-generator-quote.txt
./istio-lab8/results/elapsed.txt
./istio-lab8/results/image-pp.txt
./istio-lab8/results/image-pull.txt
./istio-lab8/results/inbound-v1-access.log
./istio-lab8/results/inbound-v2-access.log
./istio-lab8/results/kubeconform-fixed.txt
./istio-lab8/results/task1-pods.txt
./istio-lab8/results/task3.2-gateway.txt
./istio-lab8/results/task4-mirror-50.txt
./istio-lab8/results/task4-mirror-jason.txt
./istio-lab8/results/task4-shadow-sample.txt
./istio-lab8/results/task4.2-app-log-lines.txt
./istio-lab8/results/task5-conditional.txt
./istio-lab8/results/task5-mirror-25.txt
./istio-lab8/results/tools.txt
./istio-lab8/scripts/count-mirroring.sh
```
