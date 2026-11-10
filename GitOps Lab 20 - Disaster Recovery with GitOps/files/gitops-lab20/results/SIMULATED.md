# Simulated - GitOps Lab 20 - Disaster Recovery with GitOps
NOT executed: k3s, Argo CD server/controller (fast mode; ~600 MB of images + k3s exceed the 5-minute budget).
Real: Git repo/tags/revert, smart-HTTP remote, Application from argocd v3.6.1 (CRD-valid), autonomous reconciliation daemon
(argocd-sim-controller.py: Git poll every ~2s + selfHeal) driving real nginx pods, timed disaster scenarios A/B, broken release + revert,
dr-validate.sh (BACKEND=docker here; BACKEND=kubectl in full mode).
Note: real Argo CD heals live drift within seconds (selfHeal) but picks up NEW Git commits on its 3-minute poll unless refreshed/webhooked.
## Full-mode commands
curl -sfL https://get.k3s.io -o k3s-install.sh && less k3s-install.sh && sudo INSTALL_K3S_VERSION=<pinned> sh k3s-install.sh
kubectl create ns argocd && kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.6.1/manifests/install.yaml
kubectl -n argocd wait --for=condition=available deploy --all --timeout=300s && kubectl -n argocd rollout status sts/argocd-application-controller --timeout=300s
kubectl apply -f argocd/application.yaml && argocd app wait sample-web-app --sync --health --timeout 300
t0=$(date +%s); kubectl -n sample-app delete deploy web-app; until [ "$(kubectl -n sample-app get deploy web-app -o jsonpath={.status.readyReplicas} 2>/dev/null)" = 3 ]; do sleep 1; done; echo "scenario-a-deployment-deletion: $(($(date +%s)-t0))" >> ~/recovery-times.txt
BACKEND=kubectl bash dr-validate.sh; echo "Exit code: $?"
