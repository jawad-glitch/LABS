from http.server import HTTPServer, BaseHTTPRequestHandler
import random
class S(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/plain")
        self.end_headers()
        self.wfile.write(f'http_requests_total{{method="GET",status="200",cluster="cluster-a"}} {random.randint(2000,8000)}\n'.encode())
    def log_message(self, format, *args): pass
HTTPServer(('0.0.0.0', 8081), S).serve_forever()
