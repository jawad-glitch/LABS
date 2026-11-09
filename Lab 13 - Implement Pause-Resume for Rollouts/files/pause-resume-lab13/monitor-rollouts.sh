#!/bin/bash
NS=rollout-demo; ITER="${1:-3}"
for n in $(seq 1 "$ITER"); do
  echo "=== $(date) ($n/$ITER) ==="; kubectl get rollouts -n $NS
  for r in $(kubectl get rollouts -n $NS -o jsonpath='{.items[*].metadata.name}'); do kubectl argo rollouts get rollout $r -n $NS | head -10; echo "---"; done
  kubectl get analysisruns -n $NS 2>/dev/null || echo "No analysis runs found"
  [ "$n" -lt "$ITER" ] && sleep 10
done
