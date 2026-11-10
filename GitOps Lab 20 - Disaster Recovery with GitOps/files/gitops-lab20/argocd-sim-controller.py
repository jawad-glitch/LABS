#!/usr/bin/env python3
# Autonomous Argo CD emulation for sample-web-app: every ~2s fetch Git main over HTTP, compare with live state, apply/self-heal.
# Live state = Docker: namespace -> network l20-sample-app, Deployment pods -> containers (alias web-app.sample-app), ConfigMap -> file mounted in place.
# A pause file freezes reconciliation (used only to observe a degraded state deterministically).
import sys, os, json, subprocess, time, hashlib, yaml
URL, PATH, STATE, LOG, HTMLDIR, PAUSE, NET = sys.argv[1:8]
WD = os.path.join(HTMLDIR, ".repo"); backoff = {}
def sh(*a, check=True): return subprocess.run(a, capture_output=True, text=True, check=check)
def ev(m):
    l = "%s [sample-web-app] %s" % (time.strftime("%H:%M:%S"), m); open(LOG, "a").write(l + "\n")
def net_exists(): return sh("sudo", "docker", "network", "inspect", NET, check=False).returncode == 0
def reconcile():
    if not os.path.exists(WD): sh("git", "clone", "-q", URL, WD)
    sh("git", "-C", WD, "fetch", "-q", "origin"); sh("git", "-C", WD, "reset", "-q", "--hard", "origin/main")
    rev = sh("git", "-C", WD, "rev-parse", "--short", "HEAD").stdout.strip()
    docs = [d for f in sorted(os.listdir(os.path.join(WD, PATH))) if f.endswith(".yaml") for d in yaml.safe_load_all(open(os.path.join(WD, PATH, f))) if d]
    dep = next(d for d in docs if d["kind"] == "Deployment"); cm = next(d for d in docs if d["kind"] == "ConfigMap"); svc = next(d for d in docs if d["kind"] == "Service")
    if not net_exists(): sh("sudo", "docker", "network", "create", NET); ev("rev %s namespace sample-app missing -> created (CreateNamespace=true)" % rev)
    hp = os.path.join(HTMLDIR, "web-app-html.html")
    if not os.path.exists(hp): open(hp, "w").close(); os.chmod(hp, 0o644)
    if open(hp).read() != cm["data"]["index.html"]:
        with open(hp, "r+") as f: f.seek(0); f.truncate(); f.write(cm["data"]["index.html"])
    c = dep["spec"]["template"]["spec"]["containers"][0]; want = dep["spec"]["replicas"]; img = c["image"]
    tmpl = hashlib.sha1(json.dumps(dep["spec"]["template"], sort_keys=True).encode()).hexdigest()[:10]; alias = "%s.sample-app" % svc["metadata"]["name"]
    lv = [l.split() for l in sh("sudo", "docker", "ps", "-a", "--filter", "label=l20app=web-app", "--format", "{{.ID}} {{.Label \"l20tmpl\"}} {{.State}}").stdout.splitlines() if l.strip()]
    for x in [x for x in lv if x[2] != "running"]: sh("sudo", "docker", "rm", "-f", x[0], check=False)
    run = [x for x in lv if x[2] == "running"]; ok = [x for x in run if x[1] == tmpl]; old = [x for x in run if x[1] != tmpl]; pull_err = False
    if len(ok) < want:
        if not run: ev("rev %s Deployment web-app missing/empty -> applying (selfHeal), %d x %s" % (rev, want, img))
        if time.time() >= backoff.get(img, 0):
            for _ in range(want - len(ok)):
                r = sh("sudo", "docker", "run", "-d", "--label", "l20=1", "--label", "l20app=web-app", "--label", "l20tmpl=" + tmpl, "--label", "app.kubernetes.io/instance=sample-web-app",
                       "--network", NET, "--network-alias", alias, "-v", hp + ":/usr/share/nginx/html/index.html:ro", img, check=False)
                if r.returncode != 0:
                    pull_err = True; backoff[img] = time.time() + 6; ev("rev %s new pod ErrImagePull %s (old pods kept: %d)" % (rev, img, len(old))); break
                ok.append([r.stdout.strip()[:12], tmpl, "running"])
        else: pull_err = True
    if not pull_err and len(ok) >= want:
        for x in old + ok[want:]: sh("sudo", "docker", "rm", "-f", x[0], check=False)
        if old: ev("rev %s rollout complete: %d old pods removed" % (rev, len(old)))
    running = len([l for l in sh("sudo", "docker", "ps", "--filter", "label=l20app=web-app", "--format", "{{.ID}}").stdout.split()])
    ready_new = len([x for x in ok if x[2] == "running"]) if not pull_err else 0
    health = "Degraded" if pull_err else ("Healthy" if running == want else "Progressing")
    st = {"revision": rev, "image": img, "desired": want, "running": running, "ready_current": ready_new, "errimagepull_pods": 1 if pull_err else 0,
          "namespace": "Active" if net_exists() else "Missing", "sync": "Synced", "health": health, "ts": time.time()}
    json.dump(st, open(STATE + ".tmp", "w")); os.replace(STATE + ".tmp", STATE)
while True:
    if os.path.exists(PAUSE): time.sleep(0.3); continue
    try: reconcile()
    except Exception as e: ev("reconcile error: %s" % e)
    time.sleep(2)
