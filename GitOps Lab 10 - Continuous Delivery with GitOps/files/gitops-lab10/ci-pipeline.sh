#!/bin/bash
# CI: test (kustomize build + schema), bump version monotonically, update manifests, commit + push (GitOps hand-off).
set -u; MSG="${1:-automated update}"; cd "$(dirname "$0")"
echo "=== CI pipeline $(date '+%F %T') ==="
cp app-source/index.html k8s-manifests/index.html
kubectl kustomize k8s-manifests > /tmp/ci-render.yaml || { echo "FAIL: kustomize build"; exit 1; }
kubeconform -strict -summary /tmp/ci-render.yaml | tail -n1 | grep -q "Invalid: 0, Errors: 0" || { echo "FAIL: schema"; exit 1; }
CUR=$(grep -oE 'Version: [0-9]+\.[0-9]+\.[0-9]+' k8s-manifests/index.html | awk '{print $2}'); NEW="${CUR%.*}.$(( ${CUR##*.} + 1 ))"
sed -i "s/Version: $CUR/Version: $NEW/; s|Update: .*</p>|Update: $MSG</p>|" k8s-manifests/index.html app-source/index.html
git add k8s-manifests app-source && git commit -qm "CI: release $NEW - $MSG" && git push -q origin main && echo "released $NEW (pushed)"
