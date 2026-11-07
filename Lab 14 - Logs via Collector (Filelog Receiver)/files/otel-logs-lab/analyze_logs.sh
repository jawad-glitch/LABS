#!/bin/bash

LOG_FILE="logs/app.log"

echo "=== Log Analysis Report ==="
echo "Total log entries: $(wc -l < $LOG_FILE)"
echo ""

echo "=== Log Levels ==="
jq -r '.level' $LOG_FILE | sort | uniq -c
echo ""

echo "=== Unique Trace IDs ==="
UNIQUE_TRACES=$(jq -r '.trace_id' $LOG_FILE | grep -v null | sort | uniq | wc -l)
echo "Total unique traces: $UNIQUE_TRACES"
echo ""

echo "=== Recent Error Logs ==="
jq 'select(.level == "ERROR")' $LOG_FILE | tail -3
echo ""

echo "=== Sample Trace Correlation ==="
SAMPLE_TRACE=$(jq -r '.trace_id' $LOG_FILE | grep -v null | head -1)
echo "Sample Trace ID: $SAMPLE_TRACE"
echo "Log entries for this trace:"
jq "select(.trace_id == \"$SAMPLE_TRACE\")" $LOG_FILE | jq -s 'length'
