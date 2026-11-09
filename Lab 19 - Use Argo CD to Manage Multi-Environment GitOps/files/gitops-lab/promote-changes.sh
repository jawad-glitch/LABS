#!/bin/bash
# Usage: promote-changes.sh <source-env> <target-env>   - promotes the container image (not env-specific settings)
[ $# -eq 2 ] || { echo "Usage: $0 <source-env> <target-env>"; exit 1; }
G=${GITOPS_DIR:-$HOME/gitops-lab}; S=$G/sample-app-$1; Tg=$G/sample-app-$2
IMG=$(python3 -c 'import yaml,sys; print(yaml.safe_load(open(sys.argv[1]))["spec"]["template"]["spec"]["containers"][0]["image"])' $S/manifests/deployment.yaml)
python3 - "$Tg/manifests/deployment.yaml" "$IMG" <<'PY'
import sys, re
f, img = sys.argv[1], sys.argv[2]; t = open(f).read()
open(f, "w").write(re.sub(r"(\n\s+image: ).*", r"\g<1>" + img, t, count=1))
PY
cd $Tg && git add manifests/deployment.yaml && git -c user.name="GitOps Student" -c user.email="student@example.com" commit -qm "Promote image $IMG from $1 ($(git -C $S rev-parse --short HEAD)) to $2" && git push -q origin main && echo "promoted $IMG: $1 -> $2 ($(git rev-parse --short HEAD))"
