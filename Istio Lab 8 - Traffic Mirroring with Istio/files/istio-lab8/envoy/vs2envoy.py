#!/usr/bin/env python3
# Istio VirtualService http rules -> Envoy routes. route subset v1|v2 (or none = Service = both pods) ; mirror -> request_mirror_policies
# with runtime_fraction (mirrorPercentage). Envoy suffixes the Host of mirrored requests with "-shadow" and does not wait for their response.
import sys, yaml
vsf, ip1, ip2, ctx = sys.argv[1:5]
vs = next(d for d in yaml.safe_load_all(open(vsf)) if d and d["kind"] == "VirtualService")
cn = lambda s: "outbound|9080|%s|productpage.traffic-mirror-demo.svc.cluster.local" % (s or "")
routes = []
for h in vs["spec"]["http"]:
    d = h["route"][0]["destination"]; act = {"cluster": cn(d.get("subset")), "timeout": "10s"}
    if "mirror" in h:
        pct = h.get("mirrorPercentage", {}).get("value", 100.0)
        act["request_mirror_policies"] = [{"cluster": cn(h["mirror"].get("subset")), "runtime_fraction": {"default_value": {"numerator": int(round(pct * 10000)), "denominator": "MILLION"}}}]
    for m in (h.get("match") or [{}]):
        em = {"prefix": "/"}
        if "uri" in m: em = {"path": m["uri"]["exact"]} if "exact" in m["uri"] else {"prefix": m["uri"]["prefix"]}
        hd = [{"name": k, "string_match": {"exact": v["exact"]}} for k, v in m.get("headers", {}).items()]
        if hd: em["headers"] = hd
        routes.append({"match": em, "route": act})
def cl(sub, ips):
    return {"name": cn(sub), "type": "STATIC", "connect_timeout": "2s", "lb_policy": "ROUND_ROBIN",
            "load_assignment": {"cluster_name": cn(sub), "endpoints": [{"lb_endpoints": [{"endpoint": {"address": {"socket_address": {"address": ip, "port_value": 15006}}}} for ip in ips]}]}}
cfg = {"admin": {"address": {"socket_address": {"address": "0.0.0.0", "port_value": 15000}}},
       "static_resources": {"listeners": [{"name": ctx, "address": {"socket_address": {"address": "0.0.0.0", "port_value": 8080}},
         "filter_chains": [{"filters": [{"name": "envoy.filters.network.http_connection_manager", "typed_config": {
            "@type": "type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager", "stat_prefix": ctx,
            "route_config": {"name": ctx, "virtual_hosts": [{"name": "productpage", "domains": ["*"], "routes": routes}]},
            "http_filters": [{"name": "envoy.filters.http.router", "typed_config": {"@type": "type.googleapis.com/envoy.extensions.filters.http.router.v3.Router"}}]}}]}]}],
       "clusters": [cl(None, [ip1, ip2]), cl("v1", [ip1]), cl("v2", [ip2])]}}
print(yaml.safe_dump(cfg, sort_keys=False))
