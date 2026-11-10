#!/bin/bash
# dr-validate.sh - 5 checks, PASS/FAIL each, exit 0 only if all pass. No arguments.
# BACKEND=kubectl (default, full mode) or BACKEND=docker (this lab's emulation; DRS=<controller-state.json>).
B=${BACKEND:-kubectl}; FAILS=0
pf() { if [ "$2" = 0 ]; then echo "PASS check $1: $3"; else echo "FAIL check $1: $3"; FAILS=$((FAILS+1)); fi; }
if [ "$B" = kubectl ]; then
  [ "$(kubectl get ns sample-app -o jsonpath='{.status.phase}' 2>/dev/null)" = Active ]; pf 1 $? "namespace sample-app Active"
  [ "$(kubectl -n sample-app get deploy web-app -o jsonpath='{.status.readyReplicas}' 2>/dev/null)" = 3 ]; pf 2 $? "web-app readyReplicas == 3 (and tracked: label app.kubernetes.io/instance=$(kubectl -n sample-app get deploy web-app -o jsonpath='{.metadata.labels.app\.kubernetes\.io/instance}' 2>/dev/null))"
  [ "$(kubectl -n sample-app get endpointslices -l kubernetes.io/service-name=web-app -o jsonpath='{.items[*].endpoints[*].addresses[0]}' 2>/dev/null | wc -w)" -ge 1 ]; pf 3 $? "service web-app has endpoints"
  S=$(kubectl -n argocd get application sample-web-app -o jsonpath='{.status.sync.status} {.status.health.status}' 2>/dev/null); [ "$S" = "Synced Healthy" ]; pf 4 $? "Argo CD sample-web-app = $S"
  kubectl -n sample-app port-forward deploy/web-app 18080:80 >/dev/null 2>&1 & PF=$!; C=000; for i in $(seq 1 20); do C=$(curl -s -o /dev/null -m 2 -w '%{http_code}' http://127.0.0.1:18080/); [ "$C" = 200 ] && break; sleep 0.5; done
  kill $PF 2>/dev/null; wait $PF 2>/dev/null; [ "$C" = 200 ]; pf 5 $? "HTTP GET via port-forward = $C"
else
  sudo docker network inspect l20-sample-app >/dev/null 2>&1; pf 1 $? "namespace sample-app Active"
  N=$(sudo docker ps -q --filter label=l20app=web-app | wc -l); R3=$(python3 -c "import json; print(json.load(open('$DRS')).get('ready_current',0))" 2>/dev/null); [ "$N" -ge 3 ] && [ "${R3:-0}" -ge 3 ]; pf 2 $? "web-app ready replicas == 3 (running=$N current=$R3)"
  [ "$N" -ge 1 ]; pf 3 $? "service web-app has endpoints ($N)"
  S=$(python3 -c "import json; d=json.load(open('$DRS')); print(d['sync'], d['health'])" 2>/dev/null); [ "$S" = "Synced Healthy" ]; pf 4 $? "Argo CD sample-web-app = $S"
  IP=$(sudo docker ps -q --filter label=l20app=web-app | head -1 | xargs -r sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'); C=$( [ -n "$IP" ] && curl -s -o /dev/null -m 2 -w '%{http_code}' http://$IP/ || echo 000 ); [ "$C" = 200 ]; pf 5 $? "HTTP GET to an nginx pod = $C"
fi
[ $FAILS = 0 ] && exit 0 || exit 1
