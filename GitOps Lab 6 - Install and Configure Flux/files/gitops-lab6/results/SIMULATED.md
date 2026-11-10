# Simulated - GitOps Lab 6 - Install and Configure Flux
NOT executed: kind cluster, flux check --pre/check, controller pods, logs/events (fast mode).
Real: flux v2.10.0 CLI (sha256), 'flux install --export' manifests/CRDs, GitRepository + Kustomization from 'flux create --export', git:// source,
reconcile.py = source-controller + kustomize-controller emulation on real nginx containers (scale, drift, cleanup order).
## Full-mode commands
flux check --pre && flux install && kubectl -n flux-system wait --for=condition=available deploy --all --timeout=300s && flux check
kubectl apply -f flux-system/gitrepository.yaml -f flux-system/kustomization.yaml
flux reconcile kustomization nginx-demo --with-source && kubectl -n default rollout status deploy/nginx-demo --timeout=120s
# after pushing the scale commit:
flux reconcile kustomization nginx-demo --with-source && kubectl -n default wait --for=jsonpath='{.status.readyReplicas}'=3 deploy/nginx-demo --timeout=120s
kubectl logs -n flux-system deploy/kustomize-controller --tail=20
# private repo: flux create secret git flux-ssh --url=ssh://git@github.com/USER/private-repo --private-key-file=$HOME/.ssh/flux-ed25519
# cleanup (correct order): flux delete kustomization nginx-demo -s ; flux delete source git flux-gitops-demo -s ; flux uninstall -s
