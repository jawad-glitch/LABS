#!/bin/bash

PROMETHEUS_URL="http://localhost:9090"

execute_monitoring_query() {
    local query="$1"
    local description="$2"
    local unit="$3"
    
    echo "📊 $description"
    echo "Query: $query"
    
    encoded_query=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")
    
    result=$(curl -s "${PROMETHEUS_URL}/api/v1/query?query=${encoded_query}")
    
    echo "$result" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    if data['status'] == 'success' and data['data']['result']:
        for item in data['data']['result']:
            value = float(item['value'][1])
            metric_labels = item.get('metric', {})
            
            if '$unit' == 'percentage':
                formatted_value = f'{value:.2f}%'
            elif '$unit' == 'gb':
                formatted_value = f'{value:.2f} GB'
            elif '$unit' == 'mb':
                formatted_value = f'{value:.2f} MB'
            elif '$unit' == 'bytes':
                formatted_value = f'{value:,.0f} bytes'
            else:
                formatted_value = f'{value:.4f}'
            
            if metric_labels:
                labels_str = ', '.join([f'{k}={v}' for k, v in metric_labels.items()])
                print(f'  {labels_str}: {formatted_value}')
            else:
                print(f'  Value: {formatted_value}')
    else:
        print('  No data available')
except Exception as e:
    print(f'  Error parsing result: {e}')
"
    echo ""
}

echo "🖥️  SYSTEM MONITORING DASHBOARD"
echo "=================================="
echo ""
echo "🔥 CPU MONITORING"
echo "-----------------"
execute_monitoring_query 'avg(rate(node_cpu_seconds_total{mode!="idle"}[5m])) * 100' 'Overall CPU Usage' 'percentage'
execute_monitoring_query 'avg by (mode) (rate(node_cpu_seconds_total[5m])) * 100' 'CPU Usage by Mode' 'percentage'
execute_monitoring_query 'avg by (cpu) (rate(node_cpu_seconds_total{mode!="idle"}[5m])) * 100' 'CPU Usage per Core' 'percentage'
echo "💾 MEMORY MONITORING"
echo "--------------------"
execute_monitoring_query 'node_memory_MemTotal_bytes / 1024 / 1024 / 1024' 'Total Memory' 'gb'
execute_monitoring_query 'node_memory_MemAvailable_bytes / 1024 / 1024 / 1024' 'Available Memory' 'gb'
execute_monitoring_query '(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / 1024 / 1024 / 1024' 'Used Memory' 'gb'
execute_monitoring_query '(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100' 'Memory Usage' 'percentage'
echo "📈 AGGREGATION EXAMPLES"
echo "-----------------------"
execute_monitoring_query 'sum(rate(node_cpu_seconds_total{mode!="idle"}[5m])) * 100' 'Total CPU Usage (All Cores)' 'percentage'
execute_monitoring_query 'sum by (mode) (rate(node_cpu_seconds_total[5m])) * 100' 'CPU Time by Mode (Aggregated)' 'percentage'
echo "Dashboard complete! 🎉"
