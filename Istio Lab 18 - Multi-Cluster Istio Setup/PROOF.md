# Istio Lab 18 - Multi-Cluster Istio Setup - completion proof
Completed (UTC): 2026-11-11 20:23:07 | EC2: i-0aafd3b051371cd3a | host: ip-172-31-10-233 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Istio Lab 18 - Multi-Cluster Istio Setup, 2026-11-11 20:23:00 UTC) - CLUSTERS/ISTIOD SIMULATED, NETWORKS + mTLS + GATEWAY + ENVOY REAL ==========
PASS: Task 1: VM resources recorded vs lab's 8 GiB / 4-core requirement; istioctl 1.32.0 + images ready
PASS: Lab bug: '.bashrc' gets a literal $PWD - istioctl path depends on the login directory
PASS: Lab bug: '--set values.gateways.istio-eastwestgateway.enabled=true' renders no east-west gateway
PASS: Fixed: IstioOperator ingressGateways[istio-eastwestgateway] renders the Deployment; create-remote-secret available
PASS: Fixed manifests (network labels, AUTO_PASSTHROUGH Gateway, same-name httpbin, topology subsets) schema-valid
PASS: PKI: shared root + per-cluster intermediates verify; lab's separate roots do not cross-verify
PASS: Lab bug: cluster2 cannot resolve/reach cluster1's Service or pods (.global ServiceEntry endpoint unusable)
PASS: Lab bug (no shared cacerts): cross-cluster mTLS fails with separate roots (HTTP 503)
PASS: Lab bug (tls.mode ISTIO_MUTUAL): gateway presents its own identity -> client rejects (HTTP 503)
FAIL: Fixed (shared root + AUTO_PASSTHROUGH): cluster2 -> cluster1 HTTP 200 answered by httpbin-cluster1
PASS: End-to-end mTLS: cluster1 sidecar sees cluster2 client identity spiffe://.../sa/sleep; gateway only passed TLS through
FAIL: Task 7.2: one Service name load-balances across both clusters ()
PASS: Time: finished in 62s (<= 300s)
CORE: 11/13 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                         ID             DISK USAGE   CONTENT SIZE   EXTRA
busybox:1.36                  73aaf090f3d8       6.76MB         2.21MB        
istio/proxyv2:1.32.0          b8d47c6d8d6e        400MB         92.2MB        
mccutchen/go-httpbin:latest   873b4fdb27fe         21MB         5.55MB        
```

## Files
```
./istio-lab18/envoy/gen.py
./istio-lab18/envoy/lab-roots-c1-eastwestgateway.yaml
./istio-lab18/envoy/lab-roots-c1-inbound.yaml
./istio-lab18/envoy/lab-roots-c2-inbound.yaml
./istio-lab18/envoy/lab-roots-c2-sleep-sidecar.yaml
./istio-lab18/envoy/shared-istiomutual-c1-eastwestgateway.yaml
./istio-lab18/envoy/shared-istiomutual-c1-inbound.yaml
./istio-lab18/envoy/shared-istiomutual-c2-inbound.yaml
./istio-lab18/envoy/shared-istiomutual-c2-sleep-sidecar.yaml
./istio-lab18/envoy/shared-passthrough-c1-eastwestgateway.yaml
./istio-lab18/envoy/shared-passthrough-c1-inbound.yaml
./istio-lab18/envoy/shared-passthrough-c2-inbound.yaml
./istio-lab18/envoy/shared-passthrough-c2-sleep-sidecar.yaml
./istio-lab18/k8s/cluster1/cacerts-secret.template.yaml
./istio-lab18/k8s/cluster1/eastwest-gateway.yaml
./istio-lab18/k8s/cluster1/expose-services.yaml
./istio-lab18/k8s/cluster1/httpbin.yaml
./istio-lab18/k8s/cluster1/istio-system-namespace.yaml
./istio-lab18/k8s/cluster2/cacerts-secret.template.yaml
./istio-lab18/k8s/cluster2/destinationrule-httpbin.yaml
./istio-lab18/k8s/cluster2/eastwest-gateway.yaml
./istio-lab18/k8s/cluster2/expose-services.yaml
./istio-lab18/k8s/cluster2/httpbin.yaml
./istio-lab18/k8s/cluster2/istio-system-namespace.yaml
./istio-lab18/lab-original/serviceentry-global.yaml
./istio-lab18/pki/cluster1-ca.crt
./istio-lab18/pki/cluster1-chain.pem
./istio-lab18/pki/cluster2-ca.crt
./istio-lab18/pki/cluster2-chain.pem
./istio-lab18/pki/ewgw-c1.crt
./istio-lab18/pki/httpbin-c1.crt
./istio-lab18/pki/httpbin-c2.crt
./istio-lab18/pki/lab-httpbin-c1.crt
./istio-lab18/pki/lab-sleep-c2.crt
./istio-lab18/pki/root-ca.crt
./istio-lab18/pki/rootA.crt
./istio-lab18/pki/rootB.crt
./istio-lab18/pki/sleep-c2.crt
./istio-lab18/results/SIMULATED.md
./istio-lab18/results/bug-bashrc-pwd.txt
./istio-lab18/results/c1-httpbin-sidecar-access.log
./istio-lab18/results/elapsed.txt
./istio-lab18/results/image-pull.txt
./istio-lab18/results/kubeconform-fixed.txt
./istio-lab18/results/task-caseA-separate-roots.txt
./istio-lab18/results/task-caseB-istio-mutual.txt
./istio-lab18/results/task-caseC-passthrough.txt
./istio-lab18/results/task1-resources.txt
./istio-lab18/results/task3-pki.txt
./istio-lab18/results/task4-render.txt
./istio-lab18/results/task4.3-fixed-ew.err
./istio-lab18/results/task4.3-lab-ew.err
./istio-lab18/results/task6-dns-network.txt
./istio-lab18/results/task7.2-lb.txt
./istio-lab18/results/tools.txt
```
