#!/bin/bash
# Re-seal database-credentials with a fresh random password; never prints the secret.
set -u; SECRET_NAME="${1:-database-credentials}"; NAMESPACE="${2:-myapp}"; OUT="manifests/base/sealed-secret.yaml"
NEW_PASSWORD=$(openssl rand -base64 32)
kubectl create secret generic "$SECRET_NAME" --from-literal=username=admin --from-literal=password="$NEW_PASSWORD" --from-literal=apikey="rotated-$(date +%s)" \
  --namespace="$NAMESPACE" --dry-run=client -o yaml | kubeseal -w "$OUT"
unset NEW_PASSWORD; echo "re-sealed $SECRET_NAME into $OUT (commit + push; then rollout restart consumers)"
