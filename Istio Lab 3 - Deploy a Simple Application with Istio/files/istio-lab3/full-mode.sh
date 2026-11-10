#!/bin/bash
set -u
kubectl label ns default istio-injection=enabled --overwrite
kubectl apply -f k8s/ && kubectl rollout status deploy/hello-frontend deploy/hello-backend --timeout=180s
export INGRESS_HOST=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
export INGRESS_PORT=$(kubectl -n istio-system get svc istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
for p in / /frontend /backend; do curl -s -m 5 http://$GATEWAY_URL$p | grep -E 'Version|Hostname'; done
kubectl get gateways.networking.istio.io,virtualservices,destinationrules
istioctl analyze
kubectl exec -i deploy/hello-frontend -c istio-proxy -- pilot-agent request GET stats/prometheus | grep -m5 hello
