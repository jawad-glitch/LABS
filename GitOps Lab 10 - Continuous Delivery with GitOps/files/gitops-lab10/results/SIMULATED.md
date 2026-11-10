# Simulated - GitOps Lab 10 - Continuous Delivery with GitOps
NOT executed: kind cluster, Argo CD install/UI, port-forwards, Ingress (no ingress controller in the lab anyway) - fast mode.
Real: CI pipeline (kustomize build + kubeconform + version bump + push) x3, smart-HTTP remote, Application from argocd CLI v3.6.1,
reconcile.py on real nginx pods (configMapGenerator-driven rollouts, broken image -> Degraded, git revert recovery).
## Full-mode commands
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.6.1/manifests/install.yaml
kubectl -n argocd wait --for=condition=available deploy --all --timeout=300s && kubectl apply -f argocd-application.yaml
./ci-pipeline.sh "msg" && argocd app get gitops-demo-app --refresh && argocd app wait gitops-demo-app --sync --health --timeout 180
nohup kubectl port-forward svc/gitops-demo-service 3000:80 >pf.log 2>&1 </dev/null & disown; curl -s localhost:3000 | grep Version
