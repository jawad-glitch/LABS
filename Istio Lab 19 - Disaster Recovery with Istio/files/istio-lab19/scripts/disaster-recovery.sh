#!/bin/bash
# Fixed: the success rate is PRINTED and compared numerically (exit codes are 0 = success, not a percentage).
GATEWAY_URL=${1:?usage: $0 <gateway-url>}; THRESHOLD=${THRESHOLD:-80}; N=${N:-20}
ROLLBACK_CMD=${ROLLBACK_CMD:-"kubectl apply -f k8s/vs-v1.yaml"}
rate() { local ok=0; for i in $(seq 1 $N); do curl -s -f -m 5 -o /dev/null "http://$GATEWAY_URL/" && ok=$((ok+1)); done; echo $(( ok * 100 / N )); }
R1=$(rate); echo "current success rate: ${R1}% (threshold ${THRESHOLD}%)"
if [ "$R1" -ge "$THRESHOLD" ]; then echo "OK: service healthy - no action"; exit 0; fi
echo "BELOW THRESHOLD: rolling back -> $ROLLBACK_CMD"; bash -c "$ROLLBACK_CMD" || { echo "ROLLBACK COMMAND FAILED"; exit 2; }
R2=$(rate); echo "post-rollback success rate: ${R2}%"
[ "$R2" -ge 90 ] && { echo "RECOVERY SUCCESSFUL"; exit 0; } || { echo "RECOVERY FAILED"; exit 3; }
