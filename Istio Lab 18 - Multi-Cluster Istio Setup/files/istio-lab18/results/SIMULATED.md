# Simulated - Istio Lab 18 - Multi-Cluster Istio Setup
NOT executed: 2 kind clusters (VM 3848 MiB < lab's 8 GiB), istiod x2, remote secrets / endpoint discovery, sidecar injection.
Real: two isolated pod networks + shared node network, go-httpbin pods per cluster, real Envoy 1.32.0 workload sidecars (mTLS, SPIFFE), east-west
gateway Envoy in ISTIO_MUTUAL and AUTO_PASSTHROUGH modes, cluster2 client sidecar (local + cross-network endpoints), OpenSSL PKI (separate roots vs
shared root + intermediates), istioctl 1.32.0 renders of the lab's and the correct east-west gateway install.
## Full mode (kind)
kubectl --context kind-clusterN create ns istio-system; kubectl apply -f k8s/clusterN/istio-system-namespace.yaml; create cacerts (k8s/clusterN/cacerts-secret.template.yaml)
istioctl install --set values.global.meshID=mesh1 --set values.global.multiCluster.clusterName=clusterN --set values.global.network=networkN -y
istioctl install -f k8s/clusterN/eastwest-gateway.yaml -y; kubectl apply -f k8s/clusterN/expose-services.yaml
istioctl create-remote-secret --context=kind-cluster1 --name=cluster1 --server=https://cluster1-control-plane:6443 | kubectl apply --context=kind-cluster2 -f -   (and vice versa)
