#!/bin/bash

echo "Generating traffic to the application..."
echo "Press Ctrl+C to stop"

while true; do
    # Hit the health endpoint
    curl -s http://localhost:8080/health > /dev/null

    # Random delay between requests
    sleep $(echo "scale=2; $RANDOM/32767*2" | bc -l)
done
