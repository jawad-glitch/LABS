import sys, yaml
for d in yaml.safe_load_all(open(sys.argv[1])):
    if not d: continue
    k = d.get("kind"); n = d["metadata"]["name"]; s = d.get("spec") or {}
    print(f"OBJ {k} {n}")
    if k == "Deployment":
        for c in s["template"]["spec"]["containers"]:
            print(f"IMAGE {n} {c['image']}")
    if k == "Service":
        print("SVCPORTS %s %s" % (n, ",".join(str(p.get("port")) for p in s.get("ports", []))))
