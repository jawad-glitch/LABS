#!/bin/bash
NAMESPACE="disaster-recovery"
GATEWAY_URL="$1"
if [ -z "$GATEWAY_URL" ]; then echo "Usage: $0 <gateway-url>"; exit 1; fi
echo "=== Disaster Recovery Script ==="
test_service_health() {
    local version=$1
    local success_count=0
    local total_tests=5
    echo "Testing $version health..."
    for i in $(seq 1 $total_tests); do
        if curl -s -f http://$GATEWAY_URL/ > /dev/null 2>&1; then
            ((success_count++))
        fi
        sleep 1
    done
    local success_rate=$((success_count * 100 / total_tests))
    echo "$version success rate: $success_rate%"
    return $success_rate
}
rollback_to_stable() {
    echo "Performing rollback to stable version (v1)..."
    kubectl apply -f - <<YAML
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata: {name: bookstore-vs, namespace: $NAMESPACE}
YAML
    echo "Rollback completed. Waiting for changes to propagate..."
    sleep 5
}
echo "1. Testing current service health..."
if ! test_service_health "current"; then
    if [ $? -lt 80 ]; then
        echo "Service health is below threshold. Initiating rollback..."
        rollback_to_stable
        echo "2. Verifying rollback success..."
        if test_service_health "rollback"; then
            if [ $? -ge 90 ]; then
                echo "✅ Disaster recovery successful!"
            else
                echo "❌ Rollback verification failed."
            fi
        fi
    else
        echo "✅ Service health is acceptable."
    fi
else
    echo "✅ Service is healthy."
fi
echo "=== Recovery Process Complete ==="
