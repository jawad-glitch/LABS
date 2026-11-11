# Simulated - Istio Lab 6 - AB Testing with Istio
NOT executed: kind cluster, istiod, sidecar injection, ingress NodePort.
Real: nginx v1/v2 pods (2 each), Envoy 1.32.0 (istio/proxyv2) as ingress gateway and as in-mesh sidecar, configured from the VirtualServices by envoy/vs2envoy.py (gateway vs mesh binding, header matches, weighted subsets), lab scripts run as written, istioctl analyze offline, CRD-schema validation.
Full mode: kubectl apply -f k8s/ (one vs-gateway-* + matching vs-mesh-*), GATEWAY_URL from the ingressgateway NodePort, run scripts/test-ab-distribution.sh.
