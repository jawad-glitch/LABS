#!/usr/bin/env python3

import time
import threading
from trace_generator import create_sample_traces

def generate_load(thread_id, num_traces):
    """Generate traces in a separate thread"""
    print(f"Thread {thread_id}: Starting to generate {num_traces} traces")

    for i in range(num_traces):
        create_sample_traces()
        time.sleep(0.1)  # Small delay between traces

    print(f"Thread {thread_id}: Completed generating traces")

if __name__ == "__main__":
    print("Starting load test for multi-export...")

    # Create multiple threads to generate load
    threads = []
    num_threads = 3
    traces_per_thread = 5

    for i in range(num_threads):
        thread = threading.Thread(
            target=generate_load,
            args=(i+1, traces_per_thread)
        )
        threads.append(thread)
        thread.start()

    # Wait for all threads to complete
    for thread in threads:
        thread.join()

    print("Load test completed. Waiting for export...")
    time.sleep(10)
    print("Check both UIs for the generated traces!")
