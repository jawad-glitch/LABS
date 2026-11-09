# Simulated steps (fast mode) - Lab 9 - Argo Rollouts Installation
No cluster ran. Real: release install.yaml v1.10.2 (inventory + schema validation), test Rollout validated against the Rollout CRD schema, CLI v1.10.2, nginx:1.27-alpine served locally.

| Lab step | Full-mode command | This run |
|---|---|---|
| 1.x cluster | kind create cluster --name rollouts; kubectl get nodes | none |
| 2.1 install | kubectl apply -f namespace-argo-rollouts.yaml; kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/download/v1.10.2/install.yaml | validated + inventoried |
| 2.2 watch | kubectl -n argo-rollouts rollout status deploy/argo-rollouts --timeout=180s (not -w) | n/a |
| 4.1 logs | kubectl -n argo-rollouts logs deploy/argo-rollouts --tail=100 (not -f) | n/a |
| 4.3 test | kubectl create ns rollouts-demo --dry-run=client -o yaml \| kubectl apply -f - ; kubectl apply -f test-rollout.yaml | CRD-schema validated |
| 4.4 pods | kubectl get rollouts,pods -n rollouts-demo | same image served in a local container |
| 5.2 CLI | kubectl argo rollouts get rollout test-rollout -n rollouts-demo | version + help captured |
| cleanup | kubectl delete ns rollouts-demo; (full uninstall) kubectl delete -f install.yaml | n/a |
