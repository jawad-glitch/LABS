# Simulated - GitOps Lab 7 - Deploy Application with Flux
NOT executed: kind cluster, flux check/install pods, controller logs, Service ClusterIP, port-forward (fast mode).
Real: flux v2.10.0 CLI + real CRDs (served versions, url pattern), Git repo + bare remote served over smart HTTP, GitRepository/Kustomization v1 from
'flux create --export', reconcile.py (source+kustomize controller emulation) on real nginx containers, busybox connectivity test.
## Full-mode commands
kind create cluster --name flux-lab && flux check --pre && flux install && kubectl -n flux-system wait --for=condition=available deploy --all --timeout=300s
(serve the bare repo where pods can reach it, e.g. an in-cluster git server or GitHub https URL)
kubectl apply -f flux-system/gitrepository.yaml -f flux-system/kustomization.yaml
flux reconcile kustomization nginx-app --with-source && kubectl rollout status deploy/nginx-deployment --timeout=120s
kubectl run test-pod --image=busybox:1.36 --rm -i --restart=Never -- wget -qO- nginx-service
