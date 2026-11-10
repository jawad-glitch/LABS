# Simulated - GitOps Lab 18 - Progressive Delivery with GitOps (Canary)
NOT executed: kind cluster, Argo CD, Argo Rollouts controller, ingress-nginx (fast mode).
Real: demo-app:v1.0..v4.0 images, kustomize base/overlay + Rollout/AnalysisTemplate CRD-schema validation, Application from argocd v3.6.1,
kubectl-argo-rollouts v1.10.2 plugin, ro.py = canary controller emulation on real containers with a real NGINX ingress (weights + X-Canary header),
web-provider analysis via real HTTP GETs evaluated with the template's successCondition/count/interval/failureLimit. Unbounded pauses are
manual promotes; timed pauses compressed to <=3s.
## Full-mode commands
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.6.1/manifests/install.yaml
kubectl create ns argo-rollouts; kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/download/v1.10.2/install.yaml
kind load docker-image demo-app:v1.0 demo-app:v2.0 demo-app:v3.0 demo-app:v4.0 --name gitops-lab
kubectl apply -f argocd/application.yaml && argocd app wait demo-app-canary --sync --timeout 300
kubectl argo rollouts get rollout demo-app -n production ; kubectl argo rollouts promote demo-app -n production
kubectl argo rollouts abort demo-app -n production ; git revert <v4 commit> && git push   # rollback through Git (undo is reverted by selfHeal)
