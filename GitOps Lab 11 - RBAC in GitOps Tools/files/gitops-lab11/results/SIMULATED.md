# Simulated - GitOps Lab 11 - RBAC in GitOps Tools
NOT executed: Argo CD server/UI/CLI logins + local users (policy evaluated offline by argocd v3.6.1's own RBAC engine instead), Flux controllers.
Real: kind cluster (API server) with Flux CRDs; lab vs fixed RBAC applied and checked with kubectl auth can-i and real ServiceAccount tokens;
Flux sources/Kustomizations validated by the API server (dry-run=server); example repo paths checked by cloning.
## Full-mode commands
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.6.1/manifests/install.yaml
kubectl apply -f argocd/argocd-rbac-cm.yaml -f argocd/argocd-cm-users.yaml
argocd account update-password --account alice   # prompts (no passwords on the command line)
argocd login localhost:8080 --username charlie --insecure && argocd app sync test-nginx   # expect: permission denied
flux install && kubectl apply -f flux-fixed/
