#!/bin/bash
echo "Rolling back to stable version (v1)..."
kubectl apply -f backend-virtual-service-v1.yaml
echo "Rollback completed. All traffic now goes to v1."
