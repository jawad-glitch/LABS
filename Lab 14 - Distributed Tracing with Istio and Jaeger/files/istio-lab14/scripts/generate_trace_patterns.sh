#!/bin/bash
echo "Generating different trace patterns..."
for i in {1..3}; do curl -s http://localhost:8080/productpage > /dev/null & done; wait; sleep 2
for i in {1..3}; do curl -s http://localhost:8080/productpage > /dev/null; sleep 1; done
for i in {1..3}; do curl -s http://localhost:8080/api/v1/products > /dev/null; sleep 1; done
echo "Pattern generation complete!"
