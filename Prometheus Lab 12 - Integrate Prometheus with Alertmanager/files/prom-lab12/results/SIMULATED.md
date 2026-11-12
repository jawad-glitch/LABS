# Simulated - Prometheus Lab 12 - Integrate Prometheus with Alertmanager
NOT executed: kind cluster, Prometheus Operator, helm install (cold kind + kube-prometheus-stack exceeds the 5-minute budget on this VM).
Real: helm v4.3.1 rendering kube-prometheus-stack 93.2.2 (default vs fixed values), kubeconform on every manifest (incl. PrometheusRule CRD),
amtool on the lab-style and fixed configs, Alertmanager v0.27.0 with the lab routing/inhibition and file-mounted Secret values on :30093,
Prometheus on :30090 loading the PrometheusRule groups (Operator step emulated: spec.groups -> rule files), node-exporter, a Slack-compatible
webhook receiving real payloads, a real SMTP attempt to smtp.gmail.com:587 with placeholder credentials.
Docker network alias alertmanager.monitoring.svc.cluster.local stands in for the Service DNS name.
## Full mode
kind create cluster --config k8s/kind-cluster-config.yaml
helm install kps prometheus-community/kube-prometheus-stack -n monitoring --create-namespace -f k8s/kps-values.yaml
kubectl apply -f k8s/   # Secret (real values), ConfigMap, Deployment, Service, PrometheusRules
