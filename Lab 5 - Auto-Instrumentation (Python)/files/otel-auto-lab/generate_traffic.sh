#!/bin/bash
echo "Generating traffic for 30 seconds..."
for i in {1..30}; do
    curl -s http://localhost:8000/ > /dev/null
    curl -s http://localhost:8000/api/data > /dev/null
    curl -s http://localhost:8000/health > /dev/null

    # Every 5th request, call external API
    if [ $((i % 5)) -eq 0 ]; then
        curl -s http://localhost:8000/api/external > /dev/null
    fi

    sleep 1
done
echo "Traffic generation complete!"
