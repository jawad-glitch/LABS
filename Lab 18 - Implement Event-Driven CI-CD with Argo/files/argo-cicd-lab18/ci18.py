import sys, json, socket, threading, time, uuid, yaml, os, datetime, copy, random, string, subprocess, hmac, hashlib, re
from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler
def log(*a): print(*a, flush=True)
class Nats:
    def __init__(s, port=4223):
        s.sock = socket.create_connection(("127.0.0.1", port)); s.f = s.sock.makefile("rb"); s.f.readline(); s.lock = threading.Lock()
        s.sock.sendall(b'CONNECT {"verbose":false,"pedantic":false}\r\nPING\r\n'); s.f.readline()
    def pub(s, subj, data):
        with s.lock: s.sock.sendall(("PUB %s %d\r\n" % (subj, len(data))).encode() + data + b"\r\n")
    def sub(s, subj): s.sock.sendall(("SUB %s 1\r\n" % subj).encode())
    def loop(s, cb):
        while True:
            line = s.f.readline()
            if not line: break
            if line.startswith(b"PING"): s.sock.sendall(b"PONG\r\n")
            elif line.startswith(b"MSG"):
                p = line.split(); n = int(p[-1]); payload = s.f.read(n); s.f.read(2); cb(p[1].decode(), payload)
def keys(path): return [k.replace("\\.", ".") for k in re.split(r"(?<!\\)\.", path)]
def getp(d, path):
    for p in keys(path):
        if isinstance(d, list) and p.isdigit() and int(p) < len(d): d = d[int(p)]
        elif isinstance(d, dict) and p in d: d = d[p]
        else: return None
    return d
def setp(d, path, v):
    ps = keys(path)
    for p in ps[:-1]: d = d[int(p)] if isinstance(d, list) else d.setdefault(p, {})
    if isinstance(d, list): d[int(ps[-1])] = v
    else: d[ps[-1]] = v
def filters_ok(dep, data):
    for f in (dep.get("filters") or {}).get("data", []):
        v = getp(data, f["path"])
        if v is None or str(v) not in [str(x) for x in f["value"]]: return False, "path %s -> %r (want %s)" % (f["path"], v, f["value"])
    return True, "all data filters matched"
def labels_ok(flt, labels):
    ls = (flt or {}).get("labels") or []
    if not isinstance(ls, list): return None
    return all(labels.get(l["key"]) == l["value"] for l in ls)
ART_MSG = "You need to configure artifact storage. More information on how to do this can be found in the docs: https://argo-workflows.readthedocs.io/en/latest/configure-artifact-repository/"
def uses_artifacts(templates): return any((t.get("outputs") or {}).get("artifacts") or (t.get("inputs") or {}).get("artifacts") for t in templates)
class World:
    def __init__(s, base, results, secret_file):
        s.base, s.res = base, results; y = lambda f: yaml.safe_load(open(os.path.join(base, f)))
        s.wfts = {w["metadata"]["name"]: w for w in (y("ci-testing-template.yaml"), y("cd-deployment-template.yaml"))}
        s.ghes, s.wfes = y("github-eventsource.yaml"), y("workflow-event-source.yaml"); s.secret = yaml.safe_load(open(secret_file))
        s.sensors = [y("github-ci-sensor.yaml"), y("workflow-cd-sensor.yaml")]
        s.bus = Nats(); s.lock = threading.Lock(); s.active = 0; s.phases = {}; s.nev = 0
    def publish(s, es, ev, typ, data):
        e = {"context": {"id": uuid.uuid4().hex, "source": es, "subject": ev, "type": typ, "time": datetime.datetime.now(datetime.timezone.utc).isoformat()}, "data": data}
        with s.lock: s.nev += 1; n = s.nev
        json.dump(e, open(os.path.join(s.res, "events", "%02d-%s-%s.json" % (n, es, typ)), "w"), indent=1)
        s.bus.pub("eventbus.default.%s.%s" % (es, ev), json.dumps(e).encode()); log("EVENT %s/%s %s" % (es, ev, typ))
    def github_server(s):
        for evname, cfg in s.ghes["spec"]["github"].items():
            wh = cfg["webhook"]; ws = cfg.get("webhookSecret"); secret = s.secret["stringData"][ws["key"]] if ws else None; world = s
            class H(BaseHTTPRequestHandler):
                def log_message(self, *a): pass
                def reply(self, code, msg): self.send_response(code); self.end_headers(); self.wfile.write(msg.encode()); log("GITHUB-ES %s %s -> %d %s" % (self.command, self.path, code, msg))
                def do_POST(self):
                    if self.path != wh["endpoint"]: return self.reply(404, "not found")
                    raw = self.rfile.read(int(self.headers.get("Content-Length", 0))); et = self.headers.get("X-GitHub-Event")
                    if et not in cfg.get("events", []): return self.reply(400, "event type %r not in %s" % (et, cfg.get("events")))
                    if secret:
                        exp = "sha256=" + hmac.new(secret.encode(), raw, hashlib.sha256).hexdigest()
                        if not hmac.compare_digest(self.headers.get("X-Hub-Signature-256", ""), exp): return self.reply(400, "invalid signature")
                    world.publish(world.ghes["metadata"]["name"], evname, "github", {"headers": {k: [v] for k, v in self.headers.items()}, "body": json.loads(raw)})
                    self.reply(200, "success")
                def do_GET(self): self.reply(405, "method not allowed")
            srv = ThreadingHTTPServer(("127.0.0.1", int(wh["port"])), H); threading.Thread(target=srv.serve_forever, daemon=True).start()
            log("GITHUB-ES listening 127.0.0.1:%s %s events=%s signed=%s" % (wh["port"], wh["endpoint"], cfg.get("events"), bool(secret)))
    def admin_server(s):
        world = s
        class A(BaseHTTPRequestHandler):
            def log_message(self, *a): pass
            def do_POST(self):
                world.submit(yaml.safe_load(self.rfile.read(int(self.headers.get("Content-Length", 0)))), "kubectl create")
                self.send_response(201); self.end_headers()
            def do_GET(self):
                self.send_response(200); self.end_headers(); self.wfile.write(json.dumps({"active": world.active, "phases": world.phases}).encode())
        srv = ThreadingHTTPServer(("127.0.0.1", 18080), A); threading.Thread(target=srv.serve_forever, daemon=True).start()
    def on_event(s, subj, payload):
        ev = json.loads(payload)
        for sn in s.sensors:
            for dep in sn["spec"]["dependencies"]:
                if dep["eventSourceName"] != ev["context"]["source"] or dep["eventName"] != ev["context"]["subject"]: continue
                ok, why = filters_ok(dep, ev["data"])
                if not ok: log("SENSOR %s FILTERED %s" % (sn["metadata"]["name"], why)); continue
                for t in sn["spec"]["triggers"]:
                    aw = t["template"]["argoWorkflow"]; wf = copy.deepcopy(aw["source"]["resource"]); err = None
                    for p in aw.get("parameters", []):
                        v = getp(ev["data"], p["src"]["dataKey"]); v = p["src"].get("value") if v is None else v
                        if v is None: err = "cannot resolve %s" % p["src"]["dataKey"]; break
                        setp(wf, p["dest"], str(v))
                    if err: log("SENSOR %s ERROR %s" % (sn["metadata"]["name"], err)); continue
                    s.submit(wf, "sensor %s" % sn["metadata"]["name"])
    def submit(s, wf, by):
        md = wf["metadata"]; md["name"] = md["generateName"] + "".join(random.choices(string.ascii_lowercase + string.digits, k=5)) if "generateName" in md else md["name"]
        md.setdefault("labels", {})
        with s.lock: s.active += 1; s.phases[md["name"]] = "Pending"
        log("SUBMITTED %s by %s args=%s" % (md["name"], by, json.dumps((wf["spec"].get("arguments") or {}).get("parameters", []))))
        threading.Thread(target=s.run, args=(wf,)).start()
    def set_phase(s, wf, phase, msg=""):
        md = wf["metadata"]; md["labels"]["workflows.argoproj.io/phase"] = phase
        if phase in ("Succeeded", "Failed", "Error"): md["labels"]["workflows.argoproj.io/completed"] = "true"
        wf.setdefault("status", {})["phase"] = phase
        if msg: wf["status"]["message"] = msg
        s.phases[md["name"]] = phase; yaml.safe_dump(wf, open(os.path.join(s.base, "cluster", "Workflow-%s.yaml" % md["name"]), "w"), sort_keys=False)
        log("WORKFLOW %s %s %s" % (md["name"], phase, msg))
        for evname, cfg in s.wfes["spec"]["resource"].items():
            if cfg.get("namespace") not in (None, md.get("namespace")) or "UPDATE" not in cfg.get("eventTypes", []): continue
            if labels_ok(cfg.get("filter"), md["labels"]): s.publish(s.wfes["metadata"]["name"], evname, "resource", {"type": "UPDATE", "body": copy.deepcopy(wf), "group": cfg["group"], "version": cfg["version"], "resource": cfg["resource"]})
    def run(s, wf):
        try: s._run(wf)
        except Exception as e: s.set_phase(wf, "Error", repr(e))
        finally:
            with s.lock: s.active -= 1
    def _run(s, wf):
        name = wf["metadata"]["name"]; ref = (wf["spec"].get("workflowTemplateRef") or {}).get("name")
        base = copy.deepcopy(s.wfts[ref]["spec"]) if ref else {}; spec = dict(base); spec.update({k: v for k, v in wf["spec"].items() if k not in ("workflowTemplateRef", "arguments")})
        params = {p["name"]: p.get("value") for p in (base.get("arguments") or {}).get("parameters", [])}
        params.update({p["name"]: p.get("value") for p in (wf["spec"].get("arguments") or {}).get("parameters", [])})
        tm = {t["name"]: t for t in spec["templates"]}; s.set_phase(wf, "Running")
        if uses_artifacts(tm.values()): return s.set_phase(wf, "Error", ART_MSG)
        vct = [v["metadata"]["name"] for v in spec.get("volumeClaimTemplates", [])]; ws = None
        if vct: ws = os.path.join(s.base, "workspaces", name); os.makedirs(ws); os.chmod(ws, 0o777)
        gsub = lambda x: re.sub(r"\{\{workflow\.parameters\.([\w-]+)\}\}", lambda m: str(params.get(m.group(1), "")), x)
        entry = tm[spec["entrypoint"]]; nodes = {}
        if "dag" in entry:
            tasks = entry["dag"]["tasks"]; done = set()
            while len(done) < len(tasks):
                progressed = False
                for t in tasks:
                    if t["name"] in done or not all(d in done for d in t.get("dependencies", [])): continue
                    progressed = True; done.add(t["name"])
                    if any(nodes.get(d) in ("Failed", "Error", "Omitted") for d in t.get("dependencies", [])): nodes[t["name"]] = "Omitted"; continue
                    if t.get("when"):
                        e = gsub(t["when"]); m = re.match(r"^\s*'([^']*)'\s*==\s*'([^']*)'\s*$", e)
                        if not m: nodes[t["name"]] = "Error"; log("TASK %s/%s when %r: invalid expression" % (name, t["name"], e)); continue
                        if m.group(1) != m.group(2): nodes[t["name"]] = "Skipped"; log("TASK %s/%s skipped (when %s)" % (name, t["name"], e)); continue
                    inputs = {p["name"]: gsub(str(p.get("value", ""))) for p in (t.get("arguments") or {}).get("parameters", [])}
                    nodes[t["name"]] = "Succeeded" if s.container(name, t["name"], tm[t["template"]], inputs, params, ws, vct) == 0 else "Failed"
                if not progressed: break
        else: nodes[entry["name"]] = "Succeeded" if s.container(name, entry["name"], entry, {}, params, ws, vct) == 0 else "Failed"
        wf["status"] = {"nodes": nodes}; s.set_phase(wf, "Failed" if any(v in ("Failed", "Error") for v in nodes.values()) else "Succeeded")
    def container(s, wfname, step, tmpl, inputs, params, ws, vct):
        c = tmpl["container"]
        def sub(x):
            x = re.sub(r"\{\{inputs\.parameters\.([\w-]+)\}\}", lambda m: str(inputs.get(m.group(1), "")), x)
            return re.sub(r"\{\{workflow\.parameters\.([\w-]+)\}\}", lambda m: str(params.get(m.group(1), "")), x)
        mounts = []
        for vm in c.get("volumeMounts", []):
            if vm["name"] in vct and ws: mounts += ["-v", "%s:%s" % (ws, vm["mountPath"])]
        command = [sub(x) for x in c.get("command", [])]; args = [sub(x) for x in c.get("args", [])]
        cmd = ["sudo", "-n", "docker", "run", "--rm", "--label", "lab18=1", "--name", "l18-%s-%s" % (wfname, step)] + mounts + (["--entrypoint", command[0]] if command else []) + [c["image"]] + command[1:] + args
        log("TASK %s/%s start image=%s" % (wfname, step, c["image"]))
        with open(os.path.join(s.res, "runs", "%s-%s.log" % (wfname, step)), "w") as f: rc = subprocess.call(cmd, stdout=f, stderr=subprocess.STDOUT)
        log("TASK %s/%s rc=%d" % (wfname, step, rc)); return rc
def eval_original(base, res):
    y = lambda f: yaml.safe_load(open(os.path.join(base, "lab-original", f)))
    evs = sorted(os.listdir(os.path.join(res, "events"))); load = lambda f: json.load(open(os.path.join(res, "events", f)))
    push = next(load(f) for f in evs if f.endswith("-github.json"))
    ci = y("github-ci-sensor.yaml"); wf = copy.deepcopy(ci["spec"]["triggers"][0]["template"]["argoWorkflow"]["source"]["resource"])
    for p in ci["spec"]["triggers"][0]["template"]["argoWorkflow"]["parameters"]: setp(wf, p["dest"], str(getp(push["data"], p["src"]["dataKey"])))
    print("ORIG-CI-SENSOR resolved params:", json.dumps(wf["spec"]["arguments"]["parameters"]))
    print("ORIG-CI-TEMPLATE artifacts used:", uses_artifacts(y("ci-template-artifacts.yaml")["spec"]["templates"]), "->", ART_MSG)
    succ = [load(f) for f in evs if f.endswith("-resource.json") and load(f)["data"]["body"]["metadata"].get("generateName") == "ci-pipeline-"]
    if succ:
        ok, why = filters_ok(y("workflow-cd-sensor.yaml")["spec"]["dependencies"][0], succ[0]["data"]); print("ORIG-CD-SENSOR filter on real CI-success event:", ok, why)
        ok2, why2 = filters_ok(yaml.safe_load(open(os.path.join(base, "workflow-cd-sensor.yaml")))["spec"]["dependencies"][0], succ[0]["data"]); print("FIXED-CD-SENSOR filter on same event:", ok2, why2)
    print("ORIG-WORKFLOW-ES labels filter valid list:", labels_ok(y("workflow-event-source.yaml")["spec"]["resource"]["example"]["filter"], {}) is not None)
    return wf["spec"]["arguments"]["parameters"][0]["value"]
if __name__ == "__main__":
    if sys.argv[1] == "world":
        w = World(sys.argv[2], sys.argv[3], sys.argv[4]); w.github_server(); w.admin_server()
        sub = Nats(); sub.sub("eventbus.default.>"); threading.Thread(target=sub.loop, args=(w.on_event,), daemon=True).start()
        while True: time.sleep(3600)
    else: print("ORIG-REPO-URL", eval_original(sys.argv[2], sys.argv[3]))
