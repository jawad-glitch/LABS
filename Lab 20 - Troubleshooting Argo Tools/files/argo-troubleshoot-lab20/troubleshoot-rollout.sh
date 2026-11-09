#!/bin/bash
[ -z "$1" ] && { echo "Usage: $0 <rollout-name> [namespace]"; exit 1; }
RO=$1; NS=${2:-default}
kubectl argo rollouts get rollout $RO -n $NS              # (no 'history' subcommand exists; revisions are shown here)
kubectl argo rollouts status $RO -n $NS --timeout 10s
kubectl get rs,pods -n $NS -l app=$RO -o wide
for pod in $(kubectl get pods -n $NS -l app=$RO -o jsonpath='{.items[*].metadata.name}'); do
  kubectl get pod -n $NS $pod -o jsonpath='{.metadata.name}{" "}{range .status.containerStatuses[*]}{.image}{" "}{.state.waiting.reason}{"\n"}{end}'; done
kubectl get analysisrun -n $NS 2>/dev/null
kubectl get events -n $NS --sort-by=.lastTimestamp | tail -20
kubectl logs -n argo-rollouts deploy/argo-rollouts --tail=30
PROMETHEUS_URL=${PROMETHEUS_URL:-http://localhost:9091} $(dirname $0)/query-prometheus.sh
