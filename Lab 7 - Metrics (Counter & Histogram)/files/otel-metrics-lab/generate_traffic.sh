#!/bin/bash

echo "Generating diverse traffic patterns..."

# Burst of fast requests
echo "Generating fast requests..."
for i in {1..10}; do
  curl -s http://localhost:5000/fast > /dev/null &
done
wait

sleep 2

# Some slow requests
echo "Generating slow requests..."
for i in {1..5}; do
  curl -s http://localhost:5000/slow > /dev/null &
done
wait

sleep 2

# Mixed error requests
echo "Generating error-prone requests..."
for i in {1..8}; do
  curl -s -o /dev/null -w '%{http_code}\n' http://localhost:5000/error >> /tmp/otel07-error-codes.txt &
done
wait

sleep 2

# Health checks
echo "Generating health checks..."
for i in {1..15}; do
  curl -s http://localhost:5000/health > /dev/null &
done
wait

echo "Traffic generation complete!"
