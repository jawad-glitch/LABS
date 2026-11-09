#!/bin/bash
echo "=== Testing DAG Execution Patterns ==="
echo "1. Submitting test workflow..."
WORKFLOW_NAME=$(argo submit simple-dag-workflow.yaml -n argo -o name)
echo "   Submitted: $WORKFLOW_NAME"
echo "2. Waiting for workflow completion..."
argo wait $WORKFLOW_NAME -n argo
echo "3. Analyzing execution pattern..."; echo ""
echo "Expected execution order:"; echo "   Task A (first)"; echo "   Task B, C, E (parallel, after A)"; echo "   Task D (after B and C complete)"; echo ""
J=$(argo get $WORKFLOW_NAME -n argo -o json)
echo "Actual execution:"
echo "$J" | jq -r '[.status.nodes[] | select(.type=="Pod")] | sort_by(.startedAt) | .[] | "\(.displayName): \(.phase) (Started: \(.startedAt // "N/A"))"'
t() { echo "$J" | jq -r --arg n "$1" --arg f "$2" '[.status.nodes[] | select(.displayName==$n)][0][$f]'; }
echo ""; echo "4. Verifying DAG constraints..."
if [[ ! "$(t task-b startedAt)" < "$(t task-a finishedAt)" ]]; then echo "   ✓ Task B started after Task A"; else echo "   ✗ Task B dependency violation"; fi
if [[ ! "$(t task-d startedAt)" < "$(t task-b finishedAt)" && ! "$(t task-d startedAt)" < "$(t task-c finishedAt)" ]]; then echo "   ✓ Task D started after Task B and Task C"; else echo "   ✗ Task D dependency violation"; fi
echo ""; echo "Test completed!"
