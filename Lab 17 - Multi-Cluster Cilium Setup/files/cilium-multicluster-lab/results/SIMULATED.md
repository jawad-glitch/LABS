# Simulated steps - Lab 17 - Multi-Cluster Cilium Setup
NOT executed: two kind clusters (4 nodes), Cilium on each, clustermesh-apiservers + etcd, mesh connect, cross-cluster traffic,
connectivity test --multi-cluster. Measured well over 5 minutes and near the 3.8 GB memory limit on this VM.
Real in this run: CLI v0.20.2 help (flags/commands), Cilium chart 1.20.4 rendered for both clusters + schema validation, CIDR overlap check,
CRD-schema rejection of the lab policy, selector evaluation of lab vs fixed policy, chart evidence for MCS-API (clusterset.local).

## Full-mode commands
sudo kind create cluster --config fixed/cluster1-config.yaml & sudo kind create cluster --config fixed/cluster2-config.yaml & wait
helm install cilium cilium/cilium --version 1.20.4 -n kube-system -f fixed/cilium-values-cluster1.yaml --kube-context kind-cluster1
helm install cilium cilium/cilium --version 1.20.4 -n kube-system -f fixed/cilium-values-cluster2.yaml --kube-context kind-cluster2
cilium status --wait --context kind-cluster1 ; cilium status --wait --context kind-cluster2
cilium clustermesh connect --context kind-cluster1 --destination-context kind-cluster2
cilium clustermesh status --context kind-cluster1 --wait
kubectl --context kind-cluster1 apply -f fixed/app-cluster1.yaml ; kubectl --context kind-cluster2 apply -f fixed/app-cluster2.yaml
for i in $(seq 1 10); do kubectl --context kind-cluster1 exec test-connectivity -- curl -s web-service; done   # expect cluster=cluster1 and cluster=cluster2
kubectl --context kind-cluster1 apply -f fixed/cross-cluster-policy.yaml ; kubectl --context kind-cluster2 apply -f fixed/cross-cluster-policy.yaml
kubectl --context kind-cluster1 exec unauthorized-test -- curl -s --max-time 5 web-service || echo blocked
kubectl --context kind-cluster1 -n kube-system exec ds/cilium -- cilium-dbg service list    # (not 'cilium service list')
cilium connectivity test --context kind-cluster1 --multi-cluster kind-cluster2 --test no-policies
