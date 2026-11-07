#!/usr/bin/env python3

def print_comparison():
    """Print detailed comparison of gRPC vs HTTP transports"""
    print("=" * 80)
    print("OTLP TRANSPORT COMPARISON: gRPC vs HTTP")
    print("=" * 80)
    print("\n1. ENDPOINT CONFIGURATION:")
    print("-" * 40)
    print("gRPC:\n  - Endpoint: http://localhost:4317\n  - Protocol: Binary gRPC (HTTP/2)\n  - Default Port: 4317\n  - Path: Not required (gRPC service)")
    print("\nHTTP:\n  - Endpoint: http://localhost:4318/v1/traces\n  - Protocol: HTTP/1.1 or HTTP/2 (protobuf or JSON body)\n  - Default Port: 4318\n  - Path: Required (/v1/traces, /v1/metrics, /v1/logs)")
    print("\n2. HEADERS AND AUTHENTICATION:")
    print("-" * 40)
    print("gRPC:\n  - Headers: Optional metadata\n  - Auth: gRPC metadata / TLS\n  - Content-Type: Handled by gRPC")
    print("\nHTTP:\n  - Headers: Standard HTTP headers\n  - Auth: HTTP-based auth (Bearer, Basic, etc.)\n  - Content-Type: application/x-protobuf (or application/json)")
    print("\n3. PERFORMANCE CHARACTERISTICS:")
    print("-" * 40)
    print("gRPC:\n  - Lower overhead (binary protocol)\n  - HTTP/2 multiplexing\n  - Better for high-throughput scenarios")
    print("\nHTTP:\n  - Slightly higher overhead (HTTP headers)\n  - Simpler debugging and monitoring\n  - Better firewall/proxy compatibility")
    print("\n4. USE CASES:")
    print("-" * 40)
    print("gRPC:\n  - High-performance service-to-service export\n  - When network efficiency is critical")
    print("\nHTTP:\n  - Browsers / web apps\n  - When passing through HTTP proxies/load balancers\n  - Easier debugging (curl-able)")
    print("\n5. CONFIGURATION DIFFERENCES:")
    print("-" * 40)
    print("gRPC Configuration:\n  OTLPSpanExporter(\n    endpoint='http://localhost:4317',\n    insecure=True\n  )")
    print("\nHTTP Configuration:\n  OTLPSpanExporter(\n    endpoint='http://localhost:4318/v1/traces',\n    headers={'Content-Type': 'application/x-protobuf'}\n  )")

if __name__ == "__main__":
    print_comparison()
