#!/bin/bash
# Full mode (needs ~3 GB free RAM): kind + Istio 1.32.0 default profile with istiod request lowered for small VMs.
set -u
sudo kind create cluster --name istio-lab --kubeconfig $HOME/.kube/config && sudo chown -R $USER: $HOME/.kube
kubectl wait --for=condition=Ready node --all --timeout=120s
istioctl x precheck
istioctl install --set values.defaultRevision=default --set components.pilot.k8s.resources.requests.memory=512Mi -y
kubectl -n istio-system rollout status deploy/istiod --timeout=300s && kubectl -n istio-system rollout status deploy/istio-ingressgateway --timeout=300s
kubectl label namespace default istio-injection=enabled --overwrite
kubectl apply -f app/nginx-test.yaml && kubectl rollout status deploy/nginx-test --timeout=180s
kubectl get pods -l app=nginx-test -o jsonpath='{range .items[*]}{.metadata.name} containers={.spec.containers[*].name} init={.spec.initContainers[*].name}{"\n"}{end}'
istioctl proxy-status
istioctl proxy-config cluster deploy/nginx-test | head -20
kubectl get gateways.networking.istio.io -A
kubectl run test-client --image=curlimages/curl:8.11.1 --rm -i --restart=Never -- curl -s -o /dev/null -w '%{http_code}\n' nginx-test.default.svc.cluster.local
