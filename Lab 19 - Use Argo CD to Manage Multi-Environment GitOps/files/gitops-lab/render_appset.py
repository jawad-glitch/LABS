import sys, yaml, re, copy
def merge(a, b):
    for k, v in b.items(): a[k] = merge(a.get(k, {}), v) if isinstance(v, dict) and isinstance(a.get(k), dict) else v
    return a
s = yaml.safe_load(open(sys.argv[1])); go = s["spec"].get("goTemplate", False); out = []
for el in s["spec"]["generators"][0]["list"]["elements"]:
    def r(txt):
        if go:
            txt = re.sub(r'\{\{\s*eq \.(\w+) "([^"]*)"\s*\}\}', lambda m: "true" if str(el.get(m.group(1))) == m.group(2) else "false", txt)
            return re.sub(r"\{\{\s*\.(\w+)\s*\}\}", lambda m: str(el[m.group(1)]), txt)
        return re.sub(r"\{\{(\w+)\}\}", lambda m: str(el.get(m.group(1), m.group(0))), txt)
    app = yaml.safe_load(r(yaml.safe_dump(s["spec"]["template"], sort_keys=False)))
    if s["spec"].get("templatePatch"): app = merge(app, yaml.safe_load(r(s["spec"]["templatePatch"])))
    app = {"apiVersion": "argoproj.io/v1alpha1", "kind": "Application", "metadata": dict(app["metadata"], namespace="argocd"), "spec": app["spec"]}
    out.append(app)
print(yaml.safe_dump_all(out, sort_keys=False))
