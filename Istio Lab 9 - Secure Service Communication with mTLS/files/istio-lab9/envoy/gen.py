#!/usr/bin/env python3
# inbound <mode STRICT|PERMISSIVE> [authz.yaml] : sidecar for backend, virtualInbound :15006 -> app :80
# outbound <sa> <backend_ip>                    : client sidecar :8080 -> backend :15006 with Istio-style mTLS (SPIFFE SAN check)
import sys, yaml
TLS = "envoy.transport_sockets.tls"; P = "type.googleapis.com/envoy.extensions."
def certs(sa): return {"tls_certificates": [{"certificate_chain": {"filename": "/pki/%s.crt" % sa}, "private_key": {"filename": "/pki/%s.key" % sa}}]}
def hcm(prefix, cluster, rbac=None):
    filters = ([rbac] if rbac else []) + [{"name": "envoy.filters.http.router", "typed_config": {"@type": P + "filters.http.router.v3.Router"}}]
    return {"name": "envoy.filters.network.http_connection_manager", "typed_config": {"@type": P + "filters.network.http_connection_manager.v3.HttpConnectionManager", "stat_prefix": prefix,
            "forward_client_cert_details": "SANITIZE_SET", "set_current_client_cert_details": {"uri": True},
            "route_config": {"name": prefix, "virtual_hosts": [{"name": "all", "domains": ["*"], "routes": [{"match": {"prefix": "/"}, "route": {"cluster": cluster}}]}]}, "http_filters": filters}}
def rbac_from(ap):
    pol = {}
    for i, r in enumerate(ap["spec"]["rules"]):
        perms = [{"or_rules": {"rules": [{"header": {"name": ":method", "string_match": {"exact": m}}} for t in r["to"] for m in t["operation"]["methods"]]}}] if r.get("to") else [{"any": True}]
        prins = [{"or_ids": {"ids": [{"authenticated": {"principal_name": {"exact": "spiffe://" + p}}} for f in r["from"] for p in f["source"]["principals"]]}}] if r.get("from") else [{"any": True}]
        pol["ns[default]-policy[backend-policy]-rule[%d]" % i] = {"permissions": perms, "principals": prins}
    return {"name": "envoy.filters.http.rbac", "typed_config": {"@type": P + "filters.http.rbac.v3.RBAC", "rules": {"action": ap["spec"].get("action", "ALLOW"), "policies": pol}}}
def static(name, addr, port, tls=None):
    c = {"name": name, "type": "STATIC", "connect_timeout": "2s", "load_assignment": {"cluster_name": name, "endpoints": [{"lb_endpoints": [{"endpoint": {"address": {"socket_address": {"address": addr, "port_value": port}}}}]}]}}
    if tls: c["transport_socket"] = tls
    return c
admin = {"address": {"socket_address": {"address": "0.0.0.0", "port_value": 15000}}}
if sys.argv[1] == "inbound":
    mode = sys.argv[2]; rbac = rbac_from(yaml.safe_load(open(sys.argv[3]))) if len(sys.argv) > 3 else None
    dtls = {"name": TLS, "typed_config": {"@type": P + "transport_sockets.tls.v3.DownstreamTlsContext", "require_client_certificate": True,
            "common_tls_context": dict(certs("backend"), validation_context={"trusted_ca": {"filename": "/pki/ca.crt"}}, alpn_protocols=["h2", "http/1.1"])}}
    mtls_chain = {"filter_chain_match": {"transport_protocol": "tls"}, "transport_socket": dtls, "filters": [hcm("inbound_0.0.0.0_80_mtls", "inbound|80||", rbac)]}
    lst = {"name": "virtualInbound", "address": {"socket_address": {"address": "0.0.0.0", "port_value": 15006}},
           "listener_filters": [{"name": "envoy.filters.listener.tls_inspector", "typed_config": {"@type": P + "filters.listener.tls_inspector.v3.TlsInspector"}}], "filter_chains": [mtls_chain]}
    if mode == "PERMISSIVE": lst["default_filter_chain"] = {"filters": [hcm("inbound_0.0.0.0_80_plaintext", "inbound|80||", rbac)]}
    cfg = {"admin": admin, "static_resources": {"listeners": [lst], "clusters": [static("inbound|80||", "127.0.0.1", 80)]}}
else:
    sa, ip = sys.argv[2], sys.argv[3]
    utls = {"name": TLS, "typed_config": {"@type": P + "transport_sockets.tls.v3.UpstreamTlsContext", "sni": "outbound_.80_._.backend-service.default.svc.cluster.local",
            "common_tls_context": dict(certs(sa), validation_context={"trusted_ca": {"filename": "/pki/ca.crt"},
                "match_typed_subject_alt_names": [{"san_type": "URI", "matcher": {"exact": "spiffe://cluster.local/ns/default/sa/backend"}}]})}}
    lst = {"name": "outbound_0.0.0.0_80", "address": {"socket_address": {"address": "0.0.0.0", "port_value": 8080}}, "filter_chains": [{"filters": [hcm("outbound_80", "outbound|80||backend-service.default.svc.cluster.local")]}]}
    cfg = {"admin": admin, "static_resources": {"listeners": [lst], "clusters": [static("outbound|80||backend-service.default.svc.cluster.local", ip, 15006, utls)]}}
print(yaml.safe_dump(cfg, sort_keys=False))
