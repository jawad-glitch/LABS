# Simulated - Istio Lab 20 - Istio in a Zero-Trust Architecture
NOT executed: cluster, istiod (CA/SDS, xDS), sidecar injection, kubectl exec.
Real: lab images (nginx:1.21 frontend/database, httpd:2.4 backend) behind real Envoy 1.32.0 inbound sidecars (STRICT mTLS, SPIFFE certs from an
OpenSSL mesh CA), AuthorizationPolicies translated to Envoy RBAC with Istio semantics (selector scoping, ALLOW rules OR'ed, empty ALLOW = deny,
DENY first), real client sidecars per ServiceAccount identity, no-sidecar plaintext client, istioctl 1.32.0 command checks and validate.
## Full mode
kubectl apply -f k8s/peerauthentication-mesh.yaml -f k8s/workloads.yaml -f k8s/deny-all.yaml -f k8s/frontend-to-backend.yaml -f k8s/backend-to-database.yaml -f k8s/allow-frontend-access.yaml
istioctl x authz check deploy/backend -n zero-trust-demo ; istioctl proxy-config secret deploy/frontend -n zero-trust-demo
kubectl exec -n zero-trust-demo curl-backend-identity -- curl -s -o /dev/null -w '%{http_code}' http://database/
