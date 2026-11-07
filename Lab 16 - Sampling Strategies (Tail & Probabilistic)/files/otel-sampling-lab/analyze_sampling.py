#!/usr/bin/env python3
"""Lab 16 analysis: reads the collector's JSON trace files and reports sampling effectiveness."""
import argparse, json

def load(path):
    spans = []
    try:
        lines = open(path).read().splitlines()
    except FileNotFoundError:
        return spans
    for line in lines:
        if not line.strip():
            continue
        doc = json.loads(line)
        for rs in doc.get("resourceSpans", []):
            for ss in rs.get("scopeSpans", []):
                for s in ss.get("spans", []):
                    code = s.get("status", {}).get("code", 0)
                    attrs = {a["key"]: next(iter(a["value"].values()), None) for a in s.get("attributes", [])}
                    spans.append({
                        "trace": s["traceId"],
                        "name": s["name"],
                        "error": code in (2, "STATUS_CODE_ERROR"),
                        "ms": (int(s["endTimeUnixNano"]) - int(s["startTimeUnixNano"])) / 1e6,
                        "attrs": attrs,
                    })
    return spans

def traces_where(spans, pred):
    return {s["trace"] for s in spans if pred(s)}

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--sampled", required=True)
    ap.add_argument("--received", required=True)
    ap.add_argument("--sent", type=int, default=200)
    a = ap.parse_args()
    kept, got = load(a.sampled), load(a.received)
    is_err = lambda s: s["error"]
    is_slow = lambda s: s["ms"] > 1500
    is_crit = lambda s: s["attrs"].get("priority") == "high"
    kept_traces, got_traces = {s["trace"] for s in kept}, {s["trace"] for s in got}

    print("=== SAMPLING ANALYSIS (tail-sampled output file) ===")
    print(f"Total span records found:          {len(kept)}")
    print(f"Spans with ERROR status:           {sum(map(is_err, kept))}")
    print(f"Spans with duration > 1500ms:      {sum(map(is_slow, kept))}")
    print(f"Traces retained:                   {len(kept_traces)}")
    print(f"Overall retention vs {a.sent} sent:    {100 * len(kept_traces) / a.sent:.1f}%")
    print()
    print("=== LAYER BREAKDOWN ===")
    print(f"Requests sent:                     {a.sent}")
    print(f"Traces after SDK 20% sampler:      {len(got_traces)}  ({100 * len(got_traces) / a.sent:.1f}%)")
    print(f"Traces after collector tail rules: {len(kept_traces)}  ({100 * len(kept_traces) / a.sent:.1f}%)")
    for label, pred in (("ERROR", is_err), ("SLOW >1500ms", is_slow), ("priority=high", is_crit)):
        r, k = traces_where(got, pred), traces_where(kept, pred)
        cov = 100 * len(r & k) / len(r) if r else 100.0
        print(f"COVERAGE {label:14} traces: received={len(r)} kept={len(r & k)} -> {cov:.0f}%")
    empty = sum(1 for s in kept if s["name"].startswith("GET") and not (s["attrs"].get("outcome") and "sim.duration_ms" in s["attrs"]))
    print(f"Server spans missing custom attributes: {empty}")

if __name__ == "__main__":
    main()
