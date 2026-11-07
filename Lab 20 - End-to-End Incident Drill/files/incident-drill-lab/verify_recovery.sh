#!/bin/bash

echo "Verifying system recovery..."
echo "Generating normal traffic to confirm latency is back to baseline..."

for i in {1..15}; do
  echo "Recovery test $i:"
  curl -s -o /dev/null -w "Time: %{time_total}s, Status: %{http_code}\n" http://localhost:3000/work
  sleep 1
done

echo "Recovery verification complete"
