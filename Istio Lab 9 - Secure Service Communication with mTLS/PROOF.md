# Istio Lab 9 - Secure Service Communication with mTLS - completion proof
Completed (UTC): 2026-11-11 14:56:28 | EC2: i-041ca753312e34184 | host: ip-172-31-10-45 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Istio Lab 9 - Secure Service Communication with mTLS, 2026-11-11 14:56:20 UTC) - CLUSTER/ISTIOD SIMULATED, mTLS + RBAC + ENVOY REAL ==========
PASS: Setup: istioctl 1.32.0 + proxyv2; fixed manifests (SAs, PeerAuthentication v1, AuthorizationPolicy v1) schema-valid
PASS: Lab bug: unquoted heredoc expands $(hostname) on the workstation (ConfigMap gets 'ip-172-31-10-45')
PASS: Lab bug: 'istioctl authn tls-check' not in istioctl 1.32.0; replacements (x describe, proxy-config secret, x authz check) available
PASS: Workload certs: SPIFFE URI SANs, 1-day validity, chain verifies to the mesh CA
PASS: Task 4 STRICT: sidecar (mTLS) GET 200; server cert spiffe .../sa/backend verified; no-sidecar plaintext rejected
PASS: Task 4.3: inbound Envoy ssl stats count successful handshakes
PASS: Task 5.3 PERMISSIVE: plaintext 200 and mTLS 200 on the same port
PASS: Lab bug: lab AuthorizationPolicy (2 OR'ed rules) lets sa/attacker GET (200) and plaintext GET in PERMISSIVE (200)
PASS: Fixed policy: sa/frontend GET 200; sa/default and sa/attacker 403; DELETE 403; plaintext 403
PASS: Denied requests return Envoy RBAC 'access denied'
PASS: Lab bug: /etc/ssl/certs in proxyv2 holds system CAs, no SPIFFE cert; live sidecar cert is in memory (served via admin/SDS)
PASS: Time: finished in 28s (<= 300s)
CORE: 12/12 PASS
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
./istio-lab9/envoy/gen.py
./istio-lab9/envoy/inbound-authz-FIXED-permissive.yaml
./istio-lab9/envoy/inbound-authz-FIXED-strict.yaml
./istio-lab9/envoy/inbound-authz-LAB-permissive.yaml
./istio-lab9/envoy/inbound-authz-LAB-strict.yaml
./istio-lab9/envoy/inbound-permissive.yaml
./istio-lab9/envoy/inbound-strict.yaml
./istio-lab9/envoy/outbound-attacker.yaml
./istio-lab9/envoy/outbound-default.yaml
./istio-lab9/envoy/outbound-frontend.yaml
./istio-lab9/k8s/apps.yaml
./istio-lab9/k8s/backend-policy.yaml
./istio-lab9/k8s/peerauthentication-default.yaml
./istio-lab9/k8s/peerauthentication-istio-system.yaml
./istio-lab9/lab-original/backend-configmap-as-applied.yaml
./istio-lab9/lab-original/backend-policy.yaml
./istio-lab9/lab-original/peerauthentication-default.yaml
./istio-lab9/lab-original/peerauthentication-istio-system.yaml
./istio-lab9/pki/attacker.crt
./istio-lab9/pki/backend.crt
./istio-lab9/pki/ca.crt
./istio-lab9/pki/ca.srl
./istio-lab9/pki/default.crt
./istio-lab9/pki/frontend.crt
./istio-lab9/results/SIMULATED.md
./istio-lab9/results/bug-etc-ssl-certs.txt
./istio-lab9/results/bug-hostname-heredoc.txt
./istio-lab9/results/elapsed.txt
./istio-lab9/results/image-pull.txt
./istio-lab9/results/kubeconform-fixed.txt
./istio-lab9/results/task2-istioctl-commands.txt
./istio-lab9/results/task3.2-authz.txt
./istio-lab9/results/task3.2-denied-body.txt
./istio-lab9/results/task4-strict.txt
./istio-lab9/results/task4.2-workload-certs.txt
./istio-lab9/results/task5.3-permissive.txt
./istio-lab9/results/tools.txt
```
