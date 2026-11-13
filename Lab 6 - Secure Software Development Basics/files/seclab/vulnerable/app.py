import os
import sqlite3
from flask import Flask, request, Response

app = Flask(__name__)
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(BASE_DIR, "app.db")
DATA_DIR = os.path.join(BASE_DIR, "data")

# INTENTIONALLY VULNERABLE: hardcoded credentials.
ADMIN_USER = "admin"
ADMIN_PASSWORD = "LabPassword123!"

def get_db():
    connection = sqlite3.connect(DB_PATH)
    connection.execute("CREATE TABLE IF NOT EXISTS users (username TEXT, role TEXT)")
    connection.execute("INSERT OR IGNORE INTO users VALUES ('alice', 'analyst')")
    connection.commit()
    return connection

@app.route("/")
def index():
    return "Local vulnerable security lab application"

@app.route("/login")
def login():
    username = request.args.get("username", "")
    password = request.args.get("password", "")
    if username == ADMIN_USER and password == ADMIN_PASSWORD:
        return "Login successful"
    return "Login failed", 401

@app.route("/search")
def search():
    username = request.args.get("username", "")
    connection = get_db()
    # INTENTIONALLY VULNERABLE: SQL is assembled using user input.
    query = "SELECT username, role FROM users WHERE username = '%s'" % username
    rows = connection.execute(query).fetchall()
    connection.close()
    return Response(str(rows), mimetype="text/plain")

@app.route("/hello")
def hello():
    name = request.args.get("name", "visitor")
    # INTENTIONALLY VULNERABLE: reflected input is inserted into HTML.
    return Response("<h1>Hello " + name + "</h1>", mimetype="text/html")

@app.route("/download")
def download():
    filename = request.args.get("filename", "sample.txt")
    # INTENTIONALLY VULNERABLE: user-controlled path is opened directly.
    target = os.path.join(DATA_DIR, filename)
    with open(target, "r", encoding="utf-8") as handle:
        return Response(handle.read(), mimetype="text/plain")

if __name__ == "__main__":
    get_db().close()
    app.run(host="127.0.0.1", port=5001, debug=False)
