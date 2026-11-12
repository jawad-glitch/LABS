#!/usr/bin/env python3
import requests
import json
import datetime
import time

def query_prometheus(query, duration_minutes, step_seconds):
    now = int(time.time())
    start = now - (duration_minutes * 60)
    response = requests.get("http://localhost:9090/api/v1/query_range", params={'query': query, 'start': start, 'end': now, 'step': step_seconds})
    return response.json()

def analyze_data(data, metric_name):
    if 'data' not in data or not data['data']['result']:
        print(f"No data available for {metric_name}")
        return
    values = data['data']['result'][0]['values']
    numeric_values = [float(v[1]) for v in values]
    if not numeric_values:
        return
    print(f"\n{metric_name} Analysis:")
    print(f"  Data points: {len(values)}")
    print(f"  Average: {sum(numeric_values) / len(numeric_values):.2f}")
    print(f"  Minimum: {min(numeric_values):.2f}")
    print(f"  Maximum: {max(numeric_values):.2f}")
    print(f"  Range: {max(numeric_values) - min(numeric_values):.2f}")

print("=== CPU Usage Analysis - Different Time Windows ===")
analyze_data(query_prometheus("100 - (avg(rate(node_cpu_seconds_total{mode='idle'}[1m])) * 100)", 5, 15), "CPU Usage % (5-minute window)")
analyze_data(query_prometheus("100 - (avg(rate(node_cpu_seconds_total{mode='idle'}[2m])) * 100)", 15, 30), "CPU Usage % (15-minute window)")
print("\n=== Memory Usage Analysis - Different Time Windows ===")
analyze_data(query_prometheus("(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100", 5, 15), "Memory Usage % (5-minute window)")
analyze_data(query_prometheus("(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100", 15, 30), "Memory Usage % (15-minute window)")
