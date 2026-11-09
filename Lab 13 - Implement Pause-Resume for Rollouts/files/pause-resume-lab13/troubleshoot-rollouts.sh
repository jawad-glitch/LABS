#!/bin/bash
NAMESPACE="rollout-demo"; ROLLOUT_NAME="$1"
if [ -z "$ROLLOUT_NAME" ]; then echo "Usage: $0 <rollout-name>"; kubectl get rollouts -n $NAMESPACE; exit 1; fi
echo "1. Rollout Status:"; kubectl argo rollouts get rollout $ROLLOUT_NAME -n $NAMESPACE
echo "2. Description:"; kubectl describe rollout $ROLLOUT_NAME -n $NAMESPACE
echo "3. Pods:"; kubectl get pods -n $NAMESPACE -l app=$ROLLOUT_NAME
echo "4. Events:"; kubectl get events -n $NAMESPACE --sort-by='.lastTimestamp' | grep $ROLLOUT_NAME | tail -10
echo "5. AnalysisRuns:"; kubectl get analysisruns -n $NAMESPACE | grep $ROLLOUT_NAME || echo "No analysis runs found"
echo "6. ReplicaSets:"; kubectl get rs -n $NAMESPACE -l app=$ROLLOUT_NAME
