#!/usr/bin/env python3
# Translate Istio VirtualServices (+ DestinationRule subsets) into an Envoy config for one context:
#   gateway: VS whose gateways include backend-gateway;  mesh: VS with no gateways (or "mesh") whose hosts include backend-service.
# If no VS applies, traffic goes to the plain Kubernetes Service (all endpoints, round robin) - exactly what happens in Istio.
import sys, yaml
ctx = sys.argv[1]; files = sys.argv[2:]
docs = [d for f in files for d in yaml.safe_load_all(open(f)) if d and d.get("kind") == "VirtualService"]
def applies(v):
    g = v["spec"].get("gateways")
    if ctx == "gateway": return bool(g) and "backend-gateway" in g
    return (not g or "mesh" in g) and any(h in ("backend-service", "backend-service.ab-testing.svc.cluster.local") for h in v["spec"]["hosts"])
vs = next((v for v in docs if applies(v)), None)
cl = lambda s: "outbound|80|%s|backend-service.ab-testing.svc.cluster.local" % (s or "")
routes = []
if vs is None:
    routes.append({"match": {"prefix": "/"}, "route": {"cluster": cl("")}})
else:
    for h in vs["spec"]["http"]:
        m = {"prefix": "/"}
        hdrs = [{"name": k, "string_match": {"exact": v["exact"]}} for mm in h.get("match", []) for k, v in mm.get("headers", {}).items()]
        if hdrs: m["headers"] = hdrs
        wc = [{"name": cl(r["destination"].get("subset")), "weight": r.get("weight", 100)} for r in h["route"] if r.get("weight", 100) > 0]
        routes.append({"match": m, "route": {"weighted_clusters": {"clusters": wc}}})
def cluster(sub):
    host = "backend-" + sub if sub else "backend-service"
    return {"name": cl(sub), "type": "STRICT_DNS", "connect_timeout": "1s", "lb_policy": "ROUND_ROBIN", "dns_lookup_family": "V4_ONLY",
            "load_assignment": {"cluster_name": cl(sub), "endpoints": [{"lb_endpoints": [{"endpoint": {"address": {"socket_address": {"address": host, "port_value": 80}}}}]}]}}
cfg = {"admin": {"address": {"socket_address": {"address": "0.0.0.0", "port_value": 15000}}},
       "static_resources": {"listeners": [{"name": "0.0.0.0_8080", "address": {"socket_address": {"address": "0.0.0.0", "port_value": 8080}},
          "filter_chains": [{"filters": [{"name": "envoy.filters.network.http_connection_manager", "typed_config": {
             "@type": "type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager", "stat_prefix": ctx,
             "route_config": {"name": ctx, "virtual_hosts": [{"name": "backend", "domains": ["*"], "routes": routes}]},
             "http_filters": [{"name": "envoy.filters.http.router", "typed_config": {"@type": "type.googleapis.com/envoy.extensions.filters.http.router.v3.Router"}}]}}]}]}],
       "clusters": [cluster(None), cluster("v1"), cluster("v2")]}}
print("# VirtualService applied in %s context: %s" % (ctx, vs["metadata"]["name"] if vs else "NONE (plain Service round robin)"))
print(yaml.safe_dump(cfg, sort_keys=False))
