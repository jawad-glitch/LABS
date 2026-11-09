#!/bin/bash
OVERALL=HEALTHY
for env in dev staging prod; do
  app=sample-app-$env; ns=sample-app-$env
  read -r health sync < <(argocd app get $app -o json 2>/dev/null | python3 -c 'import sys,json; s=json.load(sys.stdin)["status"]; print(s["health"]["status"], s["sync"]["status"])')
  ready=$(kubectl get deploy sample-app -n $ns -o jsonpath='{.status.readyReplicas}' 2>/dev/null); want=$(kubectl get deploy sample-app -n $ns -o jsonpath='{.spec.replicas}' 2>/dev/null)
  kubectl get svc sample-app-service -n $ns >/dev/null 2>&1 && svc=EXISTS || svc=MISSING
  echo "$env: health=$health sync=$sync ready=${ready:-0}/${want:-0} service=$svc"
  [ "$health" = Healthy ] && [ "$sync" = Synced ] && [ "${ready:-0}" = "${want:-x}" ] && [ $svc = EXISTS ] || OVERALL=UNHEALTHY
done
echo "Overall Status: $OVERALL"; [ $OVERALL = HEALTHY ]
