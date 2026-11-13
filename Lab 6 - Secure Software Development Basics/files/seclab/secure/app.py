import os
import sqlite3
from pathlib import Path
from html import escape
from flask import Flask, request, Response

app = Flask(__name__)
BASE_DIR = Path(__file__).resolve().parent
DB_PATH = BASE_DIR / "app.db"
DATA_DIR = (BASE_DIR / "data").resolve()

# Secure configuration: credentials must be supplied through environment variables.
ADMIN_USER = os.environ.get("SECLAB_ADMIN_USER")
ADMIN_PASSWORD = os.environ.get("SECLAB_ADMIN_PASSWORD")

def get_db():
    connection = sqlite3.connect(DB_PATH)
    connection.execute("CREATE TABLE IF NOT EXISTS users (username TEXT, role TEXT)")
    connection.execute("INSERT OR IGNORE INTO users VALUES ('alice', 'analyst')")
    connection.commit()
    return connection

@app.route("/")
def index():
    return "Local hardened security lab application"

@app.route("/login")
def login():
    username = request.args.get("username", "")
    password = request.args.get("password", "")
    if not ADMIN_USER or not ADMIN_PASSWORD:
        return "Authentication is not configured", 503
    if username == ADMIN_USER and password == ADMIN_PASSWORD:
        return "Login successful"
    return "Login failed", 401

@app.route("/search")
def search():
    username = request.args.get("username", "")
    connection = get_db()
    # Secure: parameterized query keeps data separate from SQL syntax.
    rows = connection.execute(
        "SELECT username, role FROM users WHERE username = ?",
        (username,)
    ).fetchall()
    connection.close()
    return Response(str(rows), mimetype="text/plain")

@app.route("/hello")
def hello():
    name = request.args.get("name", "visitor")
    # Secure: escape untrusted text before placing it in HTML.
    return Response("<h1>Hello " + escape(name) + "</h1>", mimetype="text/html")

@app.route("/download")
def download():
    filename = request.args.get("filename", "sample.txt")
    # Secure: canonicalize the path and require it to remain inside DATA_DIR.
    try:
        target = (DATA_DIR / filename).resolve(strict=True)
        target.relative_to(DATA_DIR)
        if not target.is_file():
            return "Not a regular file", 400
        with target.open("r", encoding="utf-8") as handle:
            return Response(handle.read(), mimetype="text/plain")
    except (ValueError, OSError):
        return "Invalid or unavailable file", 400

if __name__ == "__main__":
    get_db().close()
    app.run(host="127.0.0.1", port=5002, debug=False)
