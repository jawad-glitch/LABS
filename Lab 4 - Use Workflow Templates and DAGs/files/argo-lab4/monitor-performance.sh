#!/bin/bash
WORKFLOW_NAME=$1
if [ -z "$WORKFLOW_NAME" ]; then echo "Usage: $0 <workflow-name>"; exit 1; fi
J=$(argo get $WORKFLOW_NAME -n argo -o json)
echo "=== Workflow Performance Report ==="; echo "Workflow: $WORKFLOW_NAME"; echo "Generated: $(date)"; echo ""
echo "Status: $(echo "$J" | jq -r '.status.phase')"
echo "Started: $(echo "$J" | jq -r '.status.startedAt')"
echo "Finished: $(echo "$J" | jq -r '.status.finishedAt // "Running"')"
echo ""; echo "=== Task Execution Times ==="
echo "$J" | jq -r '[.status.nodes[] | select(.type=="Pod")] | sort_by(.startedAt) | .[] | "\(.displayName): \(.phase) (\(.startedAt // "N/A") to \(.finishedAt // "Running"))"'
echo ""; echo "=== Resource Usage ==="
kubectl top pods -n argo --selector=workflows.argoproj.io/workflow=$WORKFLOW_NAME 2>/dev/null || echo "Resource metrics not available (no metrics-server)"
