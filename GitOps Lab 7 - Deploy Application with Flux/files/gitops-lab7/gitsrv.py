#!/usr/bin/env python3
# Minimal smart-HTTP Git server (git http-backend over WSGI) so Flux-style http:// URLs work for a local bare repo.
import os, sys, subprocess
from socketserver import ThreadingMixIn
from wsgiref.simple_server import make_server, WSGIServer, WSGIRequestHandler
ROOT, HOST, PORT = sys.argv[1], sys.argv[2], int(sys.argv[3])
class TS(ThreadingMixIn, WSGIServer): daemon_threads = True
class Q(WSGIRequestHandler):
    def log_message(self, *a): pass
def app(e, start):
    body = e["wsgi.input"].read(int(e.get("CONTENT_LENGTH") or 0))
    env = dict(os.environ, GIT_PROJECT_ROOT=ROOT, GIT_HTTP_EXPORT_ALL="1", PATH_INFO=e["PATH_INFO"], REQUEST_METHOD=e["REQUEST_METHOD"],
               QUERY_STRING=e.get("QUERY_STRING", ""), CONTENT_TYPE=e.get("CONTENT_TYPE", ""), CONTENT_LENGTH=str(len(body)), REMOTE_ADDR=e.get("REMOTE_ADDR", ""))
    for k in ("HTTP_GIT_PROTOCOL", "HTTP_CONTENT_ENCODING"):
        if e.get(k): env[k] = e[k]
    if e.get("HTTP_GIT_PROTOCOL"): env["GIT_PROTOCOL"] = e["HTTP_GIT_PROTOCOL"]
    out = subprocess.run(["git", "http-backend"], input=body, env=env, capture_output=True).stdout
    sep = b"\r\n\r\n" if b"\r\n\r\n" in out else b"\n\n"; head, _, rest = out.partition(sep)
    status, hdrs = "200 OK", []
    for line in head.decode(errors="replace").splitlines():
        if ":" not in line: continue
        k, v = line.split(":", 1)
        if k.lower() == "status": status = v.strip()
        else: hdrs.append((k, v.strip()))
    start(status, hdrs); return [rest]
make_server(HOST, PORT, app, server_class=TS, handler_class=Q).serve_forever()
