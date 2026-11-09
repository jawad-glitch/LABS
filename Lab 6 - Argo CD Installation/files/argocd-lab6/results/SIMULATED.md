# Simulated steps (fast mode) - Lab 6 - Argo CD Installation
Fast mode: no Kubernetes cluster was started. Everything below needs a running cluster; the exact real commands are listed.
Real in this run: Helm v3.22.1+gd6c1a0e, argo repo + search, full render of argo/argo-cd 10.17.0 (Argo CD v3.6.1),
kubeconform schema validation of every rendered object, argocd CLI v3.6.1 (checksum), argocd account bcrypt, security values render.

| Lab step | Real command (full mode) | What this run did instead |
|---|---|---|
| 1.1 cluster status | kubectl cluster-info; kubectl get nodes | none (no cluster) |
| 1.2 namespace | kubectl create namespace argocd --dry-run=client -o yaml \| kubectl apply -f - | wrote namespace-argocd.yaml, schema-validated |
| 3.1 install | helm upgrade --install argocd argo/argo-cd -n argocd --version 10.17.0 --wait --timeout 5m | helm template (same chart, same values) |
| 3.2 watch pods | kubectl -n argocd rollout status deploy/argocd-server --timeout=180s (not -w) | inventory of rendered workloads |
| 4.1 admin password | kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" \| base64 -d | proved secret is NOT in chart (runtime-created); decode pipeline run on a simulated secret |
| 4.2 port-forward | nohup kubectl port-forward svc/argocd-server -n argocd 8080:443 >pf.log 2>&1 & | not run |
| 4.3 / 5.2 login | argocd login localhost:8080 --username admin --password "$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' \| base64 -d)" --insecure; argocd app list | CLI flags verified via --help |
| security | helm upgrade ... -f values-security.yaml (not kubectl patch) | rendered and verified argocd-cm / argocd-rbac-cm / argocd-secret |
