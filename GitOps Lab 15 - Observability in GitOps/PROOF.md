# GitOps Lab 15 - Observability in GitOps - completion proof
Completed (UTC): 2026-11-10 09:22:25 | EC2: i-04b8b0acdf9378652 | host: ip-172-31-10-24 | user: ubuntu

## Core checks
```
========== CORE CHECKS (GitOps Lab 15 - Observability in GitOps, 2026-11-10 09:22:19 UTC) - ARGO CD/CLUSTER SIMULATED, PROMETHEUS + GRAFANA REAL ==========
PASS: Lab bug: application-controller is a StatefulSet (wait/rollout on deployment/... fail)
PASS: Lab bug: install.yaml already ships metrics Services on 8082/8083/8084 (lab duplicates them)
PASS: Lab bug: *.metrics.enabled are not argocd-cmd-params-cm keys Argo CD reads (CMDPARAMS_KEYS_READ 192 found)
PASS: promtool: lab config + rules valid but rule_files empty; fixed rules valid
PASS: Task 2: Prometheus v3.16.0 scrapes all 3 Argo CD jobs (up) [exporter simulated]; rules LOADED (lab: never loaded)
PASS: Lab bug: Grafana as written has NO datasource and no dashboard (ConfigMap never mounted, JSON never imported)
PASS: Task 3 fixed: Grafana v13.3.0 provisioned datasource (health OK) + ArgoCD GitOps Dashboard
PASS: Panel query via Grafana API returns live frames (health_status breakdown)
PASS: Scenario: healthy 2/2 Synced+Healthy -> 1 OutOfSync/Degraded; failed-sync rate > 0
PASS: Rules evaluated: recording health_degraded=1, failure_rate>0; alerts ArgoCDAppDegraded firing, ArgoCDSyncFailure pending (for: 5m)
PASS: Fixed Prometheus RBAC (networking.k8s.io ingresses) schema-valid; all ports bound to 127.0.0.1
PASS: Time: finished in 139s (<= 300s)
CORE: 12/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                     ID             DISK USAGE   CONTENT SIZE   EXTRA
grafana/grafana:13.3.0    488984b716c0       2.01GB          503MB        
prom/prometheus:latest    e04987641b57        389MB          116MB        
prom/prometheus:v3.16.0   e04987641b57        389MB          116MB        
```

## Files
```
./gitops-lab15/exporter/argocd-metrics-sim.py
./gitops-lab15/exporter/state.json
./gitops-lab15/grafana/dashboards/argocd-gitops.json
./gitops-lab15/grafana/provisioning/dashboards/provider.yaml
./gitops-lab15/grafana/provisioning/datasources/prometheus.yaml
./gitops-lab15/k8s-fixed/prometheus-rbac.yaml
./gitops-lab15/k8s-fixed/prometheus-scrape-argocd.yml
./gitops-lab15/lab-original/argocd-dashboard.json
./gitops-lab15/lab-original/argocd.rules
./gitops-lab15/lab-original/prometheus.yml
./gitops-lab15/prom/prometheus.yml
./gitops-lab15/prom/rules/argocd.rules.yml
./gitops-lab15/results/SIMULATED.md
./gitops-lab15/results/bug-cmd-params-keys.txt
./gitops-lab15/results/bug-grafana-lab-as-written.txt
./gitops-lab15/results/elapsed.txt
./gitops-lab15/results/image-pull.txt
./gitops-lab15/results/kubeconform.txt
./gitops-lab15/results/task-rules-loaded.txt
./gitops-lab15/results/task1-install-analysis.txt
./gitops-lab15/results/task2-promtool.txt
./gitops-lab15/results/task2.6-targets.txt
./gitops-lab15/results/task3-grafana-fixed.txt
./gitops-lab15/results/task3-grafana-panel-query.txt
./gitops-lab15/results/task3.6-degraded.txt
./gitops-lab15/results/task3.6-healthy.txt
./gitops-lab15/results/versions.txt
```
