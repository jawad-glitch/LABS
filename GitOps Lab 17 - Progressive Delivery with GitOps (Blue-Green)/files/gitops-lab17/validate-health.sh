#!/bin/bash
# Usage: validate-health.sh blue|green   (full mode: kubectl; HEALTH_BACKEND=docker uses the local reconciler's pods)
set -u; E="${1:-}"; case "$E" in blue) V=v1.0;; green) V=v2.0;; *) echo "Usage: $0 blue|green"; exit 1;; esac; NS="$E-env"
fail() { echo "HEALTH CHECK FAILED: $E - $1"; exit 1; }
if [ "${HEALTH_BACKEND:-kubectl}" = docker ]; then
  READY=$(sudo docker ps -q --filter label=l17ns=$NS --filter status=running | wc -l); EPS=$READY
  IP=$(sudo docker ps -q --filter label=l17ns=$NS | head -1 | xargs -r sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')
  BODY=$( [ -n "$IP" ] && curl -s -m 3 http://$IP/ )
else
  READY=$(kubectl -n $NS get deploy sample-app -o jsonpath='{.status.readyReplicas}' 2>/dev/null); READY=${READY:-0}
  EPS=$(kubectl -n $NS get endpointslices -l kubernetes.io/service-name=sample-app -o jsonpath='{range .items[*].endpoints[*]}{.addresses[0]}{"\n"}{end}' 2>/dev/null | grep -c .)
  BODY=$(kubectl -n $NS run hc-$$ --rm -i --restart=Never --image=busybox:1.36 -- wget -qO- -T 3 http://sample-app 2>/dev/null)
fi
[ "$READY" -ge 3 ] || fail "only $READY/3 replicas Ready"
[ "$EPS" -ge 1 ] || fail "Service has no endpoints"
echo "$BODY" | grep -q "$V" || fail "response does not contain $V"
echo "HEALTH CHECK PASSED: $E"; exit 0
