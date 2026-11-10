# Simulated - GitOps Lab 8 - Use Kustomize for Configuration Management
NOT executed: kind cluster, Flux controllers, Postgres pods, kubectl get/describe/exec against a cluster, events (fast mode).
Real: kustomize builds (lab-as-written and fixed), flux create --export objects + CRD validation, smart-HTTP Git source (and the lab's
python http.server failing), webapp tier of each env as nginx containers built from the rendered spec (env, memory limit, probe paths).
## Full-mode commands
kind create cluster --name kustomize-lab && flux install && kubectl -n flux-system wait --for=condition=available deploy --all --timeout=300s
kubectl apply -f flux/flux-source.yaml -f flux/flux-namespaces-kustomization.yaml -f flux/flux-dev-kustomization.yaml -f flux/flux-staging-kustomization.yaml -f flux/flux-prod-kustomization.yaml
flux reconcile kustomization namespaces --with-source; for k in development staging production; do flux reconcile kustomization $k; done
kubectl get deploy dev-webapp -n development -o jsonpath='{.spec.replicas}'   # by NAME, not .items[0]
