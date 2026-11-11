# Simulated - Istio Lab 8 - Traffic Mirroring with Istio
NOT executed: minikube/kind cluster, istiod, sidecar injection, kubectl logs/run.
Real: productpage pods (docker.io/istio/examples-bookinfo-productpage-v1:1.17.0) v1+v2 with real Envoy inbound sidecars (access logs with authority + request id), Envoy 1.32.0 client sidecar and ingress gateway generated from the lab VirtualServices (mirror, mirrorPercentage, header/uri matches), percentages measured over 100 requests.
Full mode: kubectl apply -f k8s/ (gateway.yaml, destination-rule.yaml, one virtual-service-*.yaml, telemetry-access-log.yaml); scripts/count-mirroring.sh
