# Simulated - GitOps Lab 2 - Install Argo CD
NOT executed: cluster, pods Running, port-forward, browser UI and login (no cluster created, per the 5-minute fast mode).
Real in this run: helm v3.22.1+gd6c1a0e + argo repo, chart argo/argo-cd 10.17.1 rendered and schema-checked, argocd CLI v3.6.1 (sha256),
inventory of components/Services/hooks/secrets, bcrypt admin hash + RBAC rendered via Helm values.

## Full-mode commands (bounded, non-interactive)
kubectl cluster-info && kubectl get nodes
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
helm upgrade --install argocd argo/argo-cd --version 10.17.1 -n argocd -f fixed/argocd-values.yaml --wait --timeout 5m
kubectl -n argocd wait --for=condition=available deploy --all --timeout=300s
kubectl -n argocd rollout status statefulset/argocd-application-controller --timeout=300s
nohup kubectl port-forward svc/argocd-server -n argocd 8080:443 > pf.log 2>&1 < /dev/null & disown
argocd admin initial-password -n argocd          # only if no admin hash was set via values
argocd login localhost:8080 --username admin --insecure   # prompts for the password (not on the command line)
kubectl get endpoints -n argocd
