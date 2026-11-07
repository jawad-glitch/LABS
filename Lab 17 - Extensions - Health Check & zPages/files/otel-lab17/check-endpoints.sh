#!/bin/bash
echo "Checking all Collector endpoints..."
# '|' separator: splitting "http://host:port/path:Desc" on ':' would leave the URL as just "http"
endpoints=(
    "http://localhost:13133/health|Health Check"
    "http://localhost:55679/debug/servicez|zPages Service"
    "http://localhost:55679/debug/pipelinez|Pipeline Stats"
    "http://localhost:55679/debug/extensionz|Extensions"
    "http://localhost:8888/metrics|Collector Metrics"
    "http://localhost:4318/v1/traces|OTLP HTTP Traces"
)
for endpoint_info in "${endpoints[@]}"; do
    IFS='|' read -r url description <<< "$endpoint_info"
    echo -n "Testing $description ($url): "
    code=$(curl -s -o /dev/null --max-time 5 -w '%{http_code}' "$url")
    if [ "$code" = 200 ] || { [ "$description" = "OTLP HTTP Traces" ] && [ "$code" = 405 ]; }; then
        echo "✓ OK ($code)"
    else
        echo "✗ FAILED ($code)"
    fi
done
