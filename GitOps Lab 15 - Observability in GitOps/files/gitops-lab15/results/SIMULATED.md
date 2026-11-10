# Simulated - GitOps Lab 15 - Observability in GitOps
SIMULATED: kind cluster, Argo CD components. Argo CD metrics come from exporter/argocd-metrics-sim.py (Argo CD metric names/labels,
driven by a healthy -> degraded/failing-sync scenario).
REAL: Prometheus v3.16.0 (scrape, loaded rules, alert states), promtool checks, Grafana v13.3.0 with provisioned datasource + dashboard and a panel
query through Grafana's API, Argo CD v3.6.1 install.yaml analysis (controller kind, shipped metrics Services, cmd-params keys).
## Full-mode commands
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.6.1/manifests/install.yaml
kubectl -n argocd wait --for=condition=available deploy --all --timeout=300s && kubectl -n argocd rollout status statefulset/argocd-application-controller --timeout=300s
# scrape argocd-metrics:8082, argocd-server-metrics:8083, argocd-repo-server:8084 (k8s-fixed/prometheus-scrape-argocd.yml); mount rules + Grafana provisioning
