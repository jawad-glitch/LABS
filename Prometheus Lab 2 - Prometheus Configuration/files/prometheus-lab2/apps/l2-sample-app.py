import http.server, sys
PATH, NAME = sys.argv[2], sys.argv[3]
class H(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path != PATH: self.send_response(404); self.end_headers(); return
        body = ("# HELP app_info Sample app\n# TYPE app_info gauge\napp_info{app=\"%s\"} 1\n" % NAME).encode()
        self.send_response(200); self.send_header("Content-Type", "text/plain; version=0.0.4"); self.end_headers(); self.wfile.write(body)
    def log_message(self, *a): pass
http.server.HTTPServer(("127.0.0.1", int(sys.argv[1])), H).serve_forever()
