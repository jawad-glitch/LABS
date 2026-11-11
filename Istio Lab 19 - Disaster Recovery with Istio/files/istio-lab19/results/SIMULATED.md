# Simulated - Istio Lab 19 - Disaster Recovery with Istio
NOT executed: kind cluster, istiod, sidecar injection, kubectl apply/patch (emulated by envoy/apply-vs.sh: VS+DR -> regenerated gateway).
Real: nginx bookstore pods v1 x3 / v2 x3 with the lab's exact pages, Envoy 1.32.0 ingress gateway generated from every VirtualService and
DestinationRule (subsets, weights, header match, fault abort, outlier detection), real HTTP results, lab disaster-recovery.sh run as written
(kubectl stubbed and recorded), fixed script with a real rollback, nested ConfigMap mount tested with the real container runtime.
## Full mode
kubectl apply -f k8s/gateway.yaml -f k8s/dr-circuit-breaker.yaml -f k8s/vs-v1.yaml ; v2 with k8s/nginx-v2-failing.conf (ConfigMap -> /etc/nginx/conf.d)
ROLLBACK_CMD="kubectl apply -f k8s/vs-v1.yaml" scripts/disaster-recovery.sh $GATEWAY_URL
