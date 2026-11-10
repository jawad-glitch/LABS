# Simulated - GitOps Lab 14 - GitOps Rollback with Git History
NOT executed: kind cluster, Argo CD server/CLI login, port-forward (fast mode).
Real: Git history (tags, revert, lab merge no-op, tree-restore rollback, reset/force-push demo), smart-HTTP remote, Application from argocd v3.6.1,
reconcile.py on real nginx 1.20/1.21 containers with a live-updated ConfigMap file, kubeconform validation gate.
## Full-mode commands
kind create cluster --name gitops-lab --wait 120s
kubectl create ns argocd; kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.6.1/manifests/install.yaml
kubectl -n argocd wait --for=condition=available deploy --all --timeout=300s && kubectl -n argocd rollout status sts/argocd-application-controller --timeout=300s
kubectl apply -f application.yaml   # repoURL must be reachable from repo-server (not file://)
for i in $(seq 1 36); do s=$(kubectl get app sample-app -n argocd -o jsonpath='{.status.sync.status} {.status.health.status}'); echo "$s"; [ "$s" = "Synced Healthy" ] && break; sleep 5; done
