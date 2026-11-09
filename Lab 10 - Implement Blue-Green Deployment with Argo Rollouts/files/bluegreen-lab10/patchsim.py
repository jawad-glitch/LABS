import sys, yaml, json, copy
ro = [d for d in yaml.safe_load_all(open(sys.argv[1])) if d and d.get("kind") == "Rollout"][0]
def merge(t, p):
    if not isinstance(p, dict): return copy.deepcopy(p)
    t = copy.deepcopy(t) if isinstance(t, dict) else {}
    for k, v in p.items():
        if v is None: t.pop(k, None)
        else: t[k] = merge(t.get(k), v)
    return t
def jpatch(doc, ops):
    doc = copy.deepcopy(doc)
    for op in ops:
        parts = [int(x) if x.isdigit() else x for x in op["path"].strip("/").split("/")]
        cur = doc
        for p in parts[:-1]: cur = cur[p]
        cur[parts[-1]] = op["value"]
    return doc
m = merge(ro, json.load(open(sys.argv[2]))); j = jpatch(ro, json.load(open(sys.argv[3])))
c = m["spec"]["template"]["spec"]["containers"][0]; d = j["spec"]["template"]["spec"]["containers"][0]
print("MERGE container keys:", sorted(c.keys()))
print("MERGE image:", c.get("image")); print("MERGE volumeMounts:", c.get("volumeMounts"))
print("JSONPATCH container keys:", sorted(d.keys()))
print("JSONPATCH image:", d.get("image")); print("JSONPATCH env:", d.get("env"))
print("JSONPATCH configMap:", j["spec"]["template"]["spec"]["volumes"][0]["configMap"]["name"])
print("JSONPATCH volumeMounts:", d.get("volumeMounts"))
