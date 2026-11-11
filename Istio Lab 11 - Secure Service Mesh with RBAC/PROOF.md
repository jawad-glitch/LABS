# Istio Lab 11 - Secure Service Mesh with RBAC - completion proof
Completed (UTC): 2026-11-11 15:05:15 | EC2: i-0473dcf5d6bf98f9e | host: ip-172-31-10-185 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Istio Lab 11 - Secure Service Mesh with RBAC, 2026-11-11 15:05:08 UTC) ==========
PASS: Kubeconform validation passed for RBAC manifests
PASS: SPIFFE workload certificates generated and verified for RBAC demo
PASS: RBAC enforcement correctly isolates frontend and admin permissions
PASS: Time: finished in 28s (<= 300s)
CORE: 4/4 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                  ID             DISK USAGE   CONTENT SIZE   EXTRA
istio/proxyv2:1.32.0   b8d47c6d8d6e        400MB         92.2MB        
nginx:1.21             2bcabc23b454        213MB         56.7MB        
```

## Files
```
./istio-lab11/envoy/gen.py
./istio-lab11/envoy/inbound-priv.yaml
./istio-lab11/envoy/inbound-pub.yaml
./istio-lab11/envoy/outbound-admin.yaml
./istio-lab11/envoy/outbound-default.yaml
./istio-lab11/envoy/outbound-frontend.yaml
./istio-lab11/k8s/authz-policy-headers.yaml
./istio-lab11/k8s/rbac-demo-all.yaml
./istio-lab11/pki/admin-sa.crt
./istio-lab11/pki/ca.crt
./istio-lab11/pki/ca.srl
./istio-lab11/pki/default-sa.crt
./istio-lab11/pki/frontend-sa.crt
./istio-lab11/results/elapsed.txt
./istio-lab11/results/image-pull.txt
./istio-lab11/results/kubeconform.txt
./istio-lab11/results/task5-rbac-results.txt
./istio-lab11/results/task6-headers.txt
./istio-lab11/results/tools.txt
./istio-lab11/results/workload-certs.txt
```
