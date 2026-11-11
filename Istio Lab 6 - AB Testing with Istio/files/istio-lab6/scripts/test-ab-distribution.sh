#!/bin/bash
GATEWAY_URL=$1
TOTAL_REQUESTS=50
V1_COUNT=0
V2_COUNT=0
echo "Testing A/B traffic distribution with $TOTAL_REQUESTS requests..."
for i in $(seq 1 $TOTAL_REQUESTS); do
    RESPONSE=$(curl -s http://$GATEWAY_URL/ | grep -o "Version [0-9]\.[0-9]")
    if [[ $RESPONSE == *"Version 1.0"* ]]; then V1_COUNT=$((V1_COUNT + 1)); echo -n "1"
    elif [[ $RESPONSE == *"Version 2.0"* ]]; then V2_COUNT=$((V2_COUNT + 1)); echo -n "2"
    else echo -n "?"; fi
    if [ $((i % 10)) -eq 0 ]; then echo ""; fi
done
echo "Version 1.0: $V1_COUNT requests ($(( V1_COUNT * 100 / TOTAL_REQUESTS ))%)"
echo "Version 2.0: $V2_COUNT requests ($(( V2_COUNT * 100 / TOTAL_REQUESTS ))%)"
