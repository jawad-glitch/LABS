#!/usr/bin/env python3
# Argo Rollouts canary emulation on real containers. sync = Argo CD apply from Git (selfHeal re-applies Git spec);
# promote [--full] / abort / undo / status mirror kubectl argo rollouts. NGINX "ingress" container does weight + X-Canary routing.
import sys, os, json, math, time, subprocess, tempfile, types, yaml
CMD = sys.argv[1:]; URL, ST, LOG, CONF = os.environ["RO_URL"], os.environ["RO_STATE"], os.environ["RO_LOG"], os.environ["RO_CONF"]; NET = "l18net"
def sh(*a, check=True): return subprocess.run(a, capture_output=True, text=True, check=check)
def ev(m):
    l = "%s [demo-app] %s" % (time.strftime("%H:%M:%S"), m); print(l); open(LOG, "a").write(l + "\n")
def load():
    try: return json.load(open(ST))
    except Exception: return {"stable": None, "canary": None, "spec_image": None, "step": 0, "weight": 0, "phase": "None", "pods": {"stable": [], "canary": []}, "revisions": [], "runs": [], "replicas": 5, "steps": [], "templates": {}}
def save(s): json.dump(s, open(ST, "w"), indent=1)
def mk(role, image):
    return sh("sudo", "docker", "run", "-d", "--label", "l18=1", "--network", NET, "--network-alias", "demo-app-%s.production" % role, image).stdout.strip()
def scale(s, role, image, n):
    ids = s["pods"][role]
    while len(ids) < n: ids.append(mk(role, image))
    while len(ids) > n: sh("sudo", "docker", "rm", "-f", ids.pop(), check=False)
def ingress(s, w):
    split = "" if w <= 0 else ("split_clients \"${request_id}\" $pool { 100%% canary; }\n" if w >= 100 else "split_clients \"${request_id}\" $pool { %d%% canary; * stable; }\n" % w)
    pool = "$pool" if w > 0 else "stable"
    open(CONF, "w").write(split + "map $http_x_canary $route { \"true\" %s; default %s; }\nserver { listen 80; resolver 127.0.0.11 valid=1s; location / { set $up http://demo-app-$route.production; proxy_pass $up; } }\n" % ("canary" if s["canary"] else "stable", pool))
    os.chmod(CONF, 0o644)
    if not sh("sudo", "docker", "ps", "-q", "--filter", "name=^l18-ingress$").stdout.strip():
        sh("sudo", "docker", "rm", "-f", "l18-ingress", check=False)
        sh("sudo", "docker", "run", "-d", "--name", "l18-ingress", "--label", "l18=1", "--network", NET, "-p", "127.0.0.1:8091:80", "-v", CONF + ":/etc/nginx/conf.d/default.conf:ro", "nginx:1.27-alpine"); time.sleep(1)
    else: sh("sudo", "docker", "exec", "l18-ingress", "nginx", "-s", "reload"); time.sleep(0.5)
def ns(o):
    return types.SimpleNamespace(**{k: ns(v) for k, v in o.items()}) if isinstance(o, dict) else o
def analysis(s, name):
    m = s["templates"][name]["spec"]["metrics"][0]; iv = int(str(m.get("interval", "5s")).rstrip("s")); cnt = int(m.get("count", 1)); fl = int(m.get("failureLimit", 0))
    url = m["provider"]["web"]["url"]; host = url.split("//")[1].split("/")[0].replace(".svc.cluster.local", ""); path = "/" + url.split("//")[1].split("/", 1)[1]
    run = {"name": "demo-app-%s-%d" % (s["canary"].split(":")[1], len(s["runs"]) + 1), "template": name, "condition": m["successCondition"], "measurements": []}; fails = 0
    for i in range(cnt):
        body = sh("sudo", "docker", "exec", "l18-ingress", "wget", "-qO-", "-T", "3", "http://%s%s" % (host, path), check=False).stdout.strip()
        try: ok = bool(eval(m["successCondition"], {}, {"result": ns(json.loads(body))}))
        except Exception: ok = False
        run["measurements"].append({"value": body, "phase": "Successful" if ok else "Failed"}); fails += (not ok)
        ev("AnalysisRun %s measurement %d: %s -> %s" % (run["name"], i + 1, body, "Successful" if ok else "Failed"))
        if fails > fl: break
        if i < cnt - 1: time.sleep(iv)
    run["phase"] = "Failed" if fails > fl else "Successful"; s["runs"].append(run); ev("AnalysisRun %s %s (failures %d, failureLimit %d)" % (run["name"], run["phase"], fails, fl)); return run["phase"] == "Successful"
def abort(s, why):
    scale(s, "canary", s["canary"], 0); s["weight"] = 0; ingress(s, 0); s["phase"] = "Degraded"; s["message"] = why; ev("Rollout aborted: %s -> 100%% traffic on stable %s" % (why, s["stable"]))
def full(s):
    for c in s["pods"]["stable"]: sh("sudo", "docker", "rm", "-f", c, check=False)
    for c in s["pods"]["canary"]:
        sh("sudo", "docker", "network", "disconnect", NET, c, check=False); sh("sudo", "docker", "network", "connect", "--alias", "demo-app-stable.production", NET, c)
    s["pods"]["stable"], s["pods"]["canary"] = s["pods"]["canary"], []
    scale(s, "stable", s["canary"], s["replicas"]); s["stable"], s["canary"] = s["canary"], None; s["weight"] = 0; s["step"] = 0; ingress(s, 0)
    s["phase"] = "Healthy"; s["revisions"].append(s["stable"]); s.pop("message", None); ev("fully promoted: stable is now %s (%d pods)" % (s["stable"], s["replicas"]))
def run_steps(s):
    while s["canary"]:
        if s["step"] >= len(s["steps"]): full(s); return
        st = s["steps"][s["step"]]
        if "setWeight" in st:
            w = st["setWeight"]; s["weight"] = w; scale(s, "canary", s["canary"], math.ceil(s["replicas"] * w / 100)); ingress(s, w); s["step"] += 1
            ev("step %d setWeight %d: canary %s pods=%d, stable pods=%d" % (s["step"], w, s["canary"], len(s["pods"]["canary"]), len(s["pods"]["stable"])))
        elif "pause" in st:
            d = (st.get("pause") or {}).get("duration")
            if d: time.sleep(min(int(str(d).rstrip("s")), 3)); s["step"] += 1; ev("step %d pause %s elapsed (compressed to <=3s)" % (s["step"], d))
            else: s["phase"] = "Paused"; ev("step %d pause {} - Paused (CanaryPauseStep) at weight %d" % (s["step"] + 1, s["weight"])); return
        elif "analysis" in st:
            s["phase"] = "Progressing"
            if not analysis(s, st["analysis"]["templates"][0]["templateName"]): abort(s, "metric \"health\" assessed Failed"); return
            s["step"] += 1
def sync(s):
    tmp = tempfile.mkdtemp(); sh("git", "clone", "-q", "--depth", "1", URL, tmp)
    docs = [d for d in yaml.safe_load_all(sh("kubectl", "kustomize", tmp + "/apps/demo-app/overlays/production").stdout) if d]
    ro = next(d for d in docs if d["kind"] == "Rollout"); img = ro["spec"]["template"]["spec"]["containers"][0]["image"]
    s["steps"], s["replicas"] = ro["spec"]["strategy"]["canary"]["steps"], ro["spec"]["replicas"]
    s["templates"] = {d["metadata"]["name"]: d for d in docs if d["kind"] == "AnalysisTemplate"}; s["git_rev"] = sh("git", "-C", tmp, "rev-parse", "--short", "HEAD").stdout.strip()
    if s["spec_image"] and s["spec_image"] != img: ev("Argo CD sync %s: live Rollout image %s != Git %s -> applying" % (s["git_rev"], s["spec_image"], img))
    if s["stable"] is None:
        s["spec_image"] = s["stable"] = img; scale(s, "stable", img, s["replicas"]); ingress(s, 0); s["phase"] = "Healthy"; s["revisions"] = [img]; ev("initial: %d stable pods %s" % (s["replicas"], img)); return
    if img == s["stable"]:
        if s["canary"]: scale(s, "canary", s["canary"], 0); s["canary"] = None; s["weight"] = 0; s["step"] = 0; ingress(s, 0); ev("spec matches stable %s: canary dropped" % img)
        s["spec_image"] = img; s["phase"] = "Healthy"; s.pop("message", None); return
    if s["canary"] == img and s["spec_image"] == img: return
    s["spec_image"] = img; s["canary"] = img; s["step"] = 0; s["phase"] = "Progressing"; s.pop("message", None); ev("new revision %s: canary started" % img); run_steps(s)
s = load(); c = CMD[0]
if c == "sync": sync(s)
elif c == "promote":
    if "--full" in CMD and s["canary"]: full(s)
    elif s["phase"] == "Paused": s["step"] += 1; s["phase"] = "Progressing"; ev("promote: resuming from step %d" % s["step"]); run_steps(s)
elif c == "abort": abort(s, "manual abort")
elif c == "undo":
    if s["canary"]: scale(s, "canary", s["canary"], 0)
    s["canary"] = None; s["spec_image"] = s["stable"]; s["weight"] = 0; s["step"] = 0; ingress(s, 0); s["phase"] = "Healthy"; s.pop("message", None); ev("undo: live Rollout spec set to previous revision %s (Git unchanged)" % s["stable"])
save(s)
imgs = {}
for r in ("stable", "canary"):
    for i in s["pods"][r]: imgs.setdefault(sh("sudo", "docker", "inspect", "-f", "{{.Config.Image}}", i, check=False).stdout.strip(), 0); imgs[sh("sudo", "docker", "inspect", "-f", "{{.Config.Image}}", i, check=False).stdout.strip()] += 1
print("STATUS phase=%s step=%d weight=%d stable=%s canary=%s pods=%s lastAnalysis=%s %s" % (s["phase"], s["step"], s["weight"], s["stable"], s["canary"], json.dumps(imgs, sort_keys=True), (s["runs"][-1]["phase"] if s["runs"] else "-"), s.get("message", "")))
