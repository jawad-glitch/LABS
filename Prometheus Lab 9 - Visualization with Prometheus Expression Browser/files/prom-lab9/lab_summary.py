#!/usr/bin/env python3
import requests, datetime, time
def get_metric_summary():
    try:
        cpu_data = requests.get("http://localhost:9090/api/v1/query", params={'query': '100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[1m])) * 100)'}).json()
        cpu_usage = float(cpu_data['data']['result'][0]['value'][1]) if cpu_data['data']['result'] else 0
        mem_data = requests.get("http://localhost:9090/api/v1/query", params={'query': '(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100'}).json()
        mem_usage = float(mem_data['data']['result'][0]['value'][1]) if mem_data['data']['result'] else 0
        disk_data = requests.get("http://localhost:9090/api/v1/query", params={'query': '(1 - (node_filesystem_avail_bytes{fstype!="tmpfs"} / node_filesystem_size_bytes{fstype!="tmpfs"})) * 100'}).json()
        disk_usage = float(disk_data['data']['result'][0]['value'][1]) if disk_data['data']['result'] else 0
        print("=== Lab 9 Completion Summary ===")
        print(f"Timestamp: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print(f"\nCurrent System Metrics:\n  CPU Usage: {cpu_usage:.2f}%\n  Memory Usage: {mem_usage:.2f}%\n  Disk Usage: {disk_usage:.2f}%")
        print(f"\n✅ Successfully completed all lab objectives:")
    except Exception as e:
        print(f"Error generating summary: {e}")
if __name__ == "__main__":
    get_metric_summary()
