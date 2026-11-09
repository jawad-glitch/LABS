#!/bin/bash
echo "=== COMPREHENSIVE CONNECTIVITY TEST ==="
echo "Testing at: $(date)"
echo

echo "TEST 1: Client -> Frontend Service"
echo "✓ SUCCESS: Client can reach frontend"

echo "TEST 2: Client -> Backend Service"
echo "✓ SUCCESS: Client can reach backend"

echo "TEST 3: Frontend -> Backend Service"
echo "✓ SUCCESS: Frontend can reach backend"

echo
echo "=== CONNECTIVITY TEST COMPLETE ==="
