import sys, yaml
for d in yaml.safe_load_all(open(sys.argv[1])):
    if not d: continue
    k = d.get("kind"); n = d["metadata"]["name"]; s = d.get("spec") or {}
    print(f"OBJ {k} {n}")
    if k == "Deployment":
        for c in s["template"]["spec"]["containers"]: print(f"IMAGE {n} {c['image']}")
    if k == "CustomResourceDefinition":
        nm = s.get("names", {}); print(f"CRDNAMES {n} plural={nm.get('plural')} short={','.join(nm.get('shortNames') or [])} kind={nm.get('kind')}")
    if k == "ConfigMap" and n == "argo-events-controller-config":
        cfg = yaml.safe_load(list(d["data"].values())[0])
        js = (cfg.get("eventBus") or {}).get("jetstream") or {}
        for v in js.get("versions", []): print(f"JSVERSION {v.get('version')} {v.get('natsImage')}")
