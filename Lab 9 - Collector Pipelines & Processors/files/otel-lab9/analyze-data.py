#!/usr/bin/env python3
"""
Data analyzer for OpenTelemetry Collector Lab 9
Analyzes the processed telemetry data (file exporter output, one JSON document per line)
"""

import json
import os

FILE_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "data", "otel-data.json")
WANT = {"service.environment", "lab.name", "lab.number"}

def attrs_in(obj, found):
    if isinstance(obj, dict):
        if "key" in obj and "value" in obj:
            found.add(obj["key"])
        for v in obj.values():
            attrs_in(v, found)
    elif isinstance(obj, list):
        for v in obj:
            attrs_in(v, found)

def analyze_file_export():
    """Analyze the file export data"""
    if not os.path.exists(FILE_PATH):
        print("No export file found. Make sure you've sent test data.")
        return

    print("File Export Analysis")
    print("=" * 30)
    with open(FILE_PATH) as f:
        lines = [l for l in f if l.strip()]
    print(f"Total lines in export file: {len(lines)}")
    kinds = {"resourceSpans": 0, "resourceMetrics": 0, "resourceLogs": 0}
    with_attrs = 0
    for line in lines:
        try:
            data = json.loads(line)
        except json.JSONDecodeError:
            continue
        for k in kinds:
            if k in data:
                kinds[k] += 1
                found = set(); attrs_in(data[k], found)
                if WANT <= found:
                    with_attrs += 1
    print(f"Trace documents: {kinds['resourceSpans']} | Metric documents: {kinds['resourceMetrics']} | Log documents: {kinds['resourceLogs']}")
    print(f"Documents carrying service.environment + lab.name + lab.number: {with_attrs}/{len(lines)}")

def main():
    print("OpenTelemetry Collector Data Analysis")
    print("=" * 50)
    analyze_file_export()
    print("\n" + "=" * 50)
    print("Analysis complete!")

if __name__ == "__main__":
    main()
