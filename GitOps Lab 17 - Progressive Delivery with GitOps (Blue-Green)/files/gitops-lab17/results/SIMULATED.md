# Simulated - GitOps Lab 17 - Progressive Delivery with GitOps (Blue-Green)
NOT executed: kind cluster, Argo CD server/UI/login (fast mode).
Real: repo layout + kustomize builds (schema-valid), 3 Applications from argocd v3.6.1, smart-HTTP remote, reconcile.py (Argo CD emulation) running
real nginx pods per environment with live ConfigMap content, a production nginx proxy resolving the ExternalName target by DNS, Git-driven
switch-traffic.sh (yq), validate-health.sh (HEALTH_BACKEND=docker here; kubectl in full mode), bad release + git revert.
## Full-mode commands
kind create cluster --name gitops-lab   # hostPort 8090 for :80 (8080 is used by the Argo CD port-forward)
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.6.1/manifests/install.yaml
kubectl -n argocd wait --for=condition=available deploy --all --timeout=300s
kubectl apply -f argocd-apps/ && argocd app wait sample-app-blue sample-app-green traffic-router --sync --health --timeout 300
./switch-traffic.sh green && kubectl run t --rm -i --restart=Never --image=busybox:1.36 -- wget -qO- http://production-service.default
./validate-health.sh blue
