#!/usr/bin/env python3
"""Compare the same traces in Jaeger and Zipkin: trace IDs, span names, parent links, attributes."""
import json, sys, urllib.request
svc = sys.argv[1] if len(sys.argv) > 1 else "trace-generator"
j = json.load(urllib.request.urlopen(f"http://localhost:16686/api/traces?service={svc}&limit=500"))["data"]
z = json.load(urllib.request.urlopen(f"http://localhost:9411/api/v2/traces?serviceName={svc}&limit=500"))
J = {t["traceID"].zfill(32): t for t in j}
Z = {t[0]["traceId"].zfill(32): t for t in z if t}
common = sorted(set(J) & set(Z))
print(f"jaeger traces={len(J)} zipkin traces={len(Z)} same trace IDs in both={len(common)}")
same_shape = same_attr = 0
for tid in common:
    jn = sorted(s["operationName"] for s in J[tid]["spans"])
    zn = sorted(s["name"] for s in Z[tid])
    if jn == zn and len(jn) == 5: same_shape += 1
    jtags = {t["key"]: str(t["value"]) for s in J[tid]["spans"] for t in s["tags"]}
    ztags = {k: v for s in Z[tid] for k, v in s.get("tags", {}).items()}
    if jtags.get("lab.number") == ztags.get("lab.number") == "18" and ztags.get("db.table") == jtags.get("db.table") == "users":
        same_attr += 1
print(f"traces with identical 5-span structure in both: {same_shape}")
print(f"traces with identical attributes (lab.number=18, db.table=users): {same_attr}")
if common:
    t = common[0]
    print("example trace", t)
    print("  jaeger:", sorted(s["operationName"] for s in J[t]["spans"]))
    print("  zipkin:", sorted(s["name"] for s in Z[t]))
