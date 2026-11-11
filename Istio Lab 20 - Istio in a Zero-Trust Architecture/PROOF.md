# Istio Lab 20 - Istio in a Zero-Trust Architecture - completion proof
Completed (UTC): 2026-11-11 20:32:46 | EC2: i-0789c44a06333d6a6 | host: ip-172-31-10-98 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Istio Lab 20 - Istio in a Zero-Trust Architecture, 2026-11-11 20:32:36 UTC) - CLUSTER/ISTIOD SIMULATED, mTLS + RBAC + ENVOY REAL ==========
PASS: Setup: lab images + proxyv2 1.32.0; fixed manifests (mesh PeerAuthentication, SAs, v1 policies) schema-valid
PASS: Lab bug: httpd:2.4 (backend) has no curl - lab's backend->database exec test cannot run; nginx:1.21 has curl
PASS: istioctl 1.32.0: lab commands checked (authn tls-check absent); replacements x authz check + proxy-config secret present
PASS: Task 2.4 STRICT: mesh client 200, backend presents spiffe .../sa/backend-sa, plaintext client rejected
PASS: Task 3.2 default deny: 'default' SA (before the SA patch) denied everywhere except frontend GET
PASS: Task 3.3: frontend-sa -> backend GET 200, DELETE 403; frontend-sa -> database 403
PASS: Task 3.3: backend-sa -> database 200; database-sa -> backend 403
PASS: Task 3.3: frontend open to any authenticated caller for GET only (POST 403)
PASS: Denials are Envoy RBAC 403 'RBAC: access denied' and logged with the caller's SPIFFE identity
FAIL: Lab bug: block-frontend-temp does NOT block frontend->backend (200) - it blocks callers OF frontend (403)
PASS: Fixed temp block (DENY on backend): frontend-sa -> backend 403, others unaffected; removal restores 200
PASS: Time: finished in 55s (<= 300s)
CORE: 11/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                  ID             DISK USAGE   CONTENT SIZE   EXTRA
httpd:2.4              ce3b1e5ab31c        178MB         47.7MB        
istio/proxyv2:1.32.0   b8d47c6d8d6e        400MB         92.2MB        
nginx:1.21             2bcabc23b454        213MB         56.7MB        
```

## Files
```
./istio-lab20/envoy/client-backend-sa.yaml
./istio-lab20/envoy/client-database-sa.yaml
./istio-lab20/envoy/client-default.yaml
./istio-lab20/envoy/client-frontend-sa.yaml
./istio-lab20/envoy/fixed-temp-backend-inbound.yaml
./istio-lab20/envoy/fixed-temp-database-inbound.yaml
./istio-lab20/envoy/fixed-temp-frontend-inbound.yaml
./istio-lab20/envoy/gen.py
./istio-lab20/envoy/lab-backend-inbound.yaml
./istio-lab20/envoy/lab-database-inbound.yaml
./istio-lab20/envoy/lab-frontend-inbound.yaml
./istio-lab20/envoy/lab-temp-backend-inbound.yaml
./istio-lab20/envoy/lab-temp-database-inbound.yaml
./istio-lab20/envoy/lab-temp-frontend-inbound.yaml
./istio-lab20/envoy/strict-only-backend-inbound.yaml
./istio-lab20/envoy/strict-only-database-inbound.yaml
./istio-lab20/envoy/strict-only-frontend-inbound.yaml
./istio-lab20/k8s/allow-frontend-access.yaml
./istio-lab20/k8s/backend-to-database.yaml
./istio-lab20/k8s/block-frontend-temp.yaml
./istio-lab20/k8s/deny-all.yaml
./istio-lab20/k8s/frontend-to-backend.yaml
./istio-lab20/k8s/peerauthentication-mesh.yaml
./istio-lab20/k8s/workloads.yaml
./istio-lab20/lab-original/allow-frontend-access.yaml
./istio-lab20/lab-original/backend-to-database.yaml
./istio-lab20/lab-original/block-frontend-temp.yaml
./istio-lab20/lab-original/deny-all.yaml
./istio-lab20/lab-original/frontend-to-backend.yaml
./istio-lab20/lab-original/peerauthentication.yaml
./istio-lab20/pki/backend-sa.crt
./istio-lab20/pki/ca.crt
./istio-lab20/pki/database-sa.crt
./istio-lab20/pki/default.crt
./istio-lab20/pki/frontend-sa.crt
./istio-lab20/results/SIMULATED.md
./istio-lab20/results/bug-curl-in-images.txt
./istio-lab20/results/elapsed.txt
./istio-lab20/results/image-pull.txt
./istio-lab20/results/kubeconform-fixed.txt
./istio-lab20/results/task-istioctl-commands.txt
./istio-lab20/results/task2-strict-mtls.txt
./istio-lab20/results/task3-matrix.txt
./istio-lab20/results/task3-policies-applied.txt
./istio-lab20/results/task4.2-denied-body.txt
./istio-lab20/results/task4.5-backend-access-log.txt
./istio-lab20/results/task4.7-temp-block.txt
./istio-lab20/results/tools.txt
./istio-lab20/results/validate-lab-allow-frontend.txt
```
