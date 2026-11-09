#!/bin/bash
# Usage: troubleshoot-workflow.sh <workflow-name> [namespace]
[ -z "$1" ] && { echo "Usage: $0 <workflow-name> [namespace]"; exit 1; }
WF=$1; NS=${2:-argo}
echo "1. Status:"; argo get -n $NS $WF
echo "2. Failed nodes (from status):"
argo get -n $NS $WF -o json | python3 -c 'import sys,json; w=json.load(sys.stdin); [print(n["displayName"], n["phase"], n.get("message",""), n["id"]) for n in w["status"].get("nodes",{}).values() if n["type"]=="Pod" and n["phase"] in ("Failed","Error")]'
echo "3. Logs of failed pods:"
for pod in $(kubectl get pods -n $NS -l workflows.argoproj.io/workflow=$WF --field-selector=status.phase=Failed -o jsonpath='{.items[*].metadata.name}'); do
  echo "--- $pod"; kubectl logs -n $NS $pod -c main --timestamps --tail=50; kubectl describe pod -n $NS $pod | sed -n '/Events:/,$p'; done
echo "4. Events:"; kubectl get events -n $NS --field-selector involvedObject.name=$WF --sort-by=.lastTimestamp
