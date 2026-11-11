# Simulated - Istio Lab 9 - Secure Service Communication with mTLS
NOT executed: cluster, istiod (CA + SDS push), sidecar injection, kubectl exec.
Real: OpenSSL mesh CA + SPIFFE workload certs (24h), nginx backend with a real Envoy 1.32.0 inbound sidecar (STRICT / PERMISSIVE via TLS inspector),
AuthorizationPolicies translated to the Envoy RBAC filter as Istio does (rules OR'ed; from -> authenticated principal spiffe://..., to -> :method),
real Envoy client sidecars with sa/default, sa/frontend, sa/attacker identities, a no-sidecar plaintext client, openssl s_client handshakes.
## Full mode
kubectl apply -f k8s/apps.yaml -f k8s/peerauthentication-istio-system.yaml -f k8s/backend-policy.yaml
istioctl x describe pod <backend-pod>; istioctl proxy-config secret <backend-pod>; istioctl x authz check <backend-pod>
