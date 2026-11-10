#!/usr/bin/env python3
"""Generate one week of synthetic Falco-like events with one hidden intrusion."""
import csv
import datetime as dt
import random

random.seed(7)
START = dt.datetime(2024, 9, 2, 0, 0, 0)
WINDOWS = 7 * 24 * 12
SOURCES = [
    ("kyverno", "kyverno-admission-controller", "Contact K8S API Server From Container", "Notice", ["kyverno"], ""),
    ("gatekeeper-system", "gatekeeper-audit", "Contact K8S API Server From Container", "Notice", ["manager"], ""),
    ("vault", "vault-0", "Contact K8S API Server From Container", "Notice", ["vault"], ""),
    ("cert-manager", "cert-manager-cainjector", "Contact K8S API Server From Container", "Notice", ["cainjector"], ""),
    ("shop", "shop-api", "Shop API Vault Secret Read by Unexpected Process", "Warning", ["sh"], "/vault/secrets/db.env"),
]
ATTACK_CHAIN = [
    ("Terminal shell in container", "Notice", "sh", ""),
    ("Shop API Vault Secret Read by Unexpected Process", "Warning", "cat", "/vault/secrets/db.env"),
    ("Read sensitive file untrusted", "Warning", "cat", "/etc/shadow"),
    ("Launch Suspicious Network Tool in Container", "Notice", "nc", ""),
    ("Drop and execute new binary in container", "Critical", "xmrig", "/tmp/xmrig"),
]
rows = []
for w in range(WINDOWS):
    base = START + dt.timedelta(minutes=5 * w)
    for ns, pod, rule, prio, procs, f in SOURCES:
        p = 0.25
        if ns == "shop":
            p = 0.02 if 8 <= base.hour < 18 else 0.0
        if random.random() < p:
            for _ in range(random.randint(1, 3)):
                ts = base + dt.timedelta(seconds=random.randint(0, 299))
                rows.append(dict(time=ts.isoformat() + "Z", rule=rule, priority=prio, ns=ns, pod=pod, proc=random.choice(procs), file=f, is_attack=0))
attack_start = dt.datetime(2024, 9, 6, 3, 10, 0)
for i in range(4):
    base = attack_start + dt.timedelta(minutes=5 * i)
    for _ in range(random.randint(8, 14)):
        rule, prio, proc, f = random.choice(ATTACK_CHAIN)
        ts = base + dt.timedelta(seconds=random.randint(0, 299))
        rows.append(dict(time=ts.isoformat() + "Z", rule=rule, priority=prio, ns="shop", pod="shop-api", proc=proc, file=f, is_attack=1))
rows.sort(key=lambda r: r["time"])
with open("events_week.csv", "w", newline="") as fh:
    w = csv.DictWriter(fh, fieldnames=list(rows[0].keys()))
    w.writeheader()
    w.writerows(rows)
print(f"events: {len(rows)} (attack events: {sum(r['is_attack'] for r in rows)})")
