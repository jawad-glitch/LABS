# Simulated steps (fast mode) - Lab 12 - Integrate Prometheus for Rollout Validation
No cluster, Prometheus Operator or Rollouts controller ran.
Real: Prometheus v3.16.0 scraping 5+5 real app containers (python exporter with true counters + histogram) under live HTTP load; the lab's own
AnalysisTemplate PromQL (job="sample-app-service") evaluated against it with successCondition/count/failureLimit semantics; bug reproductions; schema validation.
Simulated: ServiceMonitor discovery replaced by an equivalent static scrape job (same job label); intervals 30s/20s compressed to 5s; Rollout step decisions inferred from AnalysisRun phase.

Full mode:
kubectl apply --server-side --force-conflicts -f https://github.com/prometheus-operator/prometheus-operator/releases/download/v0.95.1/bundle.yaml
kubectl wait --for=condition=Available deploy/prometheus-operator -n default --timeout=300s
kubectl apply -f prometheus-instance.yaml -f sample-app.yaml -f analysis-template.yaml -f failing-analysis-template.yaml -f rollout-with-analysis.yaml
kubectl argo rollouts set image sample-app-rollout sample-app=python:3.13-alpine    # not kubectl patch (strategic merge unsupported on CRDs)
kubectl argo rollouts status sample-app-rollout --timeout 600s                       # not -w / sleep 180 / read
kubectl apply -f rollout-strict-analysis.yaml; kubectl argo rollouts status sample-app-rollout --timeout 300s   # expect Degraded (analysis Failed -> aborted)
