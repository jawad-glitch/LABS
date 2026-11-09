import sys, yaml, json
for d in yaml.safe_load_all(open(sys.argv[1])):
    if not d: continue
    k = d.get("kind"); n = d["metadata"]["name"]
    print(f"OBJ {k} {n}")
    if k == "CustomResourceDefinition":
        print(f"CRDSIZE {n} {len(json.dumps(d, separators=(',', ':')))}")
