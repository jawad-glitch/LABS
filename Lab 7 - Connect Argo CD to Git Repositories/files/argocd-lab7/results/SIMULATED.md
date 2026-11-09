# Simulated steps (fast mode) - Lab 7 - Connect Argo CD to Git Repositories
Git mode: **local** (github = real repo github.com/jawad-glitch/argocd-demo-app; local = bare remote on this VM because the token cannot create/push that repo).
No Kubernetes cluster / Argo CD server ran. Real: git workflow, kubeconform (K8s + Argo CD Application CRD schemas), argocd CLI v3.6.1 generate-spec, nginx container serving v1/v2.

| Lab step | Real command (full mode) | This run |
|---|---|---|
| 2.1 login | argocd login localhost:8080 --username admin --password "$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' \| base64 -d)" --insecure | not run |
| 2.2 repo add | argocd repo add https://github.com/jawad-glitch/argocd-demo-app.git --type git --name demo-repo | flags verified via --help |
| 2.3 refresh | argocd repo get https://github.com/jawad-glitch/argocd-demo-app.git --refresh hard  (lab omitted the required value) | --help captured |
| 3.1 CLI app | argocd app create demo-nginx-app --repo https://github.com/jawad-glitch/argocd-demo-app.git --path k8s-manifests --dest-server https://kubernetes.default.svc --dest-namespace demo-app --sync-policy automated --auto-prune --self-heal | same flags -> argocd app generate-spec (real CLI) |
| 3.2 YAML app | argocd app delete demo-nginx-app --yes (avoid two apps owning same resources); kubectl apply -f argocd-application.yaml | schema-validated against Application CRD |
| 3.3 sync/wait | argocd app sync demo-nginx-yaml; argocd app wait demo-nginx-yaml --health --timeout 120 | desired state listed from manifests |
| 3.5 watch | argocd app wait demo-nginx-yaml --sync --health --timeout 180 (not watch) | v2 pushed + diff + remote verified |
| verify | nohup kubectl port-forward -n demo-app svc/nginx-demo-service 8081:80 & curl localhost:8081 | same image + same configmap content served locally |
