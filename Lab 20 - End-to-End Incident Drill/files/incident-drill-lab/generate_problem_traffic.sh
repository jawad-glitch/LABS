#!/bin/bash

echo "Generating traffic with injected issues..."
for i in {1..30}; do
  echo "Request $i:"
  curl -s -o /dev/null -w "Time: %{time_total}s, Status: %{http_code}\n" http://localhost:3000/work
  sleep 2
done
