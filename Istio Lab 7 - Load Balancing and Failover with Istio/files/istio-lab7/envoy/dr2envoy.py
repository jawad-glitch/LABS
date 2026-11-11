#!/usr/bin/env python3
# DestinationRule (+ optional VirtualService retries) -> Envoy client-sidecar config for outbound|9080|v1|details.
# Endpoints are STATIC pod IPs (what EDS would push). Without a VS retry policy, Istio's default retry policy is applied (2 attempts).
import sys, yaml
dr = yaml.safe_load(open(sys.argv[1])); ips = sys.argv[2].split(","); vs = yaml.safe_load(open(sys.argv[3])) if len(sys.argv) > 3 else None
tp = dr["spec"]["subsets"][0]["trafficPolicy"]; lbmap = {"ROUND_ROBIN": "ROUND_ROBIN", "LEAST_CONN": "LEAST_REQUEST", "LEAST_REQUEST": "LEAST_REQUEST", "RANDOM": "RANDOM"}
name = "outbound|9080|v1|details.lab7-loadbalancing.svc.cluster.local"
cl = {"name": name, "type": "STATIC", "connect_timeout": "1s", "lb_policy": lbmap[tp["loadBalancer"]["simple"]],
      "load_assignment": {"cluster_name": name, "endpoints": [{"lb_endpoints": [{"endpoint": {"address": {"socket_address": {"address": ip, "port_value": 9080}}}} for ip in ips]}]}}
cp = tp.get("connectionPool")
if cp: cl["circuit_breakers"] = {"thresholds": [{"max_connections": cp["tcp"]["maxConnections"], "max_pending_requests": cp["http"]["http1MaxPendingRequests"]}]}
od = tp.get("outlierDetection", {})
if "consecutive5xxErrors" in od:   # consecutiveErrors (removed field) is not translated - exactly as Istio ignores/rejects it
    cl["outlier_detection"] = {"consecutive_5xx": od["consecutive5xxErrors"], "interval": od["interval"], "base_ejection_time": od["baseEjectionTime"], "max_ejection_percent": od["maxEjectionPercent"]}
r = (vs or {}).get("spec", {}).get("http", [{}])[0].get("retries")
rp = {"retry_on": r["retryOn"], "num_retries": r["attempts"], "per_try_timeout": r["perTryTimeout"]} if r else \
     {"retry_on": "connect-failure,refused-stream,unavailable,cancelled,retriable-status-codes", "num_retries": 2}   # Istio default
cfg = {"admin": {"address": {"socket_address": {"address": "0.0.0.0", "port_value": 15000}}},
       "static_resources": {"listeners": [{"name": "outbound_9080", "address": {"socket_address": {"address": "0.0.0.0", "port_value": 9080}},
         "filter_chains": [{"filters": [{"name": "envoy.filters.network.http_connection_manager", "typed_config": {
            "@type": "type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager", "stat_prefix": "outbound_0.0.0.0_9080",
            "route_config": {"name": "9080", "virtual_hosts": [{"name": "details", "domains": ["*"], "routes": [{"match": {"prefix": "/"}, "route": {"cluster": name, "timeout": "10s", "retry_policy": rp}}]}]},
            "http_filters": [{"name": "envoy.filters.http.router", "typed_config": {"@type": "type.googleapis.com/envoy.extensions.filters.http.router.v3.Router"}}]}}]}]}],
       "clusters": [cl]}}
print(yaml.safe_dump(cfg, sort_keys=False))
