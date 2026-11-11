#!/usr/bin/env python3
# Envoy bootstrap for one Istio-style hop: node.cluster = Jaeger service name; HCM tracing -> Zipkin collector (Jaeger :9411), 100% sampling.
# usage: gen.py <service-name> <listen-port> <routes-json> <cluster:host1,host2;...>
import sys, json, yaml
svc, port, routes, clusters = sys.argv[1], int(sys.argv[2]), json.loads(sys.argv[3]), sys.argv[4]
P = "type.googleapis.com/envoy."
def cl(name, hosts):
    return {"name": name, "type": "STRICT_DNS", "connect_timeout": "2s", "lb_policy": "ROUND_ROBIN", "dns_lookup_family": "V4_ONLY",
            "load_assignment": {"cluster_name": name, "endpoints": [{"lb_endpoints": [{"endpoint": {"address": {"socket_address": {"address": h.split(":")[0], "port_value": int(h.split(":")[1])}}}} for h in hosts]}]}}
cls = [cl("zipkin", ["jaeger:9411"])] + [cl(c.split("=")[0], c.split("=")[1].split(",")) for c in clusters.split(";")]
hcm = {"@type": P + "extensions.filters.network.http_connection_manager.v3.HttpConnectionManager", "stat_prefix": svc, "generate_request_id": True,
       "tracing": {"random_sampling": {"value": 100}, "provider": {"name": "envoy.tracers.zipkin", "typed_config": {"@type": P + "config.trace.v3.ZipkinConfig",
                   "collector_cluster": "zipkin", "collector_endpoint": "/api/v2/spans", "collector_endpoint_version": "HTTP_JSON", "shared_span_context": False}}},
       "route_config": {"name": svc, "virtual_hosts": [{"name": svc, "domains": ["*"], "routes": routes}]},
       "http_filters": [{"name": "envoy.filters.http.router", "typed_config": {"@type": P + "extensions.filters.http.router.v3.Router"}}]}
cfg = {"node": {"id": svc + "~sidecar", "cluster": svc}, "admin": {"address": {"socket_address": {"address": "0.0.0.0", "port_value": 15000}}},
       "static_resources": {"listeners": [{"name": "0.0.0.0_%d" % port, "address": {"socket_address": {"address": "0.0.0.0", "port_value": port}},
         "filter_chains": [{"filters": [{"name": "envoy.filters.network.http_connection_manager", "typed_config": hcm}]}]}], "clusters": cls}}
print(yaml.safe_dump(cfg, sort_keys=False))
