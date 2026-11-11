#!/usr/bin/env python3
"""Completed Task 2.4: relabel rules for the kubernetes-pods job and a pure-Python evaluation of them."""
import json, re, sys

def build_pod_relabel_config() -> list:
    return [
        {"source_labels": ["__meta_kubernetes_pod_annotation_prometheus_io_scrape"], "action": "keep", "regex": "true"},
        {"source_labels": ["__meta_kubernetes_pod_annotation_prometheus_io_path"], "action": "replace", "target_label": "__metrics_path__", "regex": "(.+)"},
        {"source_labels": ["__address__", "__meta_kubernetes_pod_annotation_prometheus_io_port"], "action": "replace",
         "regex": r"([^:]+)(?::\d+)?;(\d+)", "replacement": "$1:$2", "target_label": "__address__"},
        {"action": "labelmap", "regex": "__meta_kubernetes_pod_label_(.+)"},
        {"source_labels": ["__meta_kubernetes_namespace"], "target_label": "kubernetes_namespace"},
        {"source_labels": ["__meta_kubernetes_pod_name"], "target_label": "kubernetes_pod_name"},
    ]

def validate_target_labels(raw_labels: dict) -> dict:
    labels = dict(raw_labels)
    for r in build_pod_relabel_config():
        regex = re.compile("^(?:%s)$" % r.get("regex", "(.*)")); act = r.get("action", "replace")
        if act == "labelmap":
            for k, v in list(labels.items()):
                m = regex.match(k)
                if m: labels[m.expand(r"\1")] = v
            continue
        val = ";".join(labels.get(s, "") for s in r["source_labels"]); m = regex.match(val)
        if act == "keep":
            if not m: return {}
            continue
        if m: labels[r["target_label"]] = m.expand(r.get("replacement", "$1").replace("$", "\\"))
    final = {k: v for k, v in labels.items() if not k.startswith("__")}
    final["instance"] = labels["__address__"]
    return final

if __name__ == "__main__":
    print(json.dumps(validate_target_labels(json.load(sys.stdin)), sort_keys=True))
