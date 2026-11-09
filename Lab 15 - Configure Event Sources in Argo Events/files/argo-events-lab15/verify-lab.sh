#!/bin/bash
NS=argo-events
echo "1. pods: $(kubectl get pods -n $NS --no-headers | grep -c Running)/$(kubectl get pods -n $NS --no-headers | wc -l) running"
echo "2. eventsources: $(kubectl get eventsource -n $NS --no-headers | wc -l)  sensors: $(kubectl get sensor -n $NS --no-headers | wc -l)"
echo "3. webhook configmaps: $(kubectl get cm -n $NS -l app=webhook-configmap --no-headers | wc -l)  cron configmaps: $(kubectl get cm -n $NS -l app=cron-configmap --no-headers | wc -l)"
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
echo "4. webhook HTTP: $(curl -s -o /dev/null -w '%{http_code}' -X POST http://$NODE_IP:31000/github -H 'Content-Type: application/json' -d '{"test":"verification"}')"
