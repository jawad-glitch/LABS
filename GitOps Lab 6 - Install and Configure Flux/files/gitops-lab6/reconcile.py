#!/usr/bin/env python3
# Emulates Flux: source-controller fetches GitRepository (git://), kustomize-controller builds spec.path and applies (prune) -> real containers as pods.
import sys, os, json, subprocess, tempfile, hashlib, time, yaml
REPO, PATH, NS, STATE, LOG, SUSP = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5], sys.argv[6]
def sh(*a): return subprocess.run(a, capture_output=True, text=True, check=True).stdout
def ev(m):
    l = "%s %s" % (time.strftime("%H:%M:%S"), m); print(l); open(LOG, "a").write(l + "\n")
if os.path.exists(SUSP): ev("Kustomization nginx-demo deleted/suspended - no reconcile"); sys.exit(0)
tmp = tempfile.mkdtemp(); sh("git", "clone", "-q", "--depth", "1", "--branch", "main", REPO, tmp)
rev = "main@sha1:" + sh("git", "-C", tmp, "rev-parse", "--short", "HEAD").strip(); ev("GitRepository flux-gitops-demo: stored artifact for revision " + rev)
docs = [d for d in yaml.safe_load_all(sh("kubectl", "kustomize", os.path.join(tmp, PATH))) if d]
dep = next(d for d in docs if d["kind"] == "Deployment"); c = dep["spec"]["template"]["spec"]["containers"][0]
want, img = dep["spec"]["replicas"], c["image"]; tmpl = hashlib.sha1(img.encode()).hexdigest()[:10]
lv = lambda: [l.split() for l in sh("sudo", "docker", "ps", "-a", "--filter", "label=l6app=nginx-demo", "--format", "{{.ID}} {{.Label \"l6tmpl\"}} {{.State}}").splitlines() if l.strip()]
cur = lv(); ok = [x for x in cur if x[1] == tmpl and x[2] == "running"]
if len(ok) != want or len(cur) != len(ok): ev("drift/changes: live=%d desired=%d (ns %s)" % (len(cur), want, NS))
for _ in range(max(0, want - len(ok))): sh("sudo", "docker", "run", "-d", "--network", "l6net", "--label", "l6=1", "--label", "l6app=nginx-demo", "--label", "l6tmpl=" + tmpl, img); ev("Deployment/%s/nginx-demo configured (+1 pod %s)" % (NS, img))
for x in [x for x in cur if x not in ok] + ok[want:]: sh("sudo", "docker", "rm", "-f", x[0]); ev("pruned/replaced pod " + x[0][:12])
n = len([x for x in lv() if x[2] == "running"]); svc = [d["metadata"]["name"] for d in docs if d["kind"] == "Service"]
st = {"revision": rev, "ready": n == want, "replicas": n, "desired": want, "image": img, "services": svc}
json.dump(st, open(STATE, "w")); ev("Kustomization nginx-demo: Applied revision %s (Ready=%s, replicas %d/%d)" % (rev, n == want, n, want))
