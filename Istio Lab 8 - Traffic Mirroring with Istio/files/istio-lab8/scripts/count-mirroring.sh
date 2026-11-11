#!/bin/bash
# Fixed counting: from the sidecar access log (Telemetry accessLogging enabled). Mirrored requests carry a "-shadow" authority.
NS=traffic-mirror-demo
cnt() { kubectl logs -n $NS -l app=productpage,version=$1 -c istio-proxy --since=${2:-60s} 2>/dev/null | grep -c "$3"; }   # grep -c alone already prints 0
V1=$(cnt v1 60s '"GET /productpage'); V2=$(cnt v2 60s '"GET /productpage'); SH=$(cnt v2 60s '\-shadow')
echo "v1=$V1 v2=$V2 (shadow=$SH)"; [ "$V1" -gt 0 ] && echo "mirror ratio: $(( SH * 100 / V1 ))%"
