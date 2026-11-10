#!/usr/bin/env python3
# Argo CD app emulation: kustomize build/plain dir at HEAD over HTTP -> converge real containers.
# Deployments: nginx pods with ConfigMap html mounted live, network alias <service>.<namespace> (cluster DNS analogue).
# ExternalName Service: production nginx proxy resolving the target alias per request (like a CNAME).
import sys, os, json, subprocess, tempfile, hashlib, time, yaml
URL, PATH, APP, STATE, LOG, HTMLDIR, NET = sys.argv[1:8]
def sh(*a, check=True): return subprocess.run(a, capture_output=True, text=True, check=check)
def ev(m):
    l = "%s [%s] %s" % (time.strftime("%H:%M:%S"), APP, m); print(l); open(LOG, "a").write(l + "\n")
tmp = tempfile.mkdtemp(); sh("git", "clone", "-q", "--depth", "1", URL, tmp); rev = sh("git", "-C", tmp, "rev-parse", "--short", "HEAD").stdout.strip()
p = os.path.join(tmp, PATH)
docs = [d for d in yaml.safe_load_all(sh("kubectl", "kustomize", p).stdout) if d] if os.path.exists(p + "/kustomization.yaml") else \
       [d for f in sorted(os.listdir(p)) if f.endswith(".yaml") for d in yaml.safe_load_all(open(os.path.join(p, f))) if d]
st = {"app": APP, "revision": rev}
for s in [d for d in docs if d["kind"] == "Service" and d["spec"].get("type") == "ExternalName"]:
    host = s["spec"]["externalName"]; alias = ".".join(host.split(".")[:2]); conf = os.path.join(HTMLDIR, "production-nginx.conf")
    open(conf, "w").write("server { listen 80; location / { resolver 127.0.0.11 valid=1s; set $u http://%s; proxy_pass $u; } }\n" % alias); os.chmod(conf, 0o644)
    if not sh("sudo", "docker", "ps", "-q", "--filter", "name=^l17-production$").stdout.strip():
        sh("sudo", "docker", "rm", "-f", "l17-production", check=False)
        sh("sudo", "docker", "run", "-d", "--name", "l17-production", "--label", "l17=1", "--network", NET, "-p", "127.0.0.1:8090:80", "-v", conf + ":/etc/nginx/conf.d/default.conf:ro", "nginx:1.27-alpine")
        time.sleep(1)
    else: sh("sudo", "docker", "exec", "l17-production", "nginx", "-s", "reload")
    st.update(externalName=host, active=alias.split(".")[1].replace("-env", "")); ev("rev %s production-service -> %s" % (rev, host))
for dep in [d for d in docs if d["kind"] == "Deployment"]:
    ns = dep["metadata"]["namespace"]; tpl = dep["spec"]["template"]; labels = tpl["metadata"]["labels"]; c = tpl["spec"]["containers"][0]; want = dep["spec"]["replicas"]
    svc = next(d for d in docs if d["kind"] == "Service" and all(labels.get(k) == v for k, v in d["spec"].get("selector", {}).items()))
    cmn = next(v["configMap"]["name"] for v in tpl["spec"]["volumes"] if "configMap" in v); cm = next(d for d in docs if d["kind"] == "ConfigMap" and d["metadata"]["name"] == cmn)
    hp = os.path.join(HTMLDIR, "%s-%s.html" % (ns, cmn))
    if not os.path.exists(hp): open(hp, "w").close(); os.chmod(hp, 0o644)
    with open(hp, "r+") as f: f.seek(0); f.truncate(); f.write(cm["data"]["index.html"])
    tmpl = hashlib.sha1(json.dumps(tpl, sort_keys=True).encode()).hexdigest()[:10]; alias = "%s.%s" % (svc["metadata"]["name"], ns)
    lv = lambda: [l.split() for l in sh("sudo", "docker", "ps", "-a", "--filter", "label=l17ns=" + ns, "--format", "{{.ID}} {{.Label \"l17tmpl\"}} {{.State}}").stdout.splitlines() if l.strip()]
    cur = lv(); ok = [x for x in cur if x[1] == tmpl and x[2] == "running"]
    for _ in range(max(0, want - len(ok))):
        a = ["sudo", "docker", "run", "-d", "--label", "l17=1", "--label", "l17ns=" + ns, "--label", "l17tmpl=" + tmpl, "--network", NET, "--network-alias", alias, "-v", hp + ":/usr/share/nginx/html/index.html:ro"]
        for k, v in labels.items(): a += ["--label", "k8s.%s=%s" % (k, v)]
        sh(*(a + [c["image"]]))
    for x in [x for x in cur if x not in ok] + ok[want:]: sh("sudo", "docker", "rm", "-f", x[0])
    n = len([x for x in lv() if x[2] == "running"]); st.update(namespace=ns, desired=want, running=n, alias=alias, sync="Synced", health="Healthy" if n == want else "Progressing")
    ev("rev %s %s/sample-app %d/%d pods, alias %s, %s" % (rev, ns, n, want, alias, st["health"]))
st.setdefault("sync", "Synced"); st.setdefault("health", "Healthy"); json.dump(st, open(STATE, "w"))
