# Simulated - Istio Lab 3 - Deploy a Simple Application with Istio
NOT executed: kind cluster, istiod, sidecar injection, NodePort ingress.
Real: hello-app images (gcr.io/google-samples/hello-app:1.0 / gcr.io/google-samples/hello-app:2.0) as pods on a shared network (Service DNS = alias), Envoy 1.32.0 from istio/proxyv2 as the ingress gateway configured from the VirtualService routes + DestinationRule LB policies, istioctl analyze (offline), CRD-schema validation.
Full mode: full-mode.sh
