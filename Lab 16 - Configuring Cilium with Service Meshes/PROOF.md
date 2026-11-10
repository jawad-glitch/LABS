# Lab 16 - Configuring Cilium with Service Meshes - completion proof
Completed (UTC): 2026-11-10 07:22:56 | EC2: i-0ece0d583d92a6fef | host: ip-172-31-10-44 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 16 - Configuring Cilium with Service Meshes, 2026-11-10 07:22:50 UTC) - RUNTIME SIMULATED ==========
PASS: Tools: helm v3, cilium CLI v0.20.2, istioctl 1.32.0, kubeconform installed (sha256 verified; no curl|sh)
PASS: Lab bug: lab Cilium flags (kubeProxyReplacement=strict, tunnel=vxlan) rejected by current chart 1.20.4
PASS: Task 2 fixed: Cilium 1.20.4 renders with KPR true, socket LB host-ns-only + cni.exclusive false (Istio mode), vxlan tunnel, Hubble; schema-valid
PASS: Task 3: Istio 1.32.0 default profile rendered offline - istiod + istio-ingressgateway, schema-valid
PASS: Lab bug: gateway pods are app=istio-ingressgateway (no app=istio-proxy); control plane is istiod:15012 (no istio-pilot)
PASS: Lab bug: original CNP egress has no DNS and no istiod:15012 (mesh would break); fixed CNP allows gateway, DNS, istiod, backends:9080
PASS: Task 5: official Bookinfo from Istio 1.32.0 release (images newer than lab 1.17.0), productpage/details/ratings/reviews present
PASS: Tasks 5-9: Bookinfo, Gateway, VirtualServices, DestinationRules, PeerAuthentication STRICT, AuthorizationPolicy, CNP valid vs CRD schemas (strict)
PASS: Task 10: istioctl analyze (offline) reports no errors on the mesh config
PASS: Lab bug: cilium hubble observe is not a cilium CLI command (use hubble observe)
PASS: Time: finished in 28s (<= 300s); runtime steps documented in SIMULATED.md
CORE: 11/11 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./cilium-lab16/fixed/authorization-policy.yaml
./cilium-lab16/fixed/bookinfo-app.yaml
./cilium-lab16/fixed/bookinfo-gateway.yaml
./cilium-lab16/fixed/cilium-network-policy.yaml
./cilium-lab16/fixed/cilium-rendered.yaml
./cilium-lab16/fixed/cilium-values.yaml
./cilium-lab16/fixed/destination-rules.yaml
./cilium-lab16/fixed/istio-default-profile.yaml
./cilium-lab16/fixed/kind-config.yaml
./cilium-lab16/fixed/peer-authentication.yaml
./cilium-lab16/fixed/reviews-virtualservice.yaml
./cilium-lab16/lab-original/cilium-mesh-config.yaml
./cilium-lab16/lab-original/cilium-network-policy.yaml
./cilium-lab16/results/SIMULATED.md
./cilium-lab16/results/bug-cilium-hubble-observe.txt
./cilium-lab16/results/bug-istio-pilot-service-count.txt
./cilium-lab16/results/bug-lab-cilium-flags-render.txt
./cilium-lab16/results/elapsed.txt
./cilium-lab16/results/install-cilium-cli.log
./cilium-lab16/results/install-helm.log
./cilium-lab16/results/install-istio.log
./cilium-lab16/results/install-kubeconform.log
./cilium-lab16/results/task10-istioctl-analyze.txt
./cilium-lab16/results/task2.1-3.1-versions.txt
./cilium-lab16/results/task2.2-cilium-config-keys.txt
./cilium-lab16/results/task2.2-cilium-kubeconform.txt
./cilium-lab16/results/task2.2-fixed-render.err
./cilium-lab16/results/task3.2-istio-generate.err
./cilium-lab16/results/task3.2-istio-inventory.txt
./cilium-lab16/results/task3.2-istio-kubeconform.txt
./cilium-lab16/results/task5-9-mesh-kubeconform.txt
./cilium-lab16/results/task5.1-bookinfo-images.txt
./cilium-lab16/results/task7.1-cnp-analysis.txt
./cilium-lab16/results/task8-cilium-hubble-subcommands.txt
./cilium-lab16/results/versions.txt
```
