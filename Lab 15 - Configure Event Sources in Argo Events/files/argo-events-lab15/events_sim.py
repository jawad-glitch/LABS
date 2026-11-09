import sys, json, socket, threading, time, uuid, yaml, os, datetime, copy, random, string
from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler
class Nats:
    def __init__(s):
        s.sock = socket.create_connection(("127.0.0.1", 4222)); s.f = s.sock.makefile("rb"); s.f.readline()
        s.lock = threading.Lock(); s.sock.sendall(b'CONNECT {"verbose":false,"pedantic":false,"name":"lab15"}\r\nPING\r\n'); s.f.readline()
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
def event(es, name, typ, data):
    return json.dumps({"context": {"id": uuid.uuid4().hex, "source": es, "subject": name, "type": typ, "specversion": "1.0",
                                   "time": now().strftime("%Y-%m-%dT%H:%M:%SZ"), "datacontenttype": "application/json"}, "data": data}).encode()
def eventsource(wh_file, cron_file, nodeport, interval):
    nats = Nats()
    def pub(es, name, typ, data): nats.pub("eventbus.default.%s.%s" % (es, name), event(es, name, typ, data)); print("PUBLISHED %s/%s %s" % (es, name, typ), flush=True)
    wh = yaml.safe_load(open(wh_file)); es = wh["metadata"]["name"]
    for evname, cfg in wh["spec"]["webhook"].items():
        ep, method = cfg["endpoint"], cfg["method"].upper()
        class H(BaseHTTPRequestHandler):
            def log_message(self, *a): pass
            def any(self):
                if self.path.split("?")[0] != ep: self.send_response(404); self.end_headers(); return
                if self.command != method: self.send_response(405); self.end_headers(); self.wfile.write(b"method not allowed"); return
                raw = self.rfile.read(int(self.headers.get("Content-Length", 0)))
                try: body = json.loads(raw or b"{}")
                except Exception: body = raw.decode(errors="replace")
                pub(es, evname, "webhook", {"header": {k: [v] for k, v in self.headers.items()}, "body": body, "metadata": {}})
                self.send_response(200); self.end_headers(); self.wfile.write(b"success")
            do_GET = do_POST = do_PUT = any
        for port in sorted({int(cfg["port"]), int(nodeport)}):
            srv = ThreadingHTTPServer(("127.0.0.1", port), H); threading.Thread(target=srv.serve_forever, daemon=True).start()
            print("WEBHOOK listening 127.0.0.1:%d %s %s (eventsource %s/%s)" % (port, method, ep, es, evname), flush=True)
    cr = yaml.safe_load(open(cron_file)); ces = cr["metadata"]["name"]
    for evname, cfg in cr["spec"]["calendar"].items():
        def tick(evname=evname, cfg=cfg):
            while True:
                time.sleep(interval)
                pub(ces, evname, "calendar", {"eventTime": str(now()), "metadata": {"schedule": cfg.get("schedule"), "timezone": cfg.get("timezone")}})
        threading.Thread(target=tick, daemon=True).start()
        print("CALENDAR %s/%s schedule=%r (compressed to every %ss)" % (ces, evname, cfg.get("schedule"), interval), flush=True)
    while True: time.sleep(3600)
def getp(d, path):
    for p in path.split("."):
        if isinstance(d, dict) and p in d: d = d[p]
        else: return None
    return d
def setp(d, path, v):
    ps = path.split(".")
    for p in ps[:-1]: d = d.setdefault(p, {})
    d[ps[-1]] = v
def sensor(outdir, files):
    sensors = [yaml.safe_load(open(f)) for f in files]; created = set(); nats = Nats(); nats.sub("eventbus.default.>")
    def cb(subj, payload):
        ev = json.loads(payload); src, name = ev["context"]["source"], ev["context"]["subject"]
        for s in sensors:
            for dep in s["spec"]["dependencies"]:
                if dep["eventSourceName"] != src or dep["eventName"] != name: continue
                for t in s["spec"]["triggers"]:
                    tn = "%s/%s" % (s["metadata"]["name"], t["template"]["name"]); k = t["template"]["k8s"]; res = copy.deepcopy(k["source"]["resource"]); err = None
                    for p in k.get("parameters", []):
                        if p["src"]["dependencyName"] != dep["name"]: continue
                        v = getp(ev["data"], p["src"]["dataKey"])
                        if v is None: v = p["src"].get("value")
                        if v is None: err = "failed to resolve parameter %s (no data at %s, no default value)" % (p["dest"], p["src"]["dataKey"]); break
                        setp(res, p["dest"], str(v))
                    if err: print("TRIGGER %s ERROR %s" % (tn, err), flush=True); continue
                    md = res["metadata"]
                    if "generateName" in md: md["name"] = md.pop("generateName") + "".join(random.choices(string.ascii_lowercase + string.digits, k=5))
                    if md["name"] in created: print('TRIGGER %s ERROR create: configmaps "%s" already exists' % (tn, md["name"]), flush=True); continue
                    created.add(md["name"]); yaml.safe_dump(res, open(os.path.join(outdir, md["name"] + ".yaml"), "w"), sort_keys=False)
                    print("TRIGGER %s CREATED ConfigMap %s" % (tn, md["name"]), flush=True)
    nats.loop(cb)
if __name__ == "__main__":
    if sys.argv[1] == "eventsource": eventsource(sys.argv[2], sys.argv[3], sys.argv[4], float(sys.argv[5]))
    else: sensor(sys.argv[2], sys.argv[3:])
