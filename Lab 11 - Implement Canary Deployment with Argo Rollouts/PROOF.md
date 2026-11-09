# Lab 11 - Implement Canary Deployment with Argo Rollouts - completion proof
Completed (UTC): 2026-11-09 12:45:48 | EC2: i-0dcb7ae044b5b5c8b | host: ip-172-31-10-25 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 11 - Implement Canary Deployment with Argo Rollouts, 2026-11-09 12:45:42 UTC) - FAST MODE ==========
PASS: Lab bug: original rollout-canary.yaml rejected by Rollout CRD schema (canaryReplicas, analysis.interval unknown)
PASS: Task 2-4/8: all fixed manifests (Rollouts, services, AnalysisTemplates, Prometheus + RBAC) valid (strict)
FAIL: Lab bug: Prometheus v3.16.0 exits with the lab console flags; fixed args reach /-/ready 200
PASS: Task 4.1: lab scrape config valid per promtool v3.16.0
PASS: Task 3.2 [SIMULATED cluster, real pods+traffic]: initial rollout 5x blue serves 100% blue
PASS: Task 5.2: setWeight 20 -> 1/5 yellow pod, observed yellow share 23% (expected ~20)
PASS: Task 4.3 [SIMULATED metric source]: canary success-rate 100/100 >= 0.95 and p95 0.001901s <= 0.5s
PASS: Task 6.1: promote through 40/60/80 - yellow share rises, 100% yellow at setWeight 100
PASS: Task 6.2: red canary got traffic, abort -> 0% red, 100% stable yellow
PASS: Task 8: stableService -> only stable (blue), canaryService -> only canary (yellow); trafficRouting removed (no provider)
PASS: Task 1.3/6: kubectl-argo-rollouts v1.10.2; promote --full and abort available
PASS: Time: fast-mode run finished in 93s (<= 300s)
CORE: 11/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                           ID             DISK USAGE   CONTENT SIZE   EXTRA
argoproj/rollouts-demo:blue     211345b036e2       17.2MB         6.21MB        
argoproj/rollouts-demo:red      ec2c616f8b19       17.2MB         6.21MB        
argoproj/rollouts-demo:yellow   61ca0c39c512       17.2MB         6.21MB        
prom/prometheus:v3.16.0         e04987641b57        389MB          116MB        
```

## Files
```
./canary-lab11/advanced-rollout-canary.yaml
./canary-lab11/analysis-template-prometheus.yaml
./canary-lab11/analysis-template.yaml
./canary-lab11/app-service.yaml
./canary-lab11/canary-services.yaml
./canary-lab11/lab-original-advanced-rollout-canary.yaml
./canary-lab11/lab-original-rollout-canary.yaml
./canary-lab11/monitor-canary.sh
./canary-lab11/namespaces.yaml
./canary-lab11/prom/prometheus.yml
./canary-lab11/prom/self.yml
./canary-lab11/prometheus-config.yaml
./canary-lab11/prometheus-deployment.yaml
./canary-lab11/query-metrics.sh
./canary-lab11/results/SIMULATED.md
./canary-lab11/results/bug1-original-advanced-kubeconform.txt
./canary-lab11/results/bug1-original-rollout-kubeconform.txt
./canary-lab11/results/bug3-prometheus-lab-args.txt
./canary-lab11/results/elapsed.txt
./canary-lab11/results/image-pull.log
./canary-lab11/results/install-kubeconform.log
./canary-lab11/results/install-rollouts-cli.log
./canary-lab11/results/lab-original-history-cmd.txt
./canary-lab11/results/simulation-timeline.txt
./canary-lab11/results/task-fixed-kubeconform.txt
./canary-lab11/results/task1.3-cli-version.txt
./canary-lab11/results/task4-prometheus-buildinfo.json
./canary-lab11/results/task4-promtool-check.txt
./canary-lab11/results/task6-abort-help.txt
./canary-lab11/results/task6-promote-help.txt
./canary-lab11/results/traffic.txt
./canary-lab11/results/versions.txt
./canary-lab11/rollout-canary.yaml
```
