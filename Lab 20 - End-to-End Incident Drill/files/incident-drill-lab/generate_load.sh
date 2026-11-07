#!/bin/bash

echo "Generating baseline traffic..."
for i in {1..20}; do
  curl -s http://localhost:3000/work > /dev/null
  sleep 1
done
echo "Baseline traffic generation complete"
