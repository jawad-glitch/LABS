#!/usr/bin/env python3
# Argo CD app emulation for webapp-dev: clone main over HTTP, kustomize build environments/dev (ComparisonError on failure),
# schedule against real node capacity, converge real containers per Deployment, prune extras (selfHeal).
import sys, os, json, subprocess, tempfile, time, yaml
URL, PATH, STATE, LOG, NCPU, NMEM = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], int(sys.argv[5]), int(sys.argv[6])
def sh(*a, check=True): return subprocess.run(a, capture_output=True, text=True, check=check)
def ev(m):
    l = "%s [webapp-dev] %s" % (time.strftime("%H:%M:%S"), m); print(l); open(LOG, "a").write(l + "\n")
def q(v, mem):
    v = str(v)
    if mem: return int(v[:-2]) * (1024 if v.endswith("Gi") else 1) if v[-2:] in ("Gi", "Mi") else int(v) // 1048576
    return int(v[:-1]) / 1000 if v.endswith("m") else float(v)
tmp = tempfile.mkdtemp(); sh("git", "clone", "-q", "--depth", "1", "--branch", "main", URL, tmp); rev = sh("git", "-C", tmp, "rev-parse", "--short", "HEAD").stdout.strip()
b = sh("kubectl", "kustomize", os.path.join(tmp, PATH), check=False)
st = {"revision": rev, "deployments": {}}
if b.returncode != 0:
    st.update(sync="Unknown", health="Unknown", condition="ComparisonError: " + (b.stderr.strip().splitlines() or ["?"])[-1][:160])
    ev("rev %s %s - nothing applied, live state unchanged" % (rev, st["condition"])); json.dump(st, open(STATE, "w")); sys.exit(0)
docs = [d for d in yaml.safe_load_all(b.stdout) if d]; health = "Healthy"
for dep in [d for d in docs if d["kind"] == "Deployment"]:
    name = dep["metadata"]["name"]; c = dep["spec"]["template"]["spec"]["containers"][0]; want = dep["spec"]["replicas"]
    req = c.get("resources", {}).get("requests", {}); env = {e["name"]: e["value"] for e in c.get("env", [])}
    lv = lambda: [l.split() for l in sh("sudo", "docker", "ps", "-a", "--filter", "label=l16dep=" + name, "--format", "{{.ID}} {{.State}}").stdout.splitlines() if l.strip()]
    cur = lv(); s = {"desired": want, "image": c["image"]}
    if len(cur) != want: ev("rev %s %s drift/change: live %d desired %d" % (rev, name, len(cur), want))
    if q(req.get("cpu", "0"), False) > NCPU or q(req.get("memory", "0"), True) > NMEM:
        s["status"] = "Pending (0/1 nodes: Insufficient cpu/memory: requests cpu=%s mem=%s vs node %d CPU / %d Mi)" % (req.get("cpu"), req.get("memory"), NCPU, NMEM)
        health = "Degraded"; ev("rev %s %s %s" % (rev, name, s["status"]))
    else:
        for _ in range(max(0, want - len(cur))):
            a = ["sudo", "docker", "run", "-d", "--label", "l16=1", "--label", "l16dep=" + name]
            for k, v in env.items(): a += ["-e", "%s=%s" % (k, v)]
            r = sh(*(a + [c["image"]]), check=False)
            if r.returncode != 0: s["status"] = "ImagePullBackOff"; health = "Degraded"; ev("rev %s %s ErrImagePull %s" % (rev, name, c["image"])); break
            ev("rev %s %s pod created" % (rev, name))
        for x in cur[want:]: sh("sudo", "docker", "rm", "-f", x[0]); ev("rev %s %s selfHeal: removed surplus pod %s" % (rev, name, x[0][:12]))
    s["running"] = len([x for x in lv() if x[1] == "running"]); s.setdefault("status", "Running" if s["running"] == want else "Progressing")
    st["deployments"][name] = s
for gone in set(l.split()[0] for l in sh("sudo", "docker", "ps", "-a", "--filter", "label=l16=1", "--format", "{{.Label \"l16dep\"}}").stdout.split()) - set(st["deployments"]):
    for x in sh("sudo", "docker", "ps", "-aq", "--filter", "label=l16dep=" + gone).stdout.split(): sh("sudo", "docker", "rm", "-f", x)
    ev("rev %s prune: %s removed (no longer in Git)" % (rev, gone))
st.update(sync="Synced", health=health); json.dump(st, open(STATE, "w")); ev("rev %s Synced/%s %s" % (rev, health, {k: (v["running"], v["status"]) for k, v in st["deployments"].items()}))
