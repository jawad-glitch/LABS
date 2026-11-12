#!/bin/bash
echo "Generating CPU load for 60 seconds..."
for i in {1..4}; do
    yes > /dev/null &
done
sleep 60
killall yes
echo "CPU load generation completed"
