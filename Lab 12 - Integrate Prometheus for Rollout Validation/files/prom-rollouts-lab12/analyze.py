import sys, yaml, json, time, math, urllib.request, urllib.parse
tpl, prom, svc, interval = sys.argv[1], sys.argv[2], sys.argv[3], float(sys.argv[4])
spec = yaml.safe_load(open(tpl))["spec"]; metrics = spec["metrics"]
rounds = max(int(m.get("count", 1)) for m in metrics); st = {m["name"]: {"vals": [], "fail": 0, "err": 0} for m in metrics}
for r in range(rounds):
    for m in metrics:
        if r >= int(m.get("count", 1)): continue
        q = m["provider"]["prometheus"]["query"].replace("{{args.service-name}}", svc)
        try:
            data = json.load(urllib.request.urlopen(prom + "/api/v1/query?" + urllib.parse.urlencode({"query": q}), timeout=5))
            result = [float(x["value"][1]) for x in data["data"]["result"]]
            ok = bool(eval(m["successCondition"], {"__builtins__": {}}, {"result": result, "len": len}))
            st[m["name"]]["vals"].append("%.4f:%s" % (result[0], "Successful" if ok else "Failed"))
            if not ok: st[m["name"]]["fail"] += 1
        except Exception as e:
            st[m["name"]]["err"] += 1; st[m["name"]]["vals"].append("Error(%s)" % type(e).__name__)
    if r < rounds - 1: time.sleep(interval)
overall = "Successful"
for m in metrics:
    s = st[m["name"]]; lim = int(m.get("failureLimit", 0))
    phase = "Failed" if s["fail"] > lim else ("Error" if s["err"] > 4 else ("Successful" if s["err"] == 0 else "Inconclusive"))
    if phase != "Successful": overall = phase if overall == "Successful" or phase == "Failed" else overall
    print("METRIC %s failureLimit=%d measurements=%s failures=%d phase=%s" % (m["name"], lim, ",".join(s["vals"]), s["fail"], phase))
print("ANALYSISRUN phase=%s" % overall)
