#!/bin/bash

# Besu Configuration Verification Script
# Lab 4: Set Up Logging and Data Directories

echo "Besu Configuration Verification"
echo "==============================="

echo ""
echo "1. Directory Structure:"
echo "----------------------"
echo "Data directory: $(ls -ld /home/ubuntu/besu-lab/data 2>/dev/null && echo "OK EXISTS" || echo "MISSING")"
echo "Logs directory: $(ls -ld /home/ubuntu/besu-lab/logs 2>/dev/null && echo "OK EXISTS" || echo "MISSING")"
echo "Config directory: $(ls -ld /home/ubuntu/besu-lab/config 2>/dev/null && echo "OK EXISTS" || echo "MISSING")"

echo ""
echo "2. Configuration File:"
echo "---------------------"
if [ -f /home/ubuntu/besu-lab/config/config.toml ]; then
    echo "Config file: OK EXISTS"
    echo "Data path configured: $(grep -q "data-path" /home/ubuntu/besu-lab/config/config.toml && echo "OK YES" || echo "NO")"
    echo "Logging configured: $(grep -q "logging" /home/ubuntu/besu-lab/config/config.toml && echo "OK YES" || echo "NO")"
else
    echo "Config file: MISSING"
fi

echo ""
echo "3. Data Directory Contents:"
echo "--------------------------"
if [ -d /home/ubuntu/besu-lab/data ] && [ "$(ls -A /home/ubuntu/besu-lab/data)" ]; then
    echo "Data directory populated: OK YES"
    ls -la /home/ubuntu/besu-lab/data/
else
    echo "Data directory populated: NO (Run Besu first)"
fi

echo ""
echo "4. Log Files:"
echo "------------"
if [ -d /home/ubuntu/besu-lab/logs ] && [ "$(ls -A /home/ubuntu/besu-lab/logs)" ]; then
    echo "Log files present: OK YES"
    echo "Number of log files: $(ls /home/ubuntu/besu-lab/logs | wc -l)"
    echo "Latest log file: $(ls -t /home/ubuntu/besu-lab/logs | head -1)"
else
    echo "Log files present: NO (Run Besu with logging first)"
fi

echo ""
echo "Verification complete!"
