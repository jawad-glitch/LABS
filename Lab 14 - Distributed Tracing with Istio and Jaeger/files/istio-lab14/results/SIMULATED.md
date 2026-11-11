# Simulated - Lab 14 - Distributed Tracing with Istio and Jaeger
NOT executed: cluster, istiod, sidecar injection, kubectl port-forward.
Real: Jaeger all-in-one 1.50 (Zipkin :9411, query API/UI :16686), Bookinfo productpage/details/reviews v1-v3/ratings (1.17.0 images) calling each
other by service name, one Envoy 1.32.0 per service + ingress gateway Envoy (node.cluster = Istio service names) reporting Zipkin spans at 100%,
lab traffic + lab trace-pattern script, Jaeger API queries (services, traces, dependencies), istioctl 1.32.0 renders of the lab and fixed config.
## Full mode
istioctl install -f k8s/istio-tracing.yaml -y && kubectl apply -f k8s/telemetry-tracing.yaml
kubectl apply -n bookinfo -f https://raw.githubusercontent.com/istio/istio/release-1.32/samples/bookinfo/platform/kube/bookinfo.yaml ; scripts/restart-meshed-workloads.sh
