#!/bin/bash
# Pre-commit validation gate. Rule 1: every k8s-manifests/*.yaml is schema-valid (kubeconform, works without a cluster).
# Rule 2: deployment.yaml image must not contain nonexistent|broken|invalid|does-not-exist (case-insensitive).
cd "$(dirname "$0")"
validate_yaml_syntax() { local dir=$1 rc=0 f out
  for f in "$dir"/*.yaml; do
    if out=$(kubeconform -strict -summary "$f" 2>&1) && echo "$out" | grep -q "Invalid: 0, Errors: 0"; then echo "PASS: $f"; else echo "FAIL: $f - $(echo "$out" | head -1)"; rc=1; fi
  done; return $rc; }
validate_image_name() { local m; m=$(grep -E '^\s*image:' "$1" | grep -ioE 'nonexistent|broken|invalid|does-not-exist' | head -1)
  if [ -n "$m" ]; then echo "FAIL: image name contains forbidden string '$m'"; return 1; fi; echo "PASS: image name is clean"; return 0; }
main() { validate_yaml_syntax k8s-manifests; local a=$?; validate_image_name k8s-manifests/deployment.yaml; local b=$?; [ $a = 0 ] && [ $b = 0 ]; }
main; exit $?
