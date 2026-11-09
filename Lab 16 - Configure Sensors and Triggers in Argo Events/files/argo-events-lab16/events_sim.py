import sys, json, socket, threading, time, uuid, yaml, os, datetime, copy, random, string, subprocess, glob
from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler
def log(*a): print(*a, flush=True)
class Nats:
    def __init__(s):
        s.sock = socket.create_connection(("127.0.0.1", 4222)); s.f = s.sock.makefile("rb"); s.f.readline(); s.lock = threading.Lock()
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
def now(): return datetime.datetime.now(datetime.timezone.utc)
def getp(d, path):
    for p in path.split("."):
        if isinstance(d, list) and p.isdigit() and int(p) < len(d): d = d[int(p)]
        elif isinstance(d, dict) and p in d: d = d[p]
        else: return None
    return d
def setp(d, path, v):
    ps = path.split(".")
    for p in ps[:-1]: d = d[int(p)] if isinstance(d, list) else d.setdefault(p, {})
    if isinstance(d, list): d[int(ps[-1])] = v
    else: d[ps[-1]] = v
def eventsource(variant, port, interval, fsroot, cluster, files):
    nats = Nats()
    def pub(es, name, typ, data):
        ev = {"context": {"id": uuid.uuid4().hex, "source": es, "subject": name, "type": typ, "specversion": "1.0", "time": now().strftime("%Y-%m-%dT%H:%M:%SZ")}, "data": data}
        nats.pub("bus.%s.%s.%s" % (variant, es, name), json.dumps(ev).encode()); log("PUBLISHED %s/%s %s" % (es, name, typ))
    for f in files:
        d = yaml.safe_load(open(f)); es = d["metadata"]["name"]; sp = d["spec"]
        for evname, cfg in (sp.get("webhook") or {}).items():
            ep, method = cfg["endpoint"], cfg["method"].upper()
            class H(BaseHTTPRequestHandler):
                def log_message(self, *a): pass
                def any(self, es=es, evname=evname):
                    if self.path.split("?")[0] != ep or self.command != method: self.send_response(404 if self.path.split("?")[0] != ep else 405); self.end_headers(); return
                    raw = self.rfile.read(int(self.headers.get("Content-Length", 0)))
                    try: body = json.loads(raw or b"{}")
                    except Exception: body = raw.decode(errors="replace")
                    pub(es, evname, "webhook", {"header": {k: [v] for k, v in self.headers.items()}, "body": body}); self.send_response(200); self.end_headers(); self.wfile.write(b"success")
                do_GET = do_POST = any
            srv = ThreadingHTTPServer(("127.0.0.1", int(port)), H); threading.Thread(target=srv.serve_forever, daemon=True).start()
            log("WEBHOOK %s/%s listening 127.0.0.1:%s %s %s" % (es, evname, port, method, ep))
        for evname, cfg in (sp.get("file") or {}).items():
            def watch(es=es, evname=evname, cfg=cfg):
                wp = cfg.get("watchPathConfig") or {}; typ = cfg.get("eventType")
                if not wp.get("directory") or not typ:
                    log("ERROR %s/%s: invalid file event source - eventType and watchPathConfig.directory/path required (got keys %s); event source not started" % (es, evname, sorted(cfg))); return
                dirp = fsroot + wp["directory"]
                if not os.path.isdir(dirp): log("ERROR %s/%s: failed to watch %s: no such file or directory" % (es, evname, wp["directory"])); return
                fp = os.path.join(dirp, wp["path"]); prev = None; log("FILE %s/%s watching %s for %s" % (es, evname, wp["directory"] + "/" + wp["path"], typ))
                while True:
                    st = os.stat(fp).st_mtime_ns if os.path.exists(fp) else None; op = None
                    if prev is None and st is not None: op = "CREATE"
                    elif prev is not None and st is not None and st != prev: op = "WRITE"
                    elif prev is not None and st is None: op = "REMOVE"
                    prev = st
                    if op == typ: pub(es, evname, "file", {"name": wp["directory"] + "/" + wp["path"], "op": op})
                    elif op: log("FILE %s %s ignored (eventType filter %s)" % (op, wp["path"], typ))
                    time.sleep(0.2)
            threading.Thread(target=watch, daemon=True).start()
        for evname, cfg in (sp.get("calendar") or {}).items():
            def tick(es=es, evname=evname, cfg=cfg):
                while True:
                    time.sleep(interval); pub(es, evname, "calendar", {"eventTime": str(now()), "metadata": {"schedule": cfg.get("schedule")}})
            threading.Thread(target=tick, daemon=True).start(); log("CALENDAR %s/%s schedule=%r (compressed to %ss)" % (es, evname, cfg.get("schedule"), interval))
        for evname, cfg in (sp.get("resource") or {}).items():
            def rwatch(es=es, evname=evname, cfg=cfg):
                seen = set(); labels = (cfg.get("filter") or {}).get("labels") or []
                log("RESOURCE %s/%s watching configmaps %s" % (es, evname, labels))
                while True:
                    for fn in sorted(glob.glob(cluster + "/ConfigMap-*.yaml")):
                        if fn in seen: continue
                        seen.add(fn); o = yaml.safe_load(open(fn)); ol = o["metadata"].get("labels") or {}
                        if all(ol.get(l["key"]) == l["value"] for l in labels): pub(es, evname, "resource", {"type": "ADD", "body": o})
                    time.sleep(0.5)
            threading.Thread(target=rwatch, daemon=True).start()
    while True: time.sleep(3600)
def sensor(variant, cluster, runs, files):
    sensors = [yaml.safe_load(open(f)) for f in files]; nats = Nats(); nats.sub("bus.%s.>" % variant)
    def run(kind, name, res):
        spec = res["spec"]["template"]["spec"] if kind == "Job" else res["spec"]; c = spec["containers"][0]; env = []
        for e in c.get("env", []): env += ["-e", "%s=%s" % (e["name"], e.get("value", ""))]
        cmd = ["sudo", "-n", "docker", "run", "--rm", "--label", "lab16=1", "--name", "l16-%s-%s" % (variant, name)] + env + [c["image"]] + c.get("command", []) + c.get("args", [])
        with open(os.path.join(runs, "%s-%s-%s.log" % (variant, kind, name)), "w") as f: rc = subprocess.call(cmd, stdout=f, stderr=subprocess.STDOUT)
        log("RUN %s/%s exited rc=%d" % (kind, name, rc))
    def cb(subj, payload):
        ev = json.loads(payload); src, name = ev["context"]["source"], ev["context"]["subject"]
        for s in sensors:
            for dep in s["spec"]["dependencies"]:
                if dep["eventSourceName"] != src or dep["eventName"] != name: continue
                for t in s["spec"]["triggers"]:
                    tn = "%s/%s" % (s["metadata"]["name"], t["template"]["name"]); k = t["template"]["k8s"]; res = copy.deepcopy(k["source"]["resource"]); err = None
                    for p in k.get("parameters", []):
                        if p["src"]["dependencyName"] != dep["name"]: continue
                        v = getp(ev["context"], p["src"]["contextKey"]) if "contextKey" in p["src"] else getp(ev["data"], p["src"]["dataKey"])
                        if v is None: v = p["src"].get("value")
                        if v is None: err = "cannot resolve %s" % p["dest"]; break
                        setp(res, p["dest"], v if isinstance(v, str) else json.dumps(v))
                    if err: log("TRIGGER %s ERROR %s" % (tn, err)); continue
                    md = res["metadata"]; md["name"] = md.pop("generateName") + "".join(random.choices(string.ascii_lowercase + string.digits, k=5)) if "generateName" in md else md["name"]
                    kind = res["kind"]; fn = os.path.join(cluster, "%s-%s.yaml" % (kind, md["name"])); tmp = fn + ".tmp"
                    yaml.safe_dump(res, open(tmp, "w"), sort_keys=False); os.replace(tmp, fn); log("TRIGGER %s CREATED %s %s" % (tn, kind, md["name"]))
                    if kind in ("Job", "Pod"): threading.Thread(target=run, args=(kind, md["name"], res)).start()
    nats.loop(cb)
if __name__ == "__main__":
    a = sys.argv
    if a[1] == "eventsource": eventsource(a[2], a[3], float(a[4]), a[5], a[6], a[7:])
    else: sensor(a[2], a[3], a[4], a[5:])
