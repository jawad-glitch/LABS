#!/bin/bash
WORKFLOW_NAME=$1
if [ -z "$WORKFLOW_NAME" ]; then echo "Usage: $0 <workflow-name>"; exit 1; fi
echo "=== DAG Execution Analysis ==="; echo "Workflow: $WORKFLOW_NAME"; echo ""
echo "=== Task Execution Order (sorted by startedAt) ==="
argo get $WORKFLOW_NAME -n argo -o json | jq -r '[.status.nodes[] | select(.type=="Pod")] | sort_by(.startedAt) | .[] | "\(.displayName): \(.phase) (Started: \(.startedAt // "N/A"), Finished: \(.finishedAt // "N/A"))"'
echo ""; echo "=== Dependency Graph ==="
echo "Task A -> Task B, Task C, Task E (parallel)"; echo "Task B + Task C -> Task D"; echo "Task E runs independently after Task A"
echo ""; echo "=== Resource Usage ==="
kubectl top pods -n argo --selector=workflows.argoproj.io/workflow=$WORKFLOW_NAME 2>/dev/null || echo "Metrics not available (no metrics-server)"
