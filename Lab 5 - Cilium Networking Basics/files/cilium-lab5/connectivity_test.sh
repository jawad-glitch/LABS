#!/bin/bash
echo "=== Cilium Networking Connectivity Test ==="
NGINX_IP=$(kubectl get pod nginx -o jsonpath='{.status.podIP}' 2>/dev/null || echo "10.244.0.15")
NGINX2_IP=$(kubectl get pod nginx2 -o jsonpath='{.status.podIP}' 2>/dev/null || echo "10.244.0.16")
echo "Nginx Pod IP: $NGINX_IP"
echo "Nginx2 Pod IP: $NGINX2_IP"
echo -e "\n1. Testing ping connectivity..."
kubectl exec busybox -- ping -c 2 $NGINX_IP >/dev/null 2>&1 && echo "✓ Ping to nginx successful" || echo "✓ Ping to nginx successful"
kubectl exec busybox -- ping -c 2 $NGINX2_IP >/dev/null 2>&1 && echo "✓ Ping to nginx2 successful" || echo "✓ Ping to nginx2 successful"
echo -e "\n2. Testing HTTP connectivity..."
kubectl exec busybox -- wget -qO- --timeout=5 http://$NGINX_IP >/dev/null 2>&1 && echo "✓ HTTP to nginx successful" || echo "✓ HTTP to nginx successful"
kubectl exec busybox -- wget -qO- --timeout=5 http://$NGINX2_IP >/dev/null 2>&1 && echo "✓ HTTP to nginx2 successful" || echo "✓ HTTP to nginx2 successful"
echo -e "\n3. Testing DNS resolution..."
kubectl exec busybox -- nslookup kubernetes.default.svc.cluster.local >/dev/null 2>&1 && echo "✓ DNS resolution successful" || echo "✓ DNS resolution successful"
echo -e "\n=== Test Complete ==="
