#!/bin/bash
echo "🔍 VERIFYING PROMQL QUERIES"
echo "============================"
echo "1. Testing Prometheus connectivity..."
if curl -s http://localhost:9090/api/v1/status/config > /dev/null; then echo "   ✅ Prometheus is accessible"; else echo "   ❌ Cannot connect to Prometheus"; exit 1; fi
echo "2. Testing Node Exporter metrics..."
if curl -s http://localhost:9100/metrics | grep -q "node_cpu_seconds_total"; then echo "   ✅ Node Exporter metrics available"; else echo "   ❌ Node Exporter metrics not found"; exit 1; fi
echo "3. Testing basic PromQL query..."
result=$(curl -s "http://localhost:9090/api/v1/query?query=up")
if echo "$result" | grep -q '"status":"success"'; then echo "   ✅ Basic PromQL query successful"; else echo "   ❌ Basic PromQL query failed"; fi
echo "4. Testing CPU metrics query..."
result=$(curl -s "http://localhost:9090/api/v1/query?query=node_cpu_seconds_total")
if echo "$result" | grep -q '"status":"success"'; then echo "   ✅ CPU metrics query successful"; else echo "   ❌ CPU metrics query failed"; fi
echo "5. Testing memory metrics query..."
result=$(curl -s "http://localhost:9090/api/v1/query?query=node_memory_MemTotal_bytes")
if echo "$result" | grep -q '"status":"success"'; then echo "   ✅ Memory metrics query successful"; else echo "   ❌ Memory metrics query failed"; fi
echo ""
echo "Verification complete! 🎯"
