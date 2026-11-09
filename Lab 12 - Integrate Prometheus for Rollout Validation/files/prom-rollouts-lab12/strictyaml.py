import sys, yaml
class L(yaml.SafeLoader): pass
def cm(loader, node, deep=False):
    seen = set()
    for k, _ in node.value:
        key = loader.construct_object(k, deep=deep)
        if key in seen: raise yaml.constructor.ConstructorError(None, None, "duplicate mapping key: %s" % key, k.start_mark)
        seen.add(key)
    return yaml.SafeLoader.construct_mapping(loader, node, deep)
L.add_constructor(yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, cm)
for f in sys.argv[1:]:
    list(yaml.load_all(open(f), Loader=L)); print("OK", f)
