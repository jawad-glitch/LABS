#!/bin/bash

# Besu Logging Startup Script
# Lab 4: Set Up Logging and Data Directories

# Set variables
BESU_HOME="/home/ubuntu/besu-lab"
CONFIG_FILE="$BESU_HOME/config/config.toml"
LOG_DIR="$BESU_HOME/logs"
LOG_FILE="$LOG_DIR/besu-$(date +%Y%m%d-%H%M%S).log"

# Create log file
touch "$LOG_FILE"

echo "Starting Besu with logging..."
echo "Configuration file: $CONFIG_FILE"
echo "Log file: $LOG_FILE"
echo "Data directory: $BESU_HOME/data"
echo "----------------------------------------"

# Start Besu with logging
besu --config-file="$CONFIG_FILE" 2>&1 | tee "$LOG_FILE"
