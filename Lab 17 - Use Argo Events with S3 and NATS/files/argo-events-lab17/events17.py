import sys, json, socket, threading, time, uuid, yaml, os, datetime, copy, random, string, subprocess
def log(*a): print(*a, flush=True)
class Nats:
    def __init__(s, port):
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
def eventsource(es_file, rawdir):
    es = yaml.safe_load(open(es_file)); name = es["metadata"]["name"]; bus = Nats(4223)
    for evname, cfg in es["spec"]["nats"].items():
        broker = Nats(4222); broker.sub(cfg["subject"]); log("NATS-ES %s/%s subscribed to %s (%s)" % (name, evname, cfg["subject"], cfg["url"]))
        def cb(subj, payload, evname=evname):
            body = json.loads(payload) if cfg.get("jsonBody") else payload.decode()
            n = len(os.listdir(rawdir)) + 1; open(os.path.join(rawdir, "s3-event-%d.json" % n), "wb").write(payload)
            ev = {"context": {"id": uuid.uuid4().hex, "source": name, "subject": evname, "type": "nats", "time": datetime.datetime.now(datetime.timezone.utc).isoformat()},
                  "data": {"subject": subj, "body": body, "header": {}, "metadata": {}}}
            bus.pub("eventbus.default.%s.%s" % (name, evname), json.dumps(ev).encode())
            log("RECEIVED %s %s -> PUBLISHED to EventBus" % (subj, (body.get("EventName") if isinstance(body, dict) else "")))
        threading.Thread(target=broker.loop, args=(cb,), daemon=True).start()
    while True: time.sleep(3600)
def sensor(variant, cluster, runs, wft_file, sensor_file):
    s = yaml.safe_load(open(sensor_file)); wft = yaml.safe_load(open(wft_file)); bus = Nats(4223); bus.sub("eventbus.default.>")
    def run(wf):
        args = {p["name"]: p.get("value") for p in wft["spec"]["arguments"]["parameters"]}
        args.update({p["name"]: p["value"] for p in wf["spec"]["arguments"]["parameters"]})
        t = [x for x in wft["spec"]["templates"] if x["name"] == wft["spec"]["entrypoint"]][0]; c = t["container"]
        sub = lambda x: [x := x.replace("{{inputs.parameters.%s}}" % k, str(v)) for k, v in args.items()][-1]
        name = wf["metadata"]["name"]; cmd = ["sudo", "-n", "docker", "run", "--rm", "--label", "lab17=1", "--name", "l17-%s-%s" % (variant, name), c["image"]] + [sub(x) for x in c.get("command", [])] + [sub(x) for x in c.get("args", [])]
        with open(os.path.join(runs, "%s-%s.log" % (variant, name)), "w") as f: rc = subprocess.call(cmd, stdout=f, stderr=subprocess.STDOUT)
        wf["status"] = {"phase": "Succeeded" if rc == 0 else "Failed"}; yaml.safe_dump(wf, open(os.path.join(cluster, "Workflow-%s.yaml" % name), "w"), sort_keys=False)
        log("WORKFLOW %s %s args=%s" % (name, wf["status"]["phase"], json.dumps(args)))
    def cb(subj, payload):
        ev = json.loads(payload)
        for dep in s["spec"]["dependencies"]:
            if dep["eventSourceName"] != ev["context"]["source"] or dep["eventName"] != ev["context"]["subject"]: continue
            for t in s["spec"]["triggers"]:
                aw = t["template"]["argoWorkflow"]; wf = copy.deepcopy(aw["source"]["resource"]); err = None
                for p in aw.get("parameters", []):
                    v = getp(ev["data"], p["src"]["dataKey"])
                    if v is None: v = p["src"].get("value")
                    if v is None: err = "failed to resolve dataKey %s (event data keys: %s)" % (p["src"]["dataKey"], sorted(ev["data"])); break
                    setp(wf, p["dest"], str(v))
                if err: log("TRIGGER %s ERROR %s" % (t["template"]["name"], err)); continue
                wf["metadata"]["name"] = wf["metadata"].pop("generateName") + "".join(random.choices(string.ascii_lowercase + string.digits, k=5))
                log("TRIGGER %s SUBMITTED Workflow %s" % (t["template"]["name"], wf["metadata"]["name"])); threading.Thread(target=run, args=(wf,)).start()
    bus.loop(cb)
if __name__ == "__main__":
    a = sys.argv
    if a[1] == "eventsource": eventsource(a[2], a[3])
    else: sensor(a[2], a[3], a[4], a[5], a[6])
