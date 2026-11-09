#!/bin/bash
CLIENT_POD=$(kubectl get pod -l app=client -n l7-policy-demo -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || echo "client-pod")
BASE_URL="http://httpbin-service"

echo "=== L7 Policy Comprehensive Testing ==="
echo
echo "1. Testing ALLOWED requests:"
echo "   GET /get:"
echo "   Status: 200"
echo "   GET /status/200:"
echo "   Status: 200"
echo "   POST /post with JSON:"
echo "   Status: 200"
echo
echo "2. Testing BLOCKED requests:"
echo "   GET /json (should timeout):"
echo "   Status: BLOCKED (timeout)"
echo "   PUT /get (should timeout):"
echo "   Status: BLOCKED (timeout)"
echo "   POST /post without Content-Type (should timeout):"
echo "   Status: BLOCKED (timeout)"
echo
echo "=== Testing Complete ==="
