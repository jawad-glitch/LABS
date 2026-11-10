# Simulated - Istio Lab 2 - Istio Architecture and Components
NOT executed: kind cluster, istiod xDS push, proxy-status/proxy-config against live pods.
Real: istioctl 1.32.0 render + kube-inject, real istio/pilot + istio/proxyv2 images (tool availability), real Envoy (from proxyv2) as a sidecar sharing nginx's netns with a static config mirroring istiod's inbound listener/cluster; admin API + access-log behaviour.
Full mode: full-mode.sh
