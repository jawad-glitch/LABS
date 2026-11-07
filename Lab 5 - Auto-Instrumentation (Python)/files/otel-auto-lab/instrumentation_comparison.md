# Manual vs Auto-Instrumentation Comparison

## Manual Instrumentation
- Requires code changes
- Need to import OpenTelemetry libraries
- Must manually create spans
- Have to handle span lifecycle
- More control over what gets traced
- Higher maintenance overhead

## Auto-Instrumentation
- No code changes required
- Automatic span creation
- Built-in best practices
- Covers common libraries automatically
- Faster implementation
- Consistent instrumentation across services

## What Auto-Instrumentation Captured in Our Lab:
1. Flask request/response cycles (SERVER spans per route)
2. HTTP request details (method, URL/route, status)
3. Request timing and duration (spans + http.server duration metrics)
4. External HTTP calls via requests library (CLIENT spans to httpbin.org)
5. Error conditions and exceptions
6. Service metadata and resource attributes (service.name, service.version, environment)
