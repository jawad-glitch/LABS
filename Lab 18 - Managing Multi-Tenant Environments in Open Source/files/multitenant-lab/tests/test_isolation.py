import os
import uuid
import httpx

BASE = os.getenv("API_URL", "http://127.0.0.1:8000")
TIMEOUT = 10

def login(tenant, username="admin", password="AdminPass123!"):
    response = httpx.post(
        f"{BASE}/login",
        headers={"X-Tenant-Name": tenant},
        json={"username": username, "password": password},
        timeout=TIMEOUT,
    )
    assert response.status_code == 200, response.text
    return response.json()["access_token"]

def headers(tenant, token):
    return {"X-Tenant-Name": tenant, "Authorization": f"Bearer {token}"}

def test_health():
    response = httpx.get(f"{BASE}/health", timeout=TIMEOUT)
    assert response.status_code == 200
    assert response.json()["status"] == "ok"

def test_tenant_a_record_is_not_visible_to_tenant_b():
    marker = "isolation-" + uuid.uuid4().hex
    token_a = login("alpha")
    create = httpx.post(
        f"{BASE}/items",
        headers=headers("alpha", token_a),
        json={"name": marker},
        timeout=TIMEOUT,
    )
    assert create.status_code == 200, create.text

    token_b = login("beta")
    listing = httpx.get(
        f"{BASE}/items", headers=headers("beta", token_b), timeout=TIMEOUT
    )
    assert listing.status_code == 200, listing.text
    assert marker not in [item["name"] for item in listing.json()["items"]]

    own_listing = httpx.get(
        f"{BASE}/items", headers=headers("alpha", token_a), timeout=TIMEOUT
    )
    assert marker in [item["name"] for item in own_listing.json()["items"]]

def test_read_only_user_cannot_write():
    token = login("alpha", "user", "UserPass123!")
    response = httpx.post(
        f"{BASE}/items",
        headers=headers("alpha", token),
        json={"name": "should-be-forbidden"},
        timeout=TIMEOUT,
    )
    assert response.status_code == 403

def test_tenant_header_cannot_override_jwt_tenant():
    token_a = login("alpha")
    response = httpx.get(
        f"{BASE}/items", headers=headers("beta", token_a), timeout=TIMEOUT
    )
    assert response.status_code == 403

def test_all_three_tenants_have_separate_admin_tokens():
    tokens = {tenant: login(tenant) for tenant in ("alpha", "beta", "gamma")}
    assert len(set(tokens.values())) == 3
