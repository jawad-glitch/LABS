#!/bin/bash
# Full mode (cluster from Lab 1). Bounded; no exec into distroless istiod.
set -u
kubectl create ns test-app --dry-run=client -o yaml | kubectl apply -f - && kubectl label ns test-app istio-injection=enabled --overwrite
kubectl apply -f k8s/nginx-test.yaml -f k8s/telemetry-access-logs.yaml && kubectl -n test-app rollout status deploy/nginx-test --timeout=180s
POD=$(kubectl -n test-app get pod -l app=nginx-test -o jsonpath='{.items[0].metadata.name}')
istioctl proxy-status; istioctl proxy-config listener $POD.test-app | head; istioctl proxy-config cluster $POD.test-app --fqdn nginx-test.test-app.svc.cluster.local
kubectl -n test-app exec $POD -c istio-proxy -- pilot-agent request GET ready
kubectl -n istio-system port-forward deploy/istiod 15014:15014 8080:8080 >/tmp/pf.log 2>&1 & PF=$!; sleep 3
curl -s localhost:8080/ready; curl -s localhost:15014/debug/registryz | head -c 400; kill $PF
kubectl -n test-app run test-client --image=curlimages/curl:8.11.1 --rm -i --restart=Never -- curl -s -o /dev/null -w '%{http_code}\n' nginx-test.test-app
kubectl -n test-app logs $POD -c istio-proxy --tail=3
