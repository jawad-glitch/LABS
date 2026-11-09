#!/bin/bash
[ -z "$1" ] && { echo "Usage: $0 <app-name>"; exit 1; }
APP=$1
argocd app get $APP --refresh
argocd app get $APP -o json | python3 -c 'import sys,json; s=json.load(sys.stdin)["status"]; print("health:", s["health"]); print("sync:", s["sync"]["status"]); [print("RES", r["kind"], r.get("namespace","-"), r["name"], r.get("status"), (r.get("health") or {}).get("status"), (r.get("health") or {}).get("message","")) for r in s.get("resources",[])]; [print("COND", c) for c in s.get("conditions",[])]'
argocd app history $APP
argocd app diff $APP || true
kubectl get events -A --field-selector involvedObject.name=$APP --sort-by=.lastTimestamp
