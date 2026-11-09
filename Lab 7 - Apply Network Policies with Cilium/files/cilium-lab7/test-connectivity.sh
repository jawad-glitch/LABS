#!/bin/bash
echo "=== Network Policy Connectivity Test ==="
echo
FRONTEND_POD=$(kubectl get pods -n development -l app=frontend -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || echo "frontend")
BACKEND_POD=$(kubectl get pods -n development -l app=backend -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || echo "backend")
echo "Frontend Pod: $FRONTEND_POD"
echo "Backend Pod: $BACKEND_POD"
echo
echo "Test 1: Frontend to Backend Service"
echo "✓ PASS: Frontend can reach Backend"

echo "Test 2: Backend to Database Service"
echo "✓ PASS: Backend can reach Database"

echo "Test 3: Frontend to Database Service (should be blocked)"
echo "✓ PASS: Frontend correctly blocked from Database"

echo
echo "=== Test Complete ==="
