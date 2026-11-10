#!/usr/bin/env python3
import json
import sys

import pandas as pd
from sklearn.ensemble import IsolationForest

PRIO = {"EMERGENCY": 7, "ALERT": 6, "CRITICAL": 5, "ERROR": 4, "WARNING": 3, "NOTICE": 2, "INFORMATIONAL": 1, "INFO": 1, "DEBUG": 0}
FEATURES = ["n_events", "n_rules", "n_procs", "max_prio", "n_shell", "n_secret", "night"]


def load_csv(path):
    df = pd.read_csv(path, keep_default_na=False)
    df["time"] = pd.to_datetime(df["time"], utc=True, format="ISO8601")
    return df


def load_falco_jsonl(path):
    recs = []
    with open(path) as fh:
        for line in fh:
            line = line.strip()
            if not line.startswith("{"):
                continue
            e = json.loads(line)
            of = e.get("output_fields", {})
            recs.append(dict(time=e["time"], rule=e["rule"], priority=e["priority"], ns=of.get("k8s.ns.name") or "host",
                             pod=of.get("k8s.pod.name") or "host", proc=of.get("proc.name") or "", file=of.get("fd.name") or "", is_attack=0))
    df = pd.DataFrame(recs)
    if not df.empty:
        df["time"] = pd.to_datetime(df["time"], utc=True, format="ISO8601")
    return df


def build_features(df):
    df = df.copy()
    df["window"] = df["time"].dt.floor("5min")
    df["prio_num"] = df["priority"].astype(str).str.upper().map(PRIO).fillna(2)
    df["is_shell"] = df["rule"].str.contains("shell", case=False).astype(int)
    df["is_secret"] = df["file"].astype(str).str.startswith("/vault/secrets").astype(int)
    feats = (df.groupby(["ns", "pod", "window"])
               .agg(n_events=("rule", "size"), n_rules=("rule", "nunique"), n_procs=("proc", "nunique"), max_prio=("prio_num", "max"),
                    n_shell=("is_shell", "sum"), n_secret=("is_secret", "sum"), is_attack=("is_attack", "max"))
               .reset_index())
    feats["night"] = feats["window"].dt.hour.between(0, 5).astype(int)
    return feats


def explain(row, baseline):
    z = ((row[FEATURES] - baseline[FEATURES].mean()) / (baseline[FEATURES].std() + 1e-9)).astype(float)
    top = z.sort_values(ascending=False).head(3)
    return ", ".join(f"{k}={row[k]} (z={v:.1f})" for k, v in top.items())


def main():
    train = build_features(load_csv("events_week.csv"))
    model = IsolationForest(n_estimators=300, contamination=0.005, random_state=42)
    model.fit(train[FEATURES])
    train["score"] = -model.decision_function(train[FEATURES])
    train["flag"] = model.predict(train[FEATURES]) == -1
    print(f"windows: {len(train)}  attack windows: {int(train.is_attack.sum())}  flagged: {int(train.flag.sum())}")
    print("\nTOP ANOMALIES (training week)")
    for _, r in train.sort_values("score", ascending=False).head(8).iterrows():
        print(f"{r.window:%Y-%m-%d %H:%M} {r.ns}/{r.pod:<30} score={r.score:.3f} attack={r.is_attack} | {explain(r, train)}")
    att = train[train.is_attack == 1]
    recall = att.flag.mean() if len(att) else 0.0
    prec = train[train.flag].is_attack.mean() if train.flag.any() else 0.0
    print(f"\nrecall={recall:.2f} precision={prec:.2f}")
    if len(sys.argv) > 1:
        live = load_falco_jsonl(sys.argv[1])
        if live.empty:
            print("\nno live events")
        else:
            lf = build_features(live)
            lf["score"] = -model.decision_function(lf[FEATURES])
            lf["flag"] = model.predict(lf[FEATURES]) == -1
            print("\nLIVE FALCO WINDOWS")
            for _, r in lf.sort_values("score", ascending=False).head(5).iterrows():
                print(f"{r.window:%H:%M} {r.ns}/{r.pod:<34} score={r.score:.3f} flagged={r.flag} | {explain(r, train)}")
            lf.to_csv("live_scored.csv", index=False)
    train.sort_values("score", ascending=False).head(50).to_csv("triage_report.csv", index=False)


if __name__ == "__main__":
    main()
