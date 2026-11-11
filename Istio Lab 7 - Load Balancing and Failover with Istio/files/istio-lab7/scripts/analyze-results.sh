#!/bin/bash
# Fixed: counts come from Envoy per-endpoint rq_total (istioctl proxy-config endpoint / admin /clusters); guards against zero totals.
ADMIN=${1:-127.0.0.1:15000}
mapfile -t rows < <(curl -s http://$ADMIN/clusters | grep -oE '::[0-9.]+:[0-9]+::rq_total::[0-9]+' | sed 's/::rq_total::/ /; s/^:://')
total=0; for r in "${rows[@]}"; do total=$((total + ${r##* })); done
[ "$total" -gt 0 ] || { echo "No requests recorded yet - generate traffic first"; exit 1; }
max=0; min=999999999; for r in "${rows[@]}"; do c=${r##* }; echo "${r% *}: $c ($(( c * 100 / total ))%)"; [ $c -gt $max ] && max=$c; [ $c -lt $min ] && min=$c; done
avg=$(( total / ${#rows[@]} )); spread=$(( (max - min) * 100 / (avg > 0 ? avg : 1) ))
echo "total=$total endpoints=${#rows[@]} spread=${spread}% -> $([ $spread -le 20 ] && echo 'balanced' || echo 'uneven')"
