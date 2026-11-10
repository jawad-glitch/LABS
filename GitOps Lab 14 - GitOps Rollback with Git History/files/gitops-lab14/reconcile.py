#!/usr/bin/env python3
# Clone HEAD over HTTP, read k8s-manifests, converge real nginx containers. ConfigMap content is written IN PLACE to a file
# bind-mounted into every pod (same inode) - like a kubelet-updated configMap volume: running pods see content changes.
import sys, os, json, subprocess, tempfile, hashlib, time, yaml
URL, STATE, LOG, CMDIR = sys.argv[1:5]
def sh(*a, check=True): return subprocess.run(a, capture_output=True, text=True, check=check)
def ev(m):
    l = "%s [sample-app] %s" % (time.strftime("%H:%M:%S"), m); print(l); open(LOG, "a").write(l + "\n")
tmp = tempfile.mkdtemp(); sh("git", "clone", "-q", "--depth", "1", URL, tmp); rev = sh("git", "-C", tmp, "rev-parse", "--short", "HEAD").stdout.strip()
docs = [d for f in sorted(os.listdir(tmp + "/k8s-manifests")) if f.endswith(".yaml") for d in yaml.safe_load_all(open(tmp + "/k8s-manifests/" + f)) if d]
dep = next(d for d in docs if d["kind"] == "Deployment"); cm = next(d for d in docs if d["kind"] == "ConfigMap")
c = dep["spec"]["template"]["spec"]["containers"][0]; want, img = dep["spec"]["replicas"], c["image"]
hp = os.path.join(CMDIR, cm["metadata"]["name"] + ".html")
if not os.path.exists(hp): open(hp, "w").close(); os.chmod(hp, 0o644)
with open(hp, "r+") as f: f.seek(0); f.truncate(); f.write(cm["data"]["index.html"])
tmpl = hashlib.sha1(json.dumps(dep["spec"]["template"], sort_keys=True).encode()).hexdigest()[:10]
mem = (c.get("resources", {}).get("limits", {}).get("memory") or "0").replace("Mi", "m")
lv = lambda: [l.split() for l in sh("sudo", "docker", "ps", "-a", "--filter", "label=l14app=sample-app", "--format", "{{.ID}} {{.Label \"l14tmpl\"}} {{.State}}").stdout.splitlines() if l.strip()]
cur = lv(); ok = [x for x in cur if x[1] == tmpl and x[2] == "running"]; health = "Healthy"
if len(ok) != want or len(cur) != want: ev("rev %s OutOfSync -> desired %d x %s (template %s)" % (rev, want, img, tmpl))
for _ in range(max(0, want - len(ok))):
    a = ["sudo", "docker", "run", "-d", "--label", "l14=1", "--label", "l14app=sample-app", "--label", "l14tmpl=" + tmpl, "-v", hp + ":/usr/share/nginx/html/index.html:ro"]
    if mem != "0": a += ["--memory", mem]
    r = sh(*(a + [img]), check=False)
    if r.returncode != 0: health = "Degraded"; ev("rev %s ErrImagePull %s: %s - old ReplicaSet pods kept" % (rev, img, (r.stderr.strip().splitlines() or ["?"])[-1][:100])); break
    ev("rev %s pod created (%s)" % (rev, img))
if health == "Healthy":
    for x in [x for x in cur if x not in ok] + ok[want:]: sh("sudo", "docker", "rm", "-f", x[0]); ev("rev %s old pod %s removed" % (rev, x[0][:12]))
run = [x for x in lv() if x[2] == "running"]; good = [x for x in run if x[1] == tmpl]
imgs = sorted(set(sh("sudo", "docker", "inspect", "-f", "{{.Config.Image}}", *[x[0] for x in run]).stdout.split())) if run else []
st = {"revision": rev, "desired": want, "running": len(run), "images": imgs, "sync": "Synced" if len(good) == want and len(run) == want else "OutOfSync", "health": health}
json.dump(st, open(STATE, "w")); ev("rev %s %s/%s running=%d images=%s" % (rev, st["sync"], health, len(run), imgs))
