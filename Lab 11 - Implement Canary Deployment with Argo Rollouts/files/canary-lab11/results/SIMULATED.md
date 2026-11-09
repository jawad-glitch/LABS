# Simulated steps (fast mode) - Lab 11 - Implement Canary Deployment with Argo Rollouts
No cluster or Rollouts controller ran. Real: strict schema validation (originals rejected, fixed pass), Prometheus v3.16.0 crash with lab args /
ready with fixed args / promtool config check, and the canary flow: real argoproj/rollouts-demo containers scaled per step exactly as a
replica-based canary (canary=ceil(5*weight/100), stable=5-canary), 100 real HTTP requests per step sent to random pod IPs (kube-proxy-like).
Analysis metrics (success rate, p95 latency) come from that measured traffic instead of Prometheus. Pause durations were not waited.

Full-mode commands: kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/download/v1.10.2/install.yaml;
kubectl apply -f namespaces.yaml -f app-service.yaml -f analysis-template.yaml -f rollout-canary.yaml;
kubectl argo rollouts set image rollout-canary rollouts-demo=argoproj/rollouts-demo:yellow -n canary-demo;
kubectl argo rollouts status rollout-canary -n canary-demo --timeout 300s (instead of --watch); kubectl argo rollouts promote rollout-canary -n canary-demo;
abort: kubectl argo rollouts abort rollout-canary -n canary-demo; then kubectl argo rollouts set image rollout-canary rollouts-demo=argoproj/rollouts-demo:yellow -n canary-demo to clear Degraded.
Prometheus: kubectl apply -f prometheus-config.yaml -f prometheus-deployment.yaml; nohup kubectl port-forward -n monitoring svc/prometheus-service 9090:9090 >pf.log 2>&1 &; ./query-metrics.sh
