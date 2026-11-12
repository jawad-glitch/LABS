#!/bin/bash

PROMETHEUS_URL="http://localhost:9090"

# Function to execute PromQL query
execute_query() {
    local query="$1"
    local description="$2"
    
    echo "=== $description ==="
    echo "Query: $query"
    echo ""
    
    # URL encode the query
    encoded_query=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")
    
    # Execute the query
    result=$(curl -s "${PROMETHEUS_URL}/api/v1/query?query=${encoded_query}")
    
    # Pretty print the result
    echo "$result" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    if data['status'] == 'success':
        if data['data']['result']:
            for item in data['data']['result']:
                print(f\"Metric: {item.get('metric', {})}\"")
                print(f\"Value: {item['value'][1]}\"")
                print()
        else:
            print('No data returned')
    else:
        print(f\"Error: {data.get('error', 'Unknown error')}\")
except:
    print('Failed to parse response')
"
    echo "----------------------------------------"
    echo ""
}

# Test if Prometheus is responding
if ! curl -s "$PROMETHEUS_URL/api/v1/status/config" > /dev/null; then
    echo "Error: Cannot connect to Prometheus at $PROMETHEUS_URL"
    exit 1
fi

echo "Prometheus is responding. Executing queries..."
echo ""

# Execute the query passed as argument
if [ $# -eq 2 ]; then
    execute_query "$1" "$2"
else
    echo "Usage: $0 'query' 'description'"
fi
