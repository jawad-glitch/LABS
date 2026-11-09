import sys, os, json, subprocess, tempfile, yaml, shutil, random, string
env, url, mode, selfheal, force, statedir, logf = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4] == "1", sys.argv[5] == "1", sys.argv[6], sys.argv[7]
def sh(*a): return subprocess.run(a, capture_output=True, text=True)
def D(*a): return sh("sudo", "-n", "docker", *a)
def fetch():
    d = tempfile.mkdtemp(); r = sh("git", "clone", "-q", "--depth", "1", url, d)
    if r.returncode: return None, None, "repo error: " + r.stderr.strip()
    rev = sh("git", "-C", d, "rev-parse", "--short", "HEAD").stdout.strip(); res = {}; err = None
    for fn in sorted(os.listdir(d + "/manifests")):
        try:
            for o in yaml.safe_load_all(open(d + "/manifests/" + fn)):
                if o: res["%s/%s" % (o["kind"], o["metadata"]["name"])] = o
        except Exception as e: err = "ComparisonError: failed to parse %s: %s" % (fn, str(e).splitlines()[0])
    shutil.rmtree(d); return rev, res, err
def live(): return [l.split() for l in D("ps", "--filter", "label=lab19=1", "--filter", "label=env=" + env, "--format", "{{.Names}} {{.Image}}").stdout.splitlines()]
def dep(res): o = res["Deployment/sample-app"]; return o["spec"]["replicas"], o["spec"]["template"]["spec"]["containers"][0]["image"], o["metadata"].get("labels", {})
sf = os.path.join(statedir, env + ".json"); st = json.load(open(sf)) if os.path.exists(sf) else {"resources": {}, "revision": None, "degraded": False, "note": ""}
def apply(res, rev):
    rep, img, _ = dep(res); p = D("pull", "-q", img)
    if p.returncode:
        st.update(degraded=True, note="new ReplicaSet ImagePullBackOff: " + (p.stderr.strip().splitlines() or ["pull failed"])[-1][:160])
    else:
        st.update(degraded=False, note="")
        for n, i in live():
            if i != img: D("rm", "-f", n)
        cur = live()
        while len(cur) < rep:
            D("run", "-d", "--name", "l19-%s-%s" % (env, "".join(random.choices(string.ascii_lowercase, k=5))), "--label", "lab19=1", "--label", "env=" + env, img); cur = live()
        while len(cur) > rep: D("rm", "-f", cur[-1][0]); cur = live()
    st.update(resources=res, revision=rev); json.dump(st, open(sf, "w"))
rev, res, err = fetch(); action = "none"; sync = "Unknown"
if err: note = err
else:
    if res != st["resources"]:
        if mode == "auto" or force: apply(res, rev); action = "manual-sync" if force else "auto-sync"
    elif st["resources"] and not st["degraded"]:
        rep, img, _ = dep(res); lv = [c for c in live() if c[1] == img]
        if len(lv) != rep:
            if selfheal or force: apply(res, rev); action = "self-heal" if selfheal else "manual-sync"
            else: action = "drift-detected(selfHeal off)"
    sync = "Synced" if res == st["resources"] else "OutOfSync"; note = st.get("note", "")
health = "Missing"
if st["resources"]:
    rep, img, labels = dep(st["resources"]); n = len([c for c in live() if c[1] == img])
    health = "Degraded" if st["degraded"] else ("Healthy" if n == rep else "Progressing")
    line = "APP sample-app-%s repo=%s live-rev=%s sync=%s health=%s replicas=%d/%d image=%s version-label=%s policy=%s selfHeal=%s action=%s %s" % (env, rev, st["revision"], sync, health, n, rep, img, labels.get("version", "-"), mode, selfheal, action, note)
else: line = "APP sample-app-%s repo=%s sync=%s health=Missing policy=%s action=%s %s" % (env, rev, sync, mode, action, note)
print(line); open(logf, "a").write(line + "\n")
