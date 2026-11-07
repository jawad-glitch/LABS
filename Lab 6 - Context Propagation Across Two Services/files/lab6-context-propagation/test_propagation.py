#!/usr/bin/env python3

import requests
import time
import json

def test_context_propagation():
    """
    Test context propagation by making multiple requests
    """
    print("Testing Context Propagation Across Services")
    print("=" * 50)

    for i in range(3):
        print(f"\nTest Request {i+1}:")
        print("-" * 20)

        try:
            response = requests.get("http://localhost:8000/process")

            if response.status_code == 200:
                result = response.json()
                print(f"Status: {result['status']}")
                print(f"Message: {result['message']}")
                print(f"Worker Items Processed: {result['worker_response']['processed_items']}")
                print(f"Total Processing Time: {result['total_processing_time']}s")
            else:
                print(f"Error: HTTP {response.status_code}")

        except requests.exceptions.RequestException as e:
            print(f"Request failed: {e}")

        # Wait between requests
        if i < 2:
            time.sleep(2)

    print("\nTest completed. Check both service logs for trace relationships.")

if __name__ == "__main__":
    test_context_propagation()
