#!/bin/bash
# Health check from the app state (full mode: replace STATE reads with kubectl get application/pods as in the playbook).
S=${1:-state.json}
python3 - "$S" <<'PY'
import json, sys
s = json.load(open(sys.argv[1])); ok = s.get("sync") == "Synced" and s.get("health") == "Healthy"
print("=== GitOps Health Check ==="); print("Sync: %s  Health: %s  Revision: %s" % (s.get("sync"), s.get("health"), s.get("revision")))
for n, d in s.get("deployments", {}).items(): print("  %-12s %s/%s %s %s" % (n, d["running"], d["desired"], d["image"], d["status"]))
print("RESULT:", "OK" if ok else "ATTENTION"); sys.exit(0 if ok else 1)
PY
