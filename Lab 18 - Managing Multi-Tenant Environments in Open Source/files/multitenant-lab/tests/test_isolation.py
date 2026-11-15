import json
import urllib.request
import urllib.error
import uuid

BASE = "http://127.0.0.1:8000"

def request(method, path, tenant, token=None, payload=None):
    headers = {"X-Tenant-Name": tenant}
    data = None
    if payload is not None:
        data = json.dumps(payload).encode()
        headers["Content-Type"] = "application/json"
    if token:
        headers["Authorization"] = "Bearer " + token
    req = urllib.request.Request(BASE + path, data=data, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req, timeout=15) as response:
            body = response.read()
            return response.status, json.loads(body) if body else {}
    except urllib.error.HTTPError as exc:
        body = exc.read()
        try:
            parsed = json.loads(body) if body else {}
        except Exception:
            parsed = {}
        return exc.code, parsed

def login(tenant, username="admin", password="AdminPass123!"):
    status, body = request("POST", "/login", tenant, payload={
        "username": username, "password": password
    })
    assert status == 200, f"Login failed for {tenant}: {status} {body}"
    assert body.get("access_token"), f"No JWT returned for {tenant}"
    return body["access_token"]

def test_tenant_a_record_is_not_visible_to_tenant_b():
    marker = "alpha-private-" + uuid.uuid4().hex
    token_a = login("alpha")
    status, created = request("POST", "/items", "alpha", token_a, {"name": marker})
    assert status == 201, f"Tenant A create failed: {status} {created}"

    token_b = login("beta")
    status, listing = request("GET", "/items", "beta", token_b)
    assert status == 200, f"Tenant B list failed: {status} {listing}"
    assert marker not in json.dumps(listing), "TENANT ISOLATION FAILURE: Tenant B saw Tenant A's record"

def test_tenant_context_mismatch_is_forbidden():
    token_a = login("alpha")
    status, _ = request("GET", "/items", "beta", token_a)
    assert status in (403, 404), f"Cross-tenant request was not rejected: HTTP {status}"

def test_read_only_user_cannot_write():
    token = login("gamma", "user", "UserPass123!")
    status, _ = request("POST", "/items", "gamma", token, {"name": "unauthorized-write"})
    assert status == 403, f"Read-only user write should return 403, got {status}"

def test_three_tenants_receive_distinct_tokens():
    tokens = [login(t) for t in ("alpha", "beta", "gamma")]
    assert len(set(tokens)) == 3, "Each tenant login should receive a unique JWT"
