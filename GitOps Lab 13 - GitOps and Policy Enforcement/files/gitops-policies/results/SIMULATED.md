# Simulated - GitOps Lab 13 - GitOps and Policy Enforcement
NOT executed: kind cluster, Gatekeeper webhook/audit pods, kubectl apply/describe/logs (fast mode).
Real: Gatekeeper v3.23.1 policy engine via gator (templates compiled, constraints evaluated per manifest), CRD-schema validation,
real containers proving the hardened image runs under readOnlyRootFilesystem/non-root while the lab image does not.
## Full-mode commands
kind create cluster --name gitops-policy-lab
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/v3.23.1/deploy/gatekeeper.yaml
kubectl -n gatekeeper-system rollout status deploy/gatekeeper-controller-manager --timeout=300s && kubectl -n gatekeeper-system rollout status deploy/gatekeeper-audit --timeout=300s
kubectl apply -f policies/templates/ && for k in k8srequiredlabels k8scontainerlimits k8srequiresecuritycontext; do kubectl wait --for=condition=Established crd/$k.constraints.gatekeeper.sh --timeout=60s; done
kubectl apply -f policies/constraints/ && kubectl apply -f manifests/compliant/ && kubectl apply -f manifests/non-compliant/   # expect: admission webhook denied
