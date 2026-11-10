#!/bin/bash
# Pre-merge / CI gate: evaluate every manifest against the repo's Gatekeeper policies before it can reach Git main or the cluster.
set -u; cd "$(dirname "$0")"; rc=0
for f in $(find "${1:-manifests/compliant}" applications -name '*.yaml' | sort); do
  if out=$(gator test -f policies/templates -f policies/constraints -f "$f" 2>&1); then echo "PASS $f"; else echo "FAIL $f"; echo "$out" | sed 's/^/     /'; rc=1; fi
done
exit $rc
