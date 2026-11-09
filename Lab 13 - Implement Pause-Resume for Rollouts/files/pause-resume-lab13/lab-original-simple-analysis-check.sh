if curl -s http://sample-app-service.rollout-demo.svc.cluster.local > /dev/null; then echo "Health check passed"; exit 0; else echo "Health check failed"; exit 1; fi
