#!/usr/bin/env python3
"""
Stress test for OpenTelemetry Collector memory limiter
"""

import time
import requests
import threading
from generate_test_data import generate_trace_data, generate_metric_data, send_data

results = {"ok": 0, "fail": 0}
lock = threading.Lock()

def stress_test_worker(worker_id, duration=30):
    """Worker function to generate continuous load"""
    print(f"Worker {worker_id} starting stress test for {duration} seconds...")
    start_time = time.time()
    count = 0
    while time.time() - start_time < duration:
        ok1 = send_data("http://localhost:4318/v1/traces", generate_trace_data())
        ok2 = send_data("http://localhost:4318/v1/metrics", generate_metric_data())
        with lock:
            results["ok"] += int(ok1) + int(ok2)
            results["fail"] += int(not ok1) + int(not ok2)
        count += 2
        time.sleep(0.1)  # Small delay
    print(f"Worker {worker_id} completed. Sent {count} requests.")

def main():
    """Main stress test function"""
    print("Starting OpenTelemetry Collector Stress Test")
    print("This will test the memory limiter functionality")
    print("=" * 60)
    workers = []
    num_workers = 3
    duration = 20  # seconds
    for i in range(num_workers):
        worker = threading.Thread(target=stress_test_worker, args=(i+1, duration))
        workers.append(worker)
        worker.start()
    for worker in workers:
        worker.join()
    print(f"\nStress test completed! accepted={results['ok']} rejected={results['fail']}")
    print("Check collector logs and resource usage.")

if __name__ == "__main__":
    main()
