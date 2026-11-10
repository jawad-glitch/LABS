#!/bin/bash
echo "Cleaning up old version (v1)..."
kubectl scale deployment backend-v1 --replicas=0 -n canary-demo
echo "v1 deployment scaled down to 0 replicas."
