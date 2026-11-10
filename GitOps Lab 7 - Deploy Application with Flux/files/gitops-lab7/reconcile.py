#!/usr/bin/env python3
# Flux emulation: fetch GitRepository over HTTP, build spec.path with kustomize, apply to real containers (pods).
import sys, os, json, subprocess, tempfile, hashlib, time, yaml
URL, PATH, STATE, LOG = sys.argv[1:5]
def sh(*a): return subprocess.run(a, capture_output=True, text=True, check=True).stdout
def ev(m):
    l = "%s %s" % (time.strftime("%H:%M:%S"), m); print(l); open(LOG, "a").write(l + "\n")
tmp = tempfile.mkdtemp(); sh("git", "clone", "-q", "--depth", "1", "--branch", "main", URL, tmp)
rev = "main@sha1:" + sh("git", "-C", tmp, "rev-parse", "--short", "HEAD").strip(); ev("GitRepository/flux-system/nginx-app-repo stored artifact " + rev)
docs = [d for d in yaml.safe_load_all(sh("kubectl", "kustomize", os.path.join(tmp, PATH))) if d]
dep = next(d for d in docs if d["kind"] == "Deployment"); c = dep["spec"]["template"]["spec"]["containers"][0]
want, img = dep["spec"]["replicas"], c["image"]; labels = dep["spec"]["template"]["metadata"]["labels"]
tmpl = hashlib.sha1(json.dumps([img, labels], sort_keys=True).encode()).hexdigest()[:10]
lv = lambda: [l.split() for l in sh("sudo", "docker", "ps", "-a", "--filter", "label=l7app=nginx", "--format", "{{.ID}} {{.Label \"l7tmpl\"}} {{.State}}").splitlines() if l.strip()]
cur = lv(); ok = [x for x in cur if x[1] == tmpl and x[2] == "running"]
for _ in range(max(0, want - len(ok))):
    a = ["sudo", "docker", "run", "-d", "--network", "l7net", "--label", "l7=1", "--label", "l7app=nginx", "--label", "l7tmpl=" + tmpl, "--memory", "128m", "--cpus", "0.5"]
    for k, v in labels.items(): a += ["--label", "%s=%s" % (k, v)]
    sh(*(a + [img])); ev("Deployment/default/nginx-deployment configured (+pod %s)" % img)
for x in [x for x in cur if x not in ok] + ok[want:]: sh("sudo", "docker", "rm", "-f", x[0]); ev("replaced/pruned pod " + x[0][:12])
n = len([x for x in lv() if x[2] == "running"])
st = {"revision": rev, "ready": n == want, "replicas": n, "desired": want, "image": img, "pod_labels": labels, "objects": ["%s/%s" % (d["kind"], d["metadata"]["name"]) for d in docs]}
json.dump(st, open(STATE, "w")); ev("Kustomization/flux-system/nginx-app Applied revision %s Ready=%s (%d/%d)" % (rev, n == want, n, want))
