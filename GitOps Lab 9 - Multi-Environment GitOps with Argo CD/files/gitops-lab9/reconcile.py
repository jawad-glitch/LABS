#!/usr/bin/env python3
# Argo CD app emulation: clone targetRevision (branch) over HTTP, read path, converge real containers. auto=0 -> report OutOfSync only unless mode=sync.
import sys, os, json, subprocess, tempfile, hashlib, time, yaml
URL, BRANCH, PATH, ENV, AUTO, MODE, STATE, LOG, HTMLDIR = sys.argv[1:10]
def sh(*a, check=True): return subprocess.run(a, capture_output=True, text=True, check=check)
def ev(m):
    l = "%s [gitops-app-%s] %s" % (time.strftime("%H:%M:%S"), ENV, m); print(l); open(LOG, "a").write(l + "\n")
tmp = tempfile.mkdtemp(); sh("git", "clone", "-q", "--depth", "1", "--branch", BRANCH, URL, tmp)
rev = sh("git", "-C", tmp, "rev-parse", "--short", "HEAD").stdout.strip()
docs = [d for f in sorted(os.listdir(os.path.join(tmp, PATH))) if f.endswith(".yaml") for d in yaml.safe_load_all(open(os.path.join(tmp, PATH, f))) if d]
dep = next(d for d in docs if d["kind"] == "Deployment"); c = dep["spec"]["template"]["spec"]["containers"][0]
want, img = dep["spec"]["replicas"], c["image"]; html = open(os.path.join(tmp, "app/index.html")).read()
hp = os.path.join(HTMLDIR, "%s-%s.html" % (ENV, rev)); open(hp, "w").write(html); os.chmod(hp, 0o644)
tmpl = hashlib.sha1(json.dumps([img, html, c.get("env")], sort_keys=True).encode()).hexdigest()[:10]
lv = lambda: [l.split() for l in sh("sudo", "docker", "ps", "-a", "--filter", "label=l9env=" + ENV, "--format", "{{.ID}} {{.Label \"l9tmpl\"}} {{.State}}").stdout.splitlines() if l.strip()]
cur = lv(); ok = [x for x in cur if x[1] == tmpl and x[2] == "running"]
synced = len(ok) == want and len(cur) == want
health = "Healthy"
if not synced and AUTO == "0" and MODE != "sync":
    ev("rev %s OutOfSync (live %d, desired %d) - automated sync disabled, waiting for manual sync" % (rev, len(cur), want))
else:
    if not synced: ev("rev %s syncing: live %d (matching %d) -> desired %d image=%s" % (rev, len(cur), len(ok), want, img))
    made = 0
    for _ in range(max(0, want - len(ok))):
        a = ["sudo", "docker", "run", "-d", "--label", "l9=1", "--label", "l9env=" + ENV, "--label", "l9tmpl=" + tmpl, "-v", hp + ":/usr/share/nginx/html/index.html:ro"]
        for e in c.get("env", []): a += ["-e", "%s=%s" % (e["name"], e["value"])]
        r = sh(*(a + [img]), check=False)
        if r.returncode != 0:
            health = "Degraded"; ev("rev %s pod create FAILED for %s: %s - keeping %d old pods (rollout stuck)" % (rev, img, (r.stderr.strip().splitlines() or ["?"])[-1][:120], len(cur))); break
        made += 1; ev("rev %s created pod (%s)" % (rev, img))
    if health == "Healthy":
        for x in [x for x in cur if x not in ok] + ok[want:]: sh("sudo", "docker", "rm", "-f", x[0]); ev("rev %s removed old/surplus pod %s" % (rev, x[0][:12]))
run = [x for x in lv() if x[2] == "running"]; final_ok = [x for x in run if x[1] == tmpl]
st = {"app": "gitops-app-" + ENV, "branch": BRANCH, "revision": rev, "auto": AUTO == "1", "desired": want, "running": len(run), "matching": len(final_ok), "image": img,
      "sync": "Synced" if len(final_ok) == want and len(run) == want else "OutOfSync", "health": health if run else "Missing"}
json.dump(st, open(STATE, "w")); ev("rev %s %s/%s running=%d desired=%d" % (rev, st["sync"], st["health"], len(run), want))
