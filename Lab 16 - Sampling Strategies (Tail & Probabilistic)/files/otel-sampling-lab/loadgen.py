#!/usr/bin/env python3
"""Lab 16 load generator: N requests across 4 routes, running status-code counts."""
import argparse, collections, random, threading
from concurrent.futures import ThreadPoolExecutor
import requests

ROUTES = ["/work"] * 25 + ["/fast"] * 35 + ["/flaky"] * 25 + ["/checkout"] * 15

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--requests", type=int, default=200)
    ap.add_argument("--workers", type=int, default=8)
    ap.add_argument("--base", default="http://localhost:5000")
    a = ap.parse_args()
    counts, routes, done, lock = collections.Counter(), collections.Counter(), [0], threading.Lock()

    def hit(_):
        route = random.choice(ROUTES)
        try:
            code = requests.get(a.base + route, timeout=10).status_code
        except requests.RequestException:
            code = "conn_error"
        with lock:
            counts[code] += 1; routes[route] += 1; done[0] += 1
            if done[0] % 25 == 0 or done[0] == a.requests:
                print(f"[{done[0]:>3}/{a.requests}] by status: " + ", ".join(f"{k}={v}" for k, v in sorted(counts.items(), key=str)), flush=True)

    with ThreadPoolExecutor(a.workers) as ex:
        list(ex.map(hit, range(a.requests)))
    print("routes hit:", dict(routes))
    s = requests.get(a.base + "/stats", timeout=5).json()
    print(f"SDK STATS: requests={s['requests']} sampled_traces={s['sampled_traces']} ratio={s['sample_ratio']} "
          f"-> reduction {100 - 100 * s['sampled_traces'] / max(s['requests'], 1):.1f}%")

if __name__ == "__main__":
    main()
