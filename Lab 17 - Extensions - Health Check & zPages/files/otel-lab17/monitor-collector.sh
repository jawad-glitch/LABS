#!/bin/bash

echo "OpenTelemetry Collector Monitoring Dashboard"
echo "==========================================="

while true; do
    clear 2>/dev/null
    echo "OpenTelemetry Collector Status - $(date)"
    echo "========================================"

    # Health check
    echo "Health Status:"
    health_status=$(curl -sf http://localhost:13133/health)
    if [ $? -eq 0 ]; then
        echo "✓ Collector is healthy"
        echo "  $health_status"
    else
        echo "✗ Collector health check failed"
    fi

    echo ""
    echo "Pipeline Statistics:"
    echo "-------------------"

    # Get pipeline stats
    pipeline_stats=$(curl -sf http://localhost:55679/debug/pipelinez 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "✓ Pipeline statistics available"
        echo "  Check http://localhost:55679/debug/pipelinez for details"
    else
        echo "✗ Could not retrieve pipeline statistics"
    fi

    echo ""
    echo "Recent Metrics (sample):"
    echo "----------------------"
    curl -s http://localhost:8888/metrics | grep -E "^(otelcol_receiver|otelcol_exporter)" | head -5

    echo ""
    echo "Press Ctrl+C to exit..."
    sleep 10
done
