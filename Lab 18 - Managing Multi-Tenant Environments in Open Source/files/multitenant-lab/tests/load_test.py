import json
import time
import statistics
import urllib.request
import urllib.error
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

BASE = "http://127.0.0.1:8000"
TENANTS = ("alpha", "beta", "gamma")
TOTAL = 200
PASSWORD = "AdminPass123!"

def one_request(index):
    tenant = TENANTS[index % len(TENANTS)]
    payload = json.dumps({"username": "admin", "password": PASSWORD}).encode()
    req = urllib.request.Request(
        BASE + "/login",
        data=payload,
        headers={"Content-Type": "application/json", "X-Tenant-Name": tenant},
        method="POST",
    )
    start = time.perf_counter()
    try:
        with urllib.request.urlopen(req, timeout=20) as response:
            body = json.loads(response.read())
            elapsed = (time.perf_counter() - start) * 1000
            return elapsed, response.status == 200 and bool(body.get("access_token")), tenant
    except Exception:
        return (time.perf_counter() - start) * 1000, False, tenant

start = time.perf_counter()
results = []
with ThreadPoolExecutor(max_workers=200) as pool:
    futures = [pool.submit(one_request, i) for i in range(TOTAL)]
    for future in as_completed(futures):
        results.append(future.result())

duration = time.perf_counter() - start
latencies = [r[0] for r in results]
successes = sum(1 for r in results if r[1])
errors = TOTAL - successes
error_rate = errors * 100 / TOTAL
median_ms = statistics.median(latencies) if latencies else 0

lines = [
    "Multi-tenant concurrent login load test",
    f"Total requests: {TOTAL}",
    "Concurrency: 200 workers",
    f"Tenant distribution: alpha={sum(r[2]=='alpha' for r in results)}, beta={sum(r[2]=='beta' for r in results)}, gamma={sum(r[2]=='gamma' for r in results)}",
    f"Successful requests: {successes}",
    f"Failed requests: {errors}",
    f"Error rate: {error_rate:.2f}%",
    f"Median response time: {median_ms:.2f} ms",
    f"Total elapsed time: {duration:.2f} seconds",
    f"Acceptance: {'PASS' if error_rate < 5 and median_ms < 3000 and successes == TOTAL else 'FAIL'}",
]
output = "\n".join(lines) + "\n"
print(output, end="")
Path.home().joinpath("multitenant-lab/logs/load_test_results.txt").write_text(output)

if error_rate >= 5 or median_ms >= 3000 or successes != TOTAL:
    raise SystemExit(1)
