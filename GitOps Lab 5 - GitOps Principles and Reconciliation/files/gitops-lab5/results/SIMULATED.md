# Simulated - GitOps Lab 5 - GitOps Principles and Reconciliation
NOT executed: kind cluster, Argo CD controller/server/repo-server, kubectl rollout/events, Argo CD UI (fast mode).
Emulated with REAL components: reconciler.py = Argo CD controller loop (clone over git:// -> kustomize build -> converge); pods = nginx containers
(image/env/limits enforced by Docker); self-heal = reconcile after manual drift.
## Full-mode commands
kind create cluster --name gitops-lab (extraPortMappings hostPort 8090/8443 - NOT 8080)
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.6.1/manifests/install.yaml
kubectl -n argocd wait --for=condition=available deploy --all --timeout=300s && kubectl -n argocd rollout status sts/argocd-application-controller --timeout=300s
(serve repo in-cluster or GitHub; NOT file://) ; kubectl apply -f argocd-apps/demo-app.yaml
argocd app get demo-app --refresh && argocd app wait demo-app --sync --health --timeout 180
kubectl -n demo-app scale deploy demo-app --replicas=1 ; for i in $(seq 1 30); do [ "$(kubectl -n demo-app get deploy demo-app -o jsonpath={.spec.replicas})" = 4 ] && break; sleep 2; done
kubectl logs -n argocd statefulset/argocd-application-controller --tail=50
