#!/usr/bin/env python3
# Argo CD app emulation: clone HEAD over HTTP, kustomize build path, converge Deployment pods (real containers) incl. ConfigMap-mounted HTML.
import sys, os, json, subprocess, tempfile, hashlib, time, yaml
URL, PATH, STATE, LOG, HTMLDIR = sys.argv[1:6]
def sh(*a, check=True): return subprocess.run(a, capture_output=True, text=True, check=check)
def ev(m):
    l = "%s [gitops-demo-app] %s" % (time.strftime("%H:%M:%S"), m); print(l); open(LOG, "a").write(l + "\n")
tmp = tempfile.mkdtemp(); sh("git", "clone", "-q", "--depth", "1", URL, tmp); rev = sh("git", "-C", tmp, "rev-parse", "--short", "HEAD").stdout.strip()
docs = [d for d in yaml.safe_load_all(sh("kubectl", "kustomize", os.path.join(tmp, PATH)).stdout) if d]
dep = next(d for d in docs if d["kind"] == "Deployment"); spec = dep["spec"]["template"]["spec"]; c = spec["containers"][0]
cmname = next(v["configMap"]["name"] for v in spec.get("volumes", []) if "configMap" in v)
cm = next(d for d in docs if d["kind"] == "ConfigMap" and d["metadata"]["name"] == cmname); html = cm["data"]["index.html"]
want, img = dep["spec"]["replicas"], c["image"]; tmpl = hashlib.sha1(json.dumps(dep["spec"]["template"], sort_keys=True).encode()).hexdigest()[:10]
hp = os.path.join(HTMLDIR, "%s.html" % cmname); open(hp, "w").write(html); os.chmod(hp, 0o644)
lv = lambda: [l.split() for l in sh("sudo", "docker", "ps", "-a", "--filter", "label=l10app=demo", "--format", "{{.ID}} {{.Label \"l10tmpl\"}} {{.State}}").stdout.splitlines() if l.strip()]
cur = lv(); ok = [x for x in cur if x[1] == tmpl and x[2] == "running"]; health = "Healthy"
if len(ok) != want or len(cur) != want: ev("rev %s OutOfSync -> rolling out template %s (configMap %s, image %s)" % (rev, tmpl, cmname, img))
for _ in range(max(0, want - len(ok))):
    r = sh("sudo", "docker", "run", "-d", "--label", "l10=1", "--label", "l10app=demo", "--label", "l10tmpl=" + tmpl, "-v", hp + ":/usr/share/nginx/html/index.html:ro", img, check=False)
    if r.returncode != 0: health = "Degraded"; ev("rev %s new pod FAILED (%s): %s - old pods kept serving" % (rev, img, (r.stderr.strip().splitlines() or ["?"])[-1][:110])); break
    ev("rev %s pod created" % rev)
if health == "Healthy":
    for x in [x for x in cur if x not in ok] + ok[want:]: sh("sudo", "docker", "rm", "-f", x[0]); ev("rev %s old pod %s removed" % (rev, x[0][:12]))
run = [x for x in lv() if x[2] == "running"]; good = [x for x in run if x[1] == tmpl]
st = {"revision": rev, "template": tmpl, "configmap": cmname, "image": img, "desired": want, "running": len(run), "sync": "Synced" if len(good) == want and len(run) == want else "OutOfSync", "health": health}
json.dump(st, open(STATE, "w")); ev("rev %s %s/%s running=%d" % (rev, st["sync"], health, len(run)))
