#!/usr/bin/env python3
# inbound <app> <sa> <policy.yaml...>  : STRICT mTLS :15006 -> app :80. ALLOW policies whose selector matches app (or have none) are merged
#                                         (rules OR'ed); if any ALLOW policy applies and no rule matches -> 403. DENY policies evaluated first.
# client <sa> <front_ip> <back_ip> <db_ip> : listeners 8081/8082/8083 -> frontend/backend/database with mTLS (server SAN checked)
import sys, yaml
P = "type.googleapis.com/envoy."; TLS = "envoy.transport_sockets.tls"; NS = "zero-trust-demo"
spiffe = lambda sa: "spiffe://cluster.local/ns/%s/sa/%s" % (NS, sa)
def ctx(sa): return {"tls_certificates": [{"certificate_chain": {"filename": "/pki/%s.crt" % sa}, "private_key": {"filename": "/pki/%s.key" % sa}}]}
def rule(r):
    perms = []
    for t in r.get("to") or []:
        op = t["operation"]; ands = []
        if op.get("methods"): ands.append({"or_rules": {"rules": [{"header": {"name": ":method", "string_match": {"exact": m}}} for m in op["methods"]]}})
        if op.get("paths"): ands.append({"or_rules": {"rules": [{"url_path": {"path": {"prefix": p[:-1]} if p.endswith("*") else {"exact": p}}} for p in op["paths"]]}})
        perms.append({"and_rules": {"rules": ands}} if ands else {"any": True})
    prins = []
    for f in r.get("from") or []:
        s = f.get("source") or {}
        prins.append({"or_ids": {"ids": [{"authenticated": {"principal_name": {"exact": "spiffe://" + p}}} for p in s["principals"]]}} if s.get("principals") else {"any": True})
    return {"permissions": [{"or_rules": {"rules": perms}}] if perms else [{"any": True}], "principals": [{"or_ids": {"ids": prins}}] if prins else [{"any": True}]}
def rbac(app, files):
    allow, deny, applied = {}, {}, []
    for f in files:
        ap = yaml.safe_load(open(f)); sel = (ap["spec"].get("selector") or {}).get("matchLabels")
        if sel and sel.get("app") != app: continue
        applied.append(ap["metadata"]["name"]); tgt = deny if ap["spec"].get("action") == "DENY" else allow
        if ap["spec"].get("action", "ALLOW") == "ALLOW": tgt.setdefault("__present__", None)
        for i, r in enumerate(ap["spec"].get("rules") or []): tgt["ns[%s]-policy[%s]-rule[%d]" % (NS, ap["metadata"]["name"], i)] = rule(r)
    filters = []
    if deny: filters.append({"name": "envoy.filters.http.rbac", "typed_config": {"@type": P + "extensions.filters.http.rbac.v3.RBAC", "rules": {"action": "DENY", "policies": deny}}})
    if "__present__" in allow:
        allow.pop("__present__")
        filters.append({"name": "envoy.filters.http.rbac", "typed_config": {"@type": P + "extensions.filters.http.rbac.v3.RBAC", "rules": {"action": "ALLOW", "policies": allow}}})
    return filters, applied
def hcm(prefix, cluster, filters=(), log=False):
    c = {"@type": P + "extensions.filters.network.http_connection_manager.v3.HttpConnectionManager", "stat_prefix": prefix,
         "route_config": {"name": prefix, "virtual_hosts": [{"name": "all", "domains": ["*"], "routes": [{"match": {"prefix": "/"}, "route": {"cluster": cluster}}]}]},
         "http_filters": list(filters) + [{"name": "envoy.filters.http.router", "typed_config": {"@type": P + "extensions.filters.http.router.v3.Router"}}]}
    if log: c["access_log"] = [{"name": "envoy.access_loggers.stdout", "typed_config": {"@type": P + "extensions.access_loggers.stream.v3.StdoutAccessLog",
              "log_format": {"text_format_source": {"inline_string": "ACCESS %REQ(:METHOD)% %REQ(:PATH)% %RESPONSE_CODE% %RESPONSE_CODE_DETAILS% peer=%DOWNSTREAM_PEER_URI_SAN%\n"}}}}]
    return {"name": "envoy.filters.network.http_connection_manager", "typed_config": c}
def static(name, ip, port, tls=None):
    c = {"name": name, "type": "STATIC", "connect_timeout": "2s", "load_assignment": {"cluster_name": name, "endpoints": [{"lb_endpoints": [{"endpoint": {"address": {"socket_address": {"address": ip, "port_value": port}}}}]}]}}
    if tls: c["transport_socket"] = tls
    return c
admin = {"address": {"socket_address": {"address": "0.0.0.0", "port_value": 15000}}}
a = sys.argv
if a[1] == "inbound":
    app, sa, files = a[2], a[3], a[4:]; filters, applied = rbac(app, files)
    dt = {"name": TLS, "typed_config": {"@type": P + "extensions.transport_sockets.tls.v3.DownstreamTlsContext", "require_client_certificate": True,
          "common_tls_context": dict(ctx(sa), validation_context={"trusted_ca": {"filename": "/pki/ca.crt"}})}}
    lst = {"name": "virtualInbound", "address": {"socket_address": {"address": "0.0.0.0", "port_value": 15006}}, "filter_chains": [{"transport_socket": dt, "filters": [hcm("inbound_" + app, "inbound|80||", filters, True)]}]}
    print("# policies applied to app=%s: %s" % (app, applied or "none (allow all)"))
    print(yaml.safe_dump({"admin": admin, "static_resources": {"listeners": [lst], "clusters": [static("inbound|80||", "127.0.0.1", 80)]}}, sort_keys=False))
else:
    sa = a[2]; L, C = [], []
    for port, svc, ip in ((8081, "frontend", a[3]), (8082, "backend", a[4]), (8083, "database", a[5])):
        ut = {"name": TLS, "typed_config": {"@type": P + "extensions.transport_sockets.tls.v3.UpstreamTlsContext", "sni": "outbound_.80_._.%s.%s.svc.cluster.local" % (svc, NS),
              "common_tls_context": dict(ctx(sa), validation_context={"trusted_ca": {"filename": "/pki/ca.crt"}, "match_typed_subject_alt_names": [{"san_type": "URI", "matcher": {"exact": spiffe(svc + "-sa")}}]})}}
        cn = "outbound|80||%s.%s.svc.cluster.local" % (svc, NS)
        L.append({"name": "outbound_" + svc, "address": {"socket_address": {"address": "0.0.0.0", "port_value": port}}, "filter_chains": [{"filters": [hcm("outbound_" + svc, cn)]}]}); C.append(static(cn, ip, 15006, ut))
    print(yaml.safe_dump({"admin": admin, "static_resources": {"listeners": L, "clusters": C}}, sort_keys=False))
