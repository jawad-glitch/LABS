#!/bin/bash
# Switch production traffic declaratively: edit traffic-router/production-service.yaml (ExternalName), commit, push.
# Argo CD (traffic-router app) applies it; RECONCILE_HOOK lets a local reconciler stand in for Argo CD.
set -u; cd "$(dirname "$0")"
case "${1:-}" in blue|green) ;; *) echo "Usage: $0 blue|green  (got: '${1:-}')"; exit 1;; esac
yq -i ".spec.externalName = \"sample-app.$1-env.svc.cluster.local\" | .metadata.annotations.\"gitops/active-environment\" = \"$1\"" traffic-router/production-service.yaml
git add traffic-router/production-service.yaml
git diff --cached --quiet || git commit -qm "traffic: switch production to $1"
git push -q origin HEAD:main
if [ -n "${RECONCILE_HOOK:-}" ]; then eval "$RECONCILE_HOOK" >/dev/null; elif command -v argocd >/dev/null && argocd app get traffic-router >/dev/null 2>&1; then argocd app sync traffic-router >/dev/null && argocd app wait traffic-router --sync --health --timeout 60 >/dev/null; fi
echo "Active environment: $1"
