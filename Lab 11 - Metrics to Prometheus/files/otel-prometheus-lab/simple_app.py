#!/usr/bin/env python3
import http.server
import socketserver
import json
import random
import time
from urllib.parse import urlparse

class HealthHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        parsed_path = urlparse(self.path)

        if parsed_path.path == '/health':
            # Simulate some processing time
            time.sleep(random.uniform(0.1, 0.5))

            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()

            response = {
                'status': 'healthy',
                'timestamp': time.time(),
                'random_value': random.randint(1, 100)
            }

            self.wfile.write(json.dumps(response).encode())

        elif parsed_path.path == '/metrics':
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()

            # Simple custom metrics
            metrics = f"""
# HELP app_requests_total Total number of requests
# TYPE app_requests_total counter
app_requests_total {random.randint(100, 1000)}

# HELP app_response_time_seconds Response time in seconds
# TYPE app_response_time_seconds histogram
app_response_time_seconds_sum {random.uniform(10, 50)}
app_response_time_seconds_count {random.randint(50, 200)}
"""
            self.wfile.write(metrics.encode())

        else:
            self.send_response(404)
            self.end_headers()
            self.wfile.write(b'Not Found')

if __name__ == "__main__":
    PORT = 8080
    socketserver.TCPServer.allow_reuse_address = True
    with socketserver.TCPServer(("", PORT), HealthHandler) as httpd:
        print(f"Server running at http://localhost:{PORT}")
        print("Endpoints:")
        print("  /health - Health check endpoint")
        print("  /metrics - Custom metrics endpoint")
        httpd.serve_forever()
