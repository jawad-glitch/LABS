#!/bin/bash
ROLLOUT_NAME="rollout-canary"; NAMESPACE="canary-demo"; ITER="${1:-3}"
for n in $(seq 1 "$ITER"); do
  echo "=== Canary Deployment Monitor ($n/$ITER) $(date) ==="
  kubectl argo rollouts get rollout $ROLLOUT_NAME -n $NAMESPACE
  kubectl get pods -l app=rollout-canary -n $NAMESPACE
  kubectl get events -n $NAMESPACE --sort-by=.metadata.creationTimestamp | tail -5
  [ "$n" -lt "$ITER" ] && sleep 10
done
