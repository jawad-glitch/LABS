#!/usr/bin/env python3
"""Decode the endorsement policy from 'peer lifecycle chaincode querycommitted --output json' (validation_parameter is a protobuf)."""
import sys, json, base64
def varint(b, i):
    r = s = 0
    while True:
        c = b[i]; i += 1; r |= (c & 0x7f) << s; s += 7
        if c < 0x80: return r, i
def fields(b):
    i, out = 0, []
    while i < len(b):
        k, i = varint(b, i); f, w = k >> 3, k & 7
        if w == 0: v, i = varint(b, i)
        elif w == 2: l, i = varint(b, i); v = b[i:i + l]; i += l
        elif w == 5: v = b[i:i + 4]; i += 4
        else: v = b[i:i + 8]; i += 8
        out.append((f, v))
    return out
ROLE = {0: "member", 1: "admin", 2: "client", 3: "peer", 4: "orderer"}
def principal(b):
    d = dict(fields(b)); role = dict(fields(d.get(2, b"")))
    return "'%s.%s'" % (role.get(1, b"").decode(), ROLE.get(role.get(2, 0), "?"))
def rule(b, ids):
    for f, v in fields(b):
        if f == 1: return ids[v]
        if f == 2:
            n, rs = 1, []
            for g, x in fields(v):
                if g == 1: n = x
                elif g == 2: rs.append(rule(x, ids))
            return ("AND(%s)" if n == len(rs) else "OR(%s)" if n == 1 else "OutOf(%d,%%s)" % n) % ",".join(rs)
d = json.load(sys.stdin)
for f, v in fields(base64.b64decode(d["validation_parameter"])):
    if f == 1:
        env = fields(v); print("sequence=%s policy=%s" % (d.get("sequence"), rule([x for g, x in env if g == 2][0], [principal(x) for g, x in env if g == 3])))
