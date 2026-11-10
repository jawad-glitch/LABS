#!/usr/bin/env python3
# SIMULATED Argo CD metrics source: serves Argo CD metric families on :8082 (controller), :8083 (server), :8084 (repo-server)
# from a JSON state file a scenario driver updates. Real Prometheus text exposition format.
import json, sys, threading
from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler
HOST, STATE = sys.argv[1], sys.argv[2]
def body(port):
    s = json.load(open(STATE)); out = []
    if port == 8082:
        out.append("# TYPE argocd_app_info gauge")
        for a in s["apps"]:
            out.append('argocd_app_info{name="%s",namespace="argocd",project="default",dest_namespace="%s",sync_status="%s",health_status="%s"} 1' % (a["name"], a["dest"], a["sync"], a["health"]))
        out.append("# TYPE argocd_app_sync_total counter")
        for a in s["apps"]:
            for ph, n in a["syncs"].items(): out.append('argocd_app_sync_total{name="%s",namespace="argocd",project="default",phase="%s"} %d' % (a["name"], ph, n))
    if port == 8083:
        out.append("# TYPE grpc_server_handled_total counter"); out.append('grpc_server_handled_total{grpc_service="application.ApplicationService",grpc_method="List",grpc_code="OK"} %d' % s["grpc"])
    if port == 8084:
        out.append("# TYPE argocd_git_request_total counter")
        for repo, n in s["git"].items(): out.append('argocd_git_request_total{repo="%s",request_type="ls-remote"} %d' % (repo, n))
    return ("\n".join(out) + "\n").encode()
def mk(port):
    class H(BaseHTTPRequestHandler):
        def do_GET(self):
            b = body(port); self.send_response(200); self.send_header("Content-Type", "text/plain; version=0.0.4"); self.end_headers(); self.wfile.write(b)
        def log_message(self, *a): pass
    return ThreadingHTTPServer((HOST, port), H)
for p in (8082, 8083, 8084): threading.Thread(target=mk(p).serve_forever, daemon=True).start()
threading.Event().wait()
