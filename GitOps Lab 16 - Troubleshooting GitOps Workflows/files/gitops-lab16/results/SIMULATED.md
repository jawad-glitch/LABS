# Simulated - GitOps Lab 16 - Troubleshooting GitOps Workflows
NOT executed: kind cluster, Argo CD server/controller/repo-server, kubectl against a cluster (fast mode).
Real: Git branches/conflict/resolution, smart-HTTP remote, Application from argocd v3.6.1, kustomize builds, reconcile.py (webapp-dev) on real
nginx:1.20 containers (drift + selfHeal, ComparisonError, scheduling against real node capacity 2 CPU/3848 Mi, ImagePullBackOff, prune).
## Full-mode commands
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.6.1/manifests/install.yaml
kubectl -n argocd wait --for=condition=available deploy --all --timeout=300s
kubectl apply -f argocd-application.yaml && argocd app wait webapp-dev --sync --health --timeout 180
kubectl -n dev scale deploy dev-webapp --replicas=5; for i in $(seq 1 30); do [ "$(kubectl -n dev get deploy dev-webapp -o jsonpath={.spec.replicas})" = 1 ] && break; sleep 2; done
kubectl -n argocd logs statefulset/argocd-application-controller --tail=50 | grep -i webapp-dev
