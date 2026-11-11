#!/usr/bin/env python3
# Istio VirtualService + DestinationRule -> ingress gateway Envoy. Subsets = clusters of pod IPs; fault.abort -> per-route HTTP fault filter;
# outlierDetection: consecutive5xxErrors -> consecutive_5xx, consecutiveErrors (deprecated) -> consecutive_gateway_failure only (as Istio does).
# Panic threshold 0 (Istio default) so ejected hosts are really skipped.
import sys, yaml
vs, dr, v1, v2 = yaml.safe_load(open(sys.argv[1])), yaml.safe_load(open(sys.argv[2])), sys.argv[3].split(","), sys.argv[4].split(",")
P = "type.googleapis.com/envoy."; cn = lambda s: "outbound|80|%s|bookstore-service.disaster-recovery.svc.cluster.local" % s
def od(spec):
    if not spec: return None
    o = {"interval": spec.get("interval", "10s"), "base_ejection_time": spec.get("baseEjectionTime", "30s"), "max_ejection_percent": spec.get("maxEjectionPercent", 10)}
    if "consecutive5xxErrors" in spec: o.update(consecutive_5xx=spec["consecutive5xxErrors"])
    elif "consecutiveErrors" in spec: o.update(consecutive_gateway_failure=spec["consecutiveErrors"], enforcing_consecutive_gateway_failure=100, enforcing_consecutive_5xx=0)
    return o
top = (dr["spec"].get("trafficPolicy") or {}).get("outlierDetection")
clusters = []
for sub, ips in (("v1", v1), ("v2", v2)):
    s = next(x for x in dr["spec"]["subsets"] if x["name"] == sub); o = od(((s.get("trafficPolicy") or {}).get("outlierDetection")) or top)
    c = {"name": cn(sub), "type": "STATIC", "connect_timeout": "2s", "lb_policy": "ROUND_ROBIN", "common_lb_config": {"healthy_panic_threshold": {"value": 0}},
         "load_assignment": {"cluster_name": cn(sub), "endpoints": [{"lb_endpoints": [{"endpoint": {"address": {"socket_address": {"address": ip, "port_value": 80}}}} for ip in ips]}]}}
    if o: c["outlier_detection"] = o
    clusters.append(c)
routes = []
for h in vs["spec"]["http"]:
    for m in h.get("match", [{}]):
        em = {"prefix": m.get("uri", {}).get("prefix", "/")}
        hd = [{"name": k, "string_match": {"exact": v["exact"]}} for k, v in m.get("headers", {}).items()]
        if hd: em["headers"] = hd
        wc = [{"name": cn(r["destination"]["subset"]), "weight": r.get("weight", 100)} for r in h["route"] if r.get("weight", 100) > 0]
        rt = {"match": em, "route": {"weighted_clusters": {"clusters": wc}, "timeout": "10s"}}
        if "fault" in h:
            a = h["fault"]["abort"]; rt["typed_per_filter_config"] = {"envoy.filters.http.fault": {"@type": P + "extensions.filters.http.fault.v3.HTTPFault",
                "abort": {"http_status": a["httpStatus"], "percentage": {"numerator": int(a["percentage"]["value"]), "denominator": "HUNDRED"}}}}
        routes.append(rt)
hcm = {"@type": P + "extensions.filters.network.http_connection_manager.v3.HttpConnectionManager", "stat_prefix": "gateway",
       "route_config": {"name": "http.8080", "virtual_hosts": [{"name": "bookstore", "domains": ["*"], "routes": routes}]},
       "http_filters": [{"name": "envoy.filters.http.fault", "typed_config": {"@type": P + "extensions.filters.http.fault.v3.HTTPFault"}},
                        {"name": "envoy.filters.http.router", "typed_config": {"@type": P + "extensions.filters.http.router.v3.Router"}}]}
cfg = {"admin": {"address": {"socket_address": {"address": "0.0.0.0", "port_value": 15000}}}, "static_resources": {
       "listeners": [{"name": "0.0.0.0_8080", "address": {"socket_address": {"address": "0.0.0.0", "port_value": 8080}}, "filter_chains": [{"filters": [{"name": "envoy.filters.network.http_connection_manager", "typed_config": hcm}]}]}],
       "clusters": clusters}}
print(yaml.safe_dump(cfg, sort_keys=False))
