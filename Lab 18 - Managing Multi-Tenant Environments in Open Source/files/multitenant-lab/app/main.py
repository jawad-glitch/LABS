import os
import re
import time
import hashlib
import secrets
from datetime import datetime, timedelta, timezone

import jwt
import psycopg2
from psycopg2 import sql
import redis
from fastapi import FastAPI, Header, HTTPException, Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from pydantic import BaseModel

DATABASE_URL = os.environ["DATABASE_URL"]
REDIS_URL = os.environ["REDIS_URL"]
JWT_SECRET = os.environ["JWT_SECRET"]
JWT_EXPIRE_MINUTES = int(os.getenv("JWT_EXPIRE_MINUTES", "60"))

app = FastAPI(title="Schema-Isolated Multi-Tenant API", version="1.0")
bearer = HTTPBearer(auto_error=False)
cache = redis.Redis.from_url(REDIS_URL, decode_responses=True)

TENANTS = {
    "alpha": "tenant_alpha",
    "beta": "tenant_beta",
    "gamma": "tenant_gamma",
}

def password_hash(password, salt=None):
    salt = salt or secrets.token_hex(16)
    digest = hashlib.pbkdf2_hmac(
        "sha256", password.encode(), salt.encode(), 200000
    ).hex()
    return f"{salt}${digest}"

def password_matches(password, stored):
    try:
        salt, expected = stored.split("$", 1)
        return secrets.compare_digest(password_hash(password, salt), stored)
    except (ValueError, AttributeError):
        return False

def db_connect():
    return psycopg2.connect(DATABASE_URL, connect_timeout=5)

def initialize_database():
    for attempt in range(60):
        try:
            conn = db_connect()
            conn.autocommit = True
            cur = conn.cursor()
            cur.execute("""
                CREATE TABLE IF NOT EXISTS tenants (
                    tenant_id TEXT PRIMARY KEY,
                    schema_name TEXT UNIQUE NOT NULL
                )
            """)
            cur.execute("""
                CREATE TABLE IF NOT EXISTS tenant_users (
                    tenant_id TEXT NOT NULL REFERENCES tenants(tenant_id),
                    username TEXT NOT NULL,
                    password_hash TEXT NOT NULL,
                    role TEXT NOT NULL CHECK (role IN ('admin', 'user')),
                    PRIMARY KEY (tenant_id, username)
                )
            """)
            for tenant_id, schema_name in TENANTS.items():
                cur.execute(
                    "INSERT INTO tenants (tenant_id, schema_name) VALUES (%s, %s) "
                    "ON CONFLICT (tenant_id) DO NOTHING",
                    (tenant_id, schema_name),
                )
                cur.execute(
                    sql.SQL("CREATE SCHEMA IF NOT EXISTS {}").format(
                        sql.Identifier(schema_name)
                    )
                )
                cur.execute(
                    sql.SQL("""
                        CREATE TABLE IF NOT EXISTS {}.items (
                            id SERIAL PRIMARY KEY,
                            name TEXT NOT NULL,
                            created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
                        )
                    """).format(sql.Identifier(schema_name))
                )
                for username, password, role in (
                    ("admin", "AdminPass123!", "admin"),
                    ("user", "UserPass123!", "user"),
                ):
                    cur.execute(
                        """
                        INSERT INTO tenant_users
                            (tenant_id, username, password_hash, role)
                        VALUES (%s, %s, %s, %s)
                        ON CONFLICT (tenant_id, username) DO NOTHING
                        """,
                        (tenant_id, username, password_hash(password), role),
                    )
            cur.close()
            conn.close()
            return
        except psycopg2.OperationalError:
            if attempt == 59:
                raise
            time.sleep(2)

@app.on_event("startup")
def startup():
    initialize_database()
    cache.ping()

@app.get("/health")
def health():
    return {"status": "ok", "database": "initialized", "redis": "connected"}

class LoginInput(BaseModel):
    username: str
    password: str

class ItemInput(BaseModel):
    name: str

def resolve_request(
    x_tenant_name: str = Header(..., alias="X-Tenant-Name"),
    credentials: HTTPAuthorizationCredentials = Depends(bearer),
):
    if x_tenant_name not in TENANTS:
        raise HTTPException(status_code=404, detail="Unknown tenant")
    if credentials is None or credentials.scheme.lower() != "bearer":
        raise HTTPException(status_code=401, detail="Bearer token required")
    try:
        claims = jwt.decode(credentials.credentials, JWT_SECRET, algorithms=["HS256"])
    except jwt.PyJWTError:
        raise HTTPException(status_code=401, detail="Invalid or expired token")
    if claims.get("tenant") != x_tenant_name:
        raise HTTPException(status_code=403, detail="Tenant context mismatch")
    if cache.exists("revoked:" + claims.get("jti", "")):
        raise HTTPException(status_code=401, detail="Token has been revoked")
    return claims

def tenant_connection(tenant_id):
    schema_name = TENANTS.get(tenant_id)
    if not schema_name:
        raise HTTPException(status_code=404, detail="Unknown tenant")
    conn = db_connect()
    cur = conn.cursor()
    cur.execute(
        sql.SQL("SET search_path TO {}, public").format(
            sql.Identifier(schema_name)
        )
    )
    cur.close()
    return conn

@app.post("/login")
def login(payload: LoginInput, x_tenant_name: str = Header(..., alias="X-Tenant-Name")):
    if x_tenant_name not in TENANTS:
        raise HTTPException(status_code=404, detail="Unknown tenant")
    conn = db_connect()
    cur = conn.cursor()
    cur.execute(
        "SELECT password_hash, role FROM tenant_users "
        "WHERE tenant_id = %s AND username = %s",
        (x_tenant_name, payload.username),
    )
    row = cur.fetchone()
    cur.close()
    conn.close()
    if not row or not password_matches(payload.password, row[0]):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    now = datetime.now(timezone.utc)
    token_id = secrets.token_urlsafe(18)
    token = jwt.encode(
        {
            "sub": payload.username,
            "tenant": x_tenant_name,
            "role": row[1],
            "jti": token_id,
            "iat": now,
            "exp": now + timedelta(minutes=JWT_EXPIRE_MINUTES),
        },
        JWT_SECRET,
        algorithm="HS256",
    )
    return {"access_token": token, "token_type": "bearer",
            "tenant": x_tenant_name, "role": row[1]}

@app.get("/items")
def list_items(claims=Depends(resolve_request)):
    conn = tenant_connection(claims["tenant"])
    try:
        cur = conn.cursor()
        cur.execute("SELECT id, name, created_at FROM items ORDER BY id")
        rows = cur.fetchall()
        cur.close()
        return {"tenant": claims["tenant"], "items": [
            {"id": r[0], "name": r[1], "created_at": r[2].isoformat()}
            for r in rows
        ]}
    finally:
        conn.close()

@app.post("/items")
def create_item(payload: ItemInput, claims=Depends(resolve_request)):
    if claims.get("role") != "admin":
        raise HTTPException(status_code=403, detail="Admin role required")
    if not payload.name.strip():
        raise HTTPException(status_code=422, detail="Item name cannot be empty")
    conn = tenant_connection(claims["tenant"])
    try:
        cur = conn.cursor()
        cur.execute("INSERT INTO items (name) VALUES (%s) RETURNING id", (payload.name,))
        item_id = cur.fetchone()[0]
        conn.commit()
        cur.close()
        return {"id": item_id, "name": payload.name, "tenant": claims["tenant"]}
    finally:
        conn.close()

@app.post("/logout")
def logout(claims=Depends(resolve_request)):
    remaining = max(1, int(claims["exp"] - time.time()))
    cache.setex("revoked:" + claims["jti"], remaining, "1")
    return {"message": "Token invalidated"}
