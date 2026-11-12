#!/usr/bin/env python3
import requests
import json
import datetime
import time

def query_prometheus(query, start_time, end_time, step):
    url = f"http://localhost:9090/api/v1/query_range"
    params = {'query': query, 'start': start_time, 'end': end_time, 'step': step}
    response = requests.get(url, params=params)
    return response.json()

now = int(time.time())
five_min_ago = now - 300
query = "node_memory_MemAvailable_bytes"
print("=== Memory Available - Different Resolutions ===")
print("\nHigh Resolution (15-second steps):")
high_res = query_prometheus(query, five_min_ago, now, 15)
if 'data' in high_res and high_res['data']['result']:
    values = high_res['data']['result'][0]['values']
    print(f"Data points: {len(values)}")
    for value in values[-5:]:
        print(f"  {datetime.datetime.fromtimestamp(float(value[0])).strftime('%H:%M:%S')}: {float(value[1]) / (1024**3):.2f} GB")
print("\nLow Resolution (60-second steps):")
low_res = query_prometheus(query, five_min_ago, now, 60)
if 'data' in low_res and low_res['data']['result']:
    values = low_res['data']['result'][0]['values']
    print(f"Data points: {len(values)}")
    for value in values:
        print(f"  {datetime.datetime.fromtimestamp(float(value[0])).strftime('%H:%M:%S')}: {float(value[1]) / (1024**3):.2f} GB")
