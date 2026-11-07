#!/usr/bin/env python3

import time
import threading
from app_grpc import setup_telemetry_grpc, generate_telemetry_data as generate_grpc
from app_http import setup_telemetry_http, generate_telemetry_data as generate_http

def test_grpc_transport():
    """Test gRPC transport in a separate thread"""
    print("Starting gRPC transport test...")
    tracer, meter = setup_telemetry_grpc()
    generate_grpc(tracer, meter)
    print("gRPC transport test completed")

def test_http_transport():
    """Test HTTP transport in a separate thread"""
    print("Starting HTTP transport test...")
    tracer, meter = setup_telemetry_http()
    generate_http(tracer, meter)
    print("HTTP transport test completed")

if __name__ == "__main__":
    # Previous data is cleared by the shell (delete + collector restart): the collector owns the open file
    print("Testing both transports simultaneously...")

    # Create threads for both transports
    grpc_thread = threading.Thread(target=test_grpc_transport)
    http_thread = threading.Thread(target=test_http_transport)

    # Start both threads
    grpc_thread.start()
    time.sleep(2)  # Slight delay to see the difference
    http_thread.start()

    # Wait for both to complete
    grpc_thread.join()
    http_thread.join()

    print("Both transport tests completed!")

    # Allow time for final exports
    time.sleep(10)
