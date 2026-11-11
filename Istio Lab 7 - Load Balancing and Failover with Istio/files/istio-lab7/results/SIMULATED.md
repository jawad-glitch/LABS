# Simulated - Istio Lab 7 - Load Balancing and Failover with Istio
NOT executed: kind cluster, istiod, sidecar injection, kubectl exec loops, Prometheus in-cluster.
Real: bookinfo details pods (docker.io/istio/examples-bookinfo-details-v1:1.17.0) x3, Envoy 1.32.0 (istio/proxyv2) as client sidecar generated from each DestinationRule (+VS retries; Istio default retry policy when none), crashed-pod failover measured per request, Envoy /clusters + /stats, lab scripts run as written, prom/prometheus:latest run with the lab flags.
Full mode: kubectl apply -f k8s/ ; kubectl exec deploy/test-client -- curl ... ; istioctl proxy-config endpoint deploy/test-client --cluster "outbound|9080|v1|details.lab7-loadbalancing.svc.cluster.local"
