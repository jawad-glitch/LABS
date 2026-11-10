import http.server, json, os, ssl

SECRET_FILE = os.environ.get("DB_SECRET_FILE", "/vault/secrets/db.env")
CERT = os.environ.get("TLS_CERT", "/tls/tls.crt")
KEY = os.environ.get("TLS_KEY", "/tls/tls.key")


def read_secret():
    data = {}
    try:
        with open(SECRET_FILE) as f:
            for line in f:
                if "=" in line:
                    k, v = line.strip().split("=", 1)
                    data[k] = v
    except FileNotFoundError:
        pass
    return data


class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/healthz":
            body = b"ok"
        else:
            s = read_secret()
            body = json.dumps({"service": "shop-api", "db_secret_loaded": bool(s), "db_user": s.get("DB_USER", None)}).encode()
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        pass


if __name__ == "__main__":
    ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    ctx.minimum_version = ssl.TLSVersion.TLSv1_2
    ctx.load_cert_chain(CERT, KEY)
    srv = http.server.ThreadingHTTPServer(("0.0.0.0", 8443), Handler)
    srv.socket = ctx.wrap_socket(srv.socket, server_side=True)
    print("shop-api listening on 8443 (TLS)", flush=True)
    srv.serve_forever()
