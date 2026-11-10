# Simulated - GitOps Lab 9 - Multi-Environment GitOps with Argo CD
NOT executed: kind cluster, Argo CD install/UI/CLI login, kubectl against a cluster (fast mode).
Real: branch workflow, bare remote over smart HTTP, Applications from argocd CLI v3.6.1 (CRD-valid), reconcile.py per app (branch tracking,
auto vs manual sync, failed rollout keeps old pods, revert recovery) on real nginx containers serving each branch's page.
## Full-mode commands
kind create cluster --name gitops-lab   # hostPort 8090/8443, not 8080
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.6.1/manifests/install.yaml
kubectl -n argocd wait --for=condition=available deploy --all --timeout=300s && kubectl -n argocd rollout status sts/argocd-application-controller --timeout=300s
kubectl apply -f argocd-apps/ && argocd app wait gitops-app-dev gitops-app-stage --sync --health --timeout 180 && argocd app sync gitops-app-prod
git push origin dev && argocd app get gitops-app-dev --refresh && argocd app wait gitops-app-dev --sync --health --timeout 180
