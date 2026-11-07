#!/bin/bash

# Besu Log Analysis Script
# Lab 4: Set Up Logging and Data Directories

LOG_DIR="/home/ubuntu/besu-lab/logs"
LATEST_LOG=$(ls -t "$LOG_DIR" | head -1)

if [ -z "$LATEST_LOG" ]; then
    echo "No log files found in $LOG_DIR"
    exit 1
fi

echo "Analyzing latest log file: $LATEST_LOG"
echo "========================================"

echo ""
echo "1. Startup Information:"
echo "----------------------"
grep -i "starting\|started\|data directory" "$LOG_DIR/$LATEST_LOG" | head -10

echo ""
echo "2. Network Information:"
echo "----------------------"
grep -i "network\|p2p\|discovery" "$LOG_DIR/$LATEST_LOG" | head -5

echo ""
echo "3. RPC Information:"
echo "------------------"
grep -i "rpc\|http\|websocket" "$LOG_DIR/$LATEST_LOG" | head -5

echo ""
echo "4. Error Messages (if any):"
echo "---------------------------"
grep -i "error\|exception\|failed" "$LOG_DIR/$LATEST_LOG" | head -5

echo ""
echo "5. Log Statistics:"
echo "-----------------"
echo "Total lines: $(wc -l < "$LOG_DIR/$LATEST_LOG")"
echo "File size: $(du -h "$LOG_DIR/$LATEST_LOG" | cut -f1)"
echo "Creation time: $(stat -c %y "$LOG_DIR/$LATEST_LOG")"
