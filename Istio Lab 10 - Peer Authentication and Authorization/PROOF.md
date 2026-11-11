# Istio Lab 10 - Peer Authentication and Authorization - completion proof
Completed (UTC): 2026-11-11 15:01:37 | EC2: i-0b4823faedf550f46 | host: ip-172-31-10-24 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Istio Lab 10 - Peer Authentication and Authorization, 2026-11-11 15:01:29 UTC) ==========
PASS: Kubeconform validation passed for lab manifests
PASS: Workload SPIFFE certificates generated and verified
FAIL: Strict mTLS enforces authentication (productpage succeeds, attacker blocked)
FAIL: Deny-all authorization policy blocks requests
FAIL: Selective allow policy permits productpage GET but blocks unauthorized sources and methods
FAIL: Conditional authorization policy validates user-agent headers
PASS: Time: finished in 38s (<= 300s)
CORE: 3/7 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                  ID             DISK USAGE   CONTENT SIZE   EXTRA
istio/proxyv2:1.32.0   b8d47c6d8d6e        400MB         92.2MB        
nginx:1.27-alpine      65645c7bb6a0       74.5MB         21.9MB        
```

## Files
```
./istio-lab10/envoy/gen.py
./istio-lab10/envoy/inbound-authz-allow.yaml
./istio-lab10/envoy/inbound-authz-conditional.yaml
./istio-lab10/envoy/inbound-authz-deny-all.yaml
./istio-lab10/envoy/inbound-authz-ns.yaml
./istio-lab10/envoy/inbound-strict-default.yaml
./istio-lab10/envoy/outbound-attacker.yaml
./istio-lab10/envoy/outbound-bookinfo-productpage.yaml
./istio-lab10/envoy/outbound-bookinfo-reviews.yaml
./istio-lab10/k8s/allow-details.yaml
./istio-lab10/k8s/authorization-policies.yaml
./istio-lab10/k8s/conditional-authz.yaml
./istio-lab10/k8s/deny-all.yaml
./istio-lab10/k8s/namespace-authz.yaml
./istio-lab10/k8s/peerauthentication-details.yaml
./istio-lab10/k8s/peerauthentication-mesh.yaml
./istio-lab10/pki/attacker.crt
./istio-lab10/pki/bookinfo-details.crt
./istio-lab10/pki/bookinfo-productpage.crt
./istio-lab10/pki/bookinfo-reviews.crt
./istio-lab10/pki/ca.crt
./istio-lab10/pki/ca.srl
./istio-lab10/pki/istio-ingressgateway-service-account.crt
./istio-lab10/results/elapsed.txt
./istio-lab10/results/image-pull.txt
./istio-lab10/results/kubeconform.txt
./istio-lab10/results/task2-mtls.txt
./istio-lab10/results/task3-deny.txt
./istio-lab10/results/task4-allow.txt
./istio-lab10/results/task4-conditional.txt
./istio-lab10/results/task6-ns.txt
./istio-lab10/results/tools.txt
./istio-lab10/results/workload-certs.txt
```
