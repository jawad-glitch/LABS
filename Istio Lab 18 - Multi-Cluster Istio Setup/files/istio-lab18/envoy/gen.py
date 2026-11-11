#!/usr/bin/env python3
# inbound <cert> <trust>                    : workload sidecar :15006 mTLS -> app :8080, access log with peer SPIFFE id
# ewgw <mode> <target_ip> [cert] [trust]     : east-west gateway :15443; AUTO_PASSTHROUGH = SNI routing, TLS untouched; ISTIO_MUTUAL = terminate with gateway identity
# client <cert> <trust> <local_ip> <ew_ip>   : sleep sidecar; :8000 -> all httpbin endpoints (local direct + remote via gateway), :8001 -> remote only
import sys, yaml
P = "type.googleapis.com/envoy."; SNI = "outbound_.8000_._.httpbin.default.svc.cluster.local"; TLS = "envoy.transport_sockets.tls"
def ctx(cert, trust): return {"tls_certificates": [{"certificate_chain": {"filename": "/pki/%s.crt" % cert}, "private_key": {"filename": "/pki/%s.key" % cert}}], "validation_context": {"trusted_ca": {"filename": "/pki/%s.crt" % trust}}}
def router(): return [{"name": "envoy.filters.http.router", "typed_config": {"@type": P + "extensions.filters.http.router.v3.Router"}}]
def hcm(prefix, routes, log=False):
    c = {"@type": P + "extensions.filters.network.http_connection_manager.v3.HttpConnectionManager", "stat_prefix": prefix, "http_filters": router(),
         "route_config": {"name": prefix, "virtual_hosts": [{"name": "all", "domains": ["*"], "routes": routes}]}}
    if log: c["access_log"] = [{"name": "envoy.access_loggers.stdout", "typed_config": {"@type": P + "extensions.access_loggers.stream.v3.StdoutAccessLog",
              "log_format": {"text_format_source": {"inline_string": "ACCESS %REQ(:PATH)% %RESPONSE_CODE% peer=%DOWNSTREAM_PEER_URI_SAN%\n"}}}}]
    return {"name": "envoy.filters.network.http_connection_manager", "typed_config": c}
def static(name, eps, tls=None):
    c = {"name": name, "type": "STATIC", "connect_timeout": "2s", "lb_policy": "ROUND_ROBIN",
         "load_assignment": {"cluster_name": name, "endpoints": [{"lb_endpoints": [{"endpoint": {"address": {"socket_address": {"address": h, "port_value": p}}}} for h, p in eps]}]}}
    if tls: c["transport_socket"] = tls
    return c
def lst(name, port, chains, inspector=False):
    l = {"name": name, "address": {"socket_address": {"address": "0.0.0.0", "port_value": port}}, "filter_chains": chains}
    if inspector: l["listener_filters"] = [{"name": "envoy.filters.listener.tls_inspector", "typed_config": {"@type": P + "extensions.filters.listener.tls_inspector.v3.TlsInspector"}}]
    return l
a = sys.argv; kind = a[1]; admin = {"address": {"socket_address": {"address": "0.0.0.0", "port_value": 15000}}}
if kind == "inbound":
    dt = {"name": TLS, "typed_config": {"@type": P + "extensions.transport_sockets.tls.v3.DownstreamTlsContext", "require_client_certificate": True, "common_tls_context": ctx(a[2], a[3])}}
    cfg = {"listeners": [lst("virtualInbound", 15006, [{"transport_socket": dt, "filters": [hcm("inbound", [{"match": {"prefix": "/"}, "route": {"cluster": "app"}}], True)]}])], "clusters": [static("app", [("127.0.0.1", 8080)])]}
elif kind == "ewgw":
    mode, target = a[2], a[3]
    if mode == "AUTO_PASSTHROUGH":
        chain = {"filter_chain_match": {"server_names": [SNI]}, "filters": [{"name": "envoy.filters.network.tcp_proxy", "typed_config": {"@type": P + "extensions.filters.network.tcp_proxy.v3.TcpProxy", "stat_prefix": "sni_passthrough", "cluster": "httpbin-local-endpoints"}}]}
        cfg = {"listeners": [lst("0.0.0.0_15443", 15443, [chain], inspector=True)], "clusters": [static("httpbin-local-endpoints", [(target, 15006)])]}
    else:
        dt = {"name": TLS, "typed_config": {"@type": P + "extensions.transport_sockets.tls.v3.DownstreamTlsContext", "require_client_certificate": True, "common_tls_context": ctx(a[4], a[5])}}
        cfg = {"listeners": [lst("0.0.0.0_15443", 15443, [{"transport_socket": dt, "filters": [hcm("ew_terminate", [])]}])], "clusters": []}
else:
    cert, trust, local, ew = a[2], a[3], a[4], a[5]
    ut = {"name": TLS, "typed_config": {"@type": P + "extensions.transport_sockets.tls.v3.UpstreamTlsContext", "sni": SNI, "common_tls_context": dict(ctx(cert, trust),
          validation_context={"trusted_ca": {"filename": "/pki/%s.crt" % trust}, "match_typed_subject_alt_names": [{"san_type": "URI", "matcher": {"exact": "spiffe://cluster.local/ns/default/sa/httpbin"}}]})}}
    route = lambda c: [{"match": {"prefix": "/"}, "route": {"cluster": c, "timeout": "5s"}}]
    cfg = {"listeners": [lst("outbound_8000", 8000, [{"filters": [hcm("outbound_mixed", route("httpbin-all"))]}]), lst("outbound_remote", 8001, [{"filters": [hcm("outbound_remote", route("httpbin-cluster1"))]}])],
           "clusters": [static("httpbin-all", [(local, 15006), (ew, 15443)], ut), static("httpbin-cluster1", [(ew, 15443)], ut)]}
print(yaml.safe_dump({"admin": admin, "static_resources": cfg}, sort_keys=False))
