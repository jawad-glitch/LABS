#!/bin/bash
GATEWAY_URL=$1; DURATION=${2:-60}; INTERVAL=1; V1_COUNT=0; V2_COUNT=0; V1_TOTAL_TIME=0; V2_TOTAL_TIME=0; ERRORS=0
START_TIME=$(date +%s); END_TIME=$((START_TIME + DURATION))
while [ $(date +%s) -lt $END_TIME ]; do
    START_REQUEST=$(date +%s%3N); RESPONSE=$(curl -s -m 2 -w "%{http_code}" http://$GATEWAY_URL/ 2>/dev/null); END_REQUEST=$(date +%s%3N)
    RESPONSE_TIME=$((END_REQUEST - START_REQUEST)); HTTP_CODE="${RESPONSE: -3}"; CONTENT="${RESPONSE%???}"
    if [[ $HTTP_CODE == "200" ]]; then
        if [[ $CONTENT == *"Version 1.0"* ]]; then V1_COUNT=$((V1_COUNT + 1)); V1_TOTAL_TIME=$((V1_TOTAL_TIME + RESPONSE_TIME))
        elif [[ $CONTENT == *"Version 2.0"* ]]; then V2_COUNT=$((V2_COUNT + 1)); V2_TOTAL_TIME=$((V2_TOTAL_TIME + RESPONSE_TIME)); fi
    else ERRORS=$((ERRORS + 1)); fi
    sleep $INTERVAL
done
echo "Total Requests: $((V1_COUNT + V2_COUNT + ERRORS))"
OK_N=$((V1_COUNT + V2_COUNT)); [ $OK_N -gt 0 ] && echo "Version 1.0: $V1_COUNT requests ($(( V1_COUNT * 100 / OK_N ))%)" || echo "No successful responses - check GATEWAY_URL"
[ $OK_N -gt 0 ] && echo "Version 2.0: $V2_COUNT requests ($(( V2_COUNT * 100 / OK_N ))%)"
echo "Errors: $ERRORS"
