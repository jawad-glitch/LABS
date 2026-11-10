#!/usr/bin/env python3
# Minimal GitOps reconciler: clone Git (git://), kustomize build, converge real containers (pods) to the Deployment spec.
import sys, os, json, subprocess, tempfile, hashlib, time, yaml
REPO, PATH, STATE, LOG = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
def sh(*a, check=True): return subprocess.run(a, capture_output=True, text=True, check=check).stdout
def ev(msg):
    line = "%s %s" % (time.strftime("%H:%M:%S"), msg); print(line); open(LOG, "a").write(line + "\n")
tmp = tempfile.mkdtemp(); sh("git", "clone", "-q", "--depth", "1", REPO, tmp)
rev = sh("git", "-C", tmp, "rev-parse", "--short", "HEAD").strip()
docs = [d for d in yaml.safe_load_all(sh("kubectl", "kustomize", os.path.join(tmp, PATH))) if d]
dep = next(d for d in docs if d["kind"] == "Deployment"); c = dep["spec"]["template"]["spec"]["containers"][0]
want = dep["spec"]["replicas"]; img = c["image"]; env = {e["name"]: e["value"] for e in c.get("env", [])}
lim = c.get("resources", {}).get("limits", {}); mem = lim.get("memory", "128Mi").replace("Mi", "m"); cpu = str(int(lim.get("cpu", "500m").rstrip("m")) / 1000)
tmpl = hashlib.sha1(json.dumps([img, env, mem, cpu], sort_keys=True).encode()).hexdigest()[:10]
def live():
    out = sh("sudo", "docker", "ps", "-a", "--filter", "label=l5app=demo-app", "--format", "{{.ID}} {{.Label \"l5tmpl\"}} {{.State}}")
    return [l.split() for l in out.splitlines() if l.strip()]
cur = live(); ok = [x for x in cur if x[1] == tmpl and x[2] == "running"]; stale = [x for x in cur if x not in ok]
if len(cur) != want or stale: ev("rev %s OutOfSync: live=%d (matching=%d) desired=%d image=%s" % (rev, len(cur), len(ok), want, img))
for _ in range(max(0, want - len(ok))):
    args = ["sudo", "docker", "run", "-d", "--network", "l5net", "--label", "l5=1", "--label", "l5app=demo-app", "--label", "l5tmpl=" + tmpl, "--label", "l5rev=" + rev, "--memory", mem, "--cpus", cpu]
    for k, v in env.items(): args += ["-e", "%s=%s" % (k, v)]
    sh(*(args + [img])); ev("created pod (template %s, %s)" % (tmpl, img))
for x in stale + ok[want:]: sh("sudo", "docker", "rm", "-f", x[0]); ev("deleted pod %s (stale or surplus)" % x[0][:12])
cms = {d["metadata"]["name"]: sorted(d.get("data", {}).keys()) for d in docs if d["kind"] == "ConfigMap"}
svc = [d["metadata"]["name"] for d in docs if d["kind"] == "Service"]
final = [x for x in live() if x[2] == "running"]
st = {"revision": rev, "sync": "Synced" if len(final) == want and all(x[1] == tmpl for x in final) else "OutOfSync", "health": "Healthy" if len(final) == want else "Progressing",
      "replicas": len(final), "desired": want, "image": img, "env": env, "limits": {"memory": mem, "cpus": cpu}, "configmaps": cms, "services": svc}
json.dump(st, open(STATE, "w"), indent=1); ev("rev %s %s/%s replicas=%d image=%s configmaps=%s" % (rev, st["sync"], st["health"], len(final), img, list(cms)))
