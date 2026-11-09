import sys, yaml
for d in yaml.safe_load_all(open(sys.argv[1])):
    if not d: continue
    k = d.get("kind"); n = (d.get("metadata") or {}).get("name"); s = d.get("spec") or {}
    print(f"OBJ {k} {n}")
    if k in ("Deployment", "StatefulSet", "DaemonSet", "Job"):
        pod = (s.get("template") or {}).get("spec") or {}
        for c in (pod.get("containers") or []) + (pod.get("initContainers") or []):
            print(f"IMAGE {n} {c.get('image')}")
    if k == "Service":
        print("SVCPORTS %s %s" % (n, ",".join(str(p.get("port")) for p in s.get("ports", []))))
    if k in ("ConfigMap", "Secret"):
        for key in list((d.get("data") or {}).keys()) + list((d.get("stringData") or {}).keys()):
            print(f"KEY {k} {n} {key}")
