# Lab 20 - Troubleshooting Argo Tools - completion proof
Completed (UTC): 2026-11-09 13:55:43 | EC2: i-0d9832a7525db1619 | host: ip-172-31-10-98 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 20 - Troubleshooting Argo Tools, 2026-11-09 13:55:37 UTC) - FAST MODE ==========
PASS: Task 1.2: argo v4.1.6, argocd v3.6.1, kubectl-argo-rollouts v1.10.2 installed (checksum verified)
PASS: All fixed manifests valid (strict): workflow, git-repo manifests, Argo CD app, Rollout+services+AnalysisTemplate, Prometheus; scripts parse
PASS: Task 1.1-1.3 [SIMULATED controller, real steps]: step1 Succeeded, step2 Failed exit 1, step3 Omitted -> workflow Failed
PASS: Task 1.3-1.5: failed node located from status, its main-container logs with timestamps show the error; argo logs -c is a container flag (lab misuse)
PASS: Task 2 insight: lab ConfigMap is valid K8s (syncs fine) - only the embedded config.yaml is broken
PASS: Task 2.4: real sync-health causes - nonexistent-image pull fails; Service targetPort 8080 refused by nginx (listens 80)
PASS: Task 2.5: fixed manifests - nginx:1.27-alpine serves HTTP 200 through sample-app-service:80; fix committed
FAIL: Lab bug: Prometheus v3.16.0 exits with the lab console flags; fixed flags reach /-/ready; fixed scrape config passes promtool
PASS: Lab bug: lab keep-rule requires prometheus.io/scrape, absent on the real Rollouts v1.10.2 controller pod (0 targets); fixed scrapes the :8090 metrics Service
PASS: Task 3.3 [SIMULATED controller, real pods]: nginx:invalid-tag canary cannot pull; stable pods keep serving 100% (1.26=40/40)
PASS: Task 3.6: undo + valid image 1.27 - canary passed HTTP analysis, mixed traffic at 40%, 100% on 1.27 after promote
PASS: Lab bug: kubectl argo rollouts history does not exist (CLI v1.10.2) - fixed script uses get rollout
PASS: Time: fast-mode run finished in 93s (<= 300s)
CORE: 12/13 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                     ID             DISK USAGE   CONTENT SIZE   EXTRA
alpine:3.20               d9e853e87e55       12.2MB         3.71MB        
curlimages/curl:7.85.0    9fab1b73f45e       24.9MB         8.57MB        
nginx:1.26-alpine         1eadbb078203         73MB         21.5MB        
nginx:1.27-alpine         65645c7bb6a0       74.5MB         21.9MB        
prom/prometheus:v3.16.0   e04987641b57        389MB          116MB        
```

## Files
```
./argo-troubleshoot-lab20/argocd-app.yaml
./argo-troubleshoot-lab20/failing-workflow.yaml
./argo-troubleshoot-lab20/git-repo/manifests/configmap.yaml
./argo-troubleshoot-lab20/git-repo/manifests/deployment.yaml
./argo-troubleshoot-lab20/git-repo/manifests/service.yaml
./argo-troubleshoot-lab20/lab-original-configmap.yaml
./argo-troubleshoot-lab20/lab-original-prometheus.yml
./argo-troubleshoot-lab20/lab-original-service.yaml
./argo-troubleshoot-lab20/prom/fixed.yml
./argo-troubleshoot-lab20/prom/lab.yml
./argo-troubleshoot-lab20/prometheus.yaml
./argo-troubleshoot-lab20/query-prometheus.sh
./argo-troubleshoot-lab20/results/SIMULATED.md
./argo-troubleshoot-lab20/results/bug-lab-keep-rule-vs-controller.txt
./argo-troubleshoot-lab20/results/bug-prometheus-lab-args.txt
./argo-troubleshoot-lab20/results/bug-rollouts-history-cmd.txt
./argo-troubleshoot-lab20/results/elapsed.txt
./argo-troubleshoot-lab20/results/image-pull.log
./argo-troubleshoot-lab20/results/install-argo.log
./argo-troubleshoot-lab20/results/install-argocd.log
./argo-troubleshoot-lab20/results/install-kubeconform.log
./argo-troubleshoot-lab20/results/install-rollouts.log
./argo-troubleshoot-lab20/results/logs/failing-workflow-57f1a2-step1-main.log
./argo-troubleshoot-lab20/results/logs/failing-workflow-57f1a2-step2-main.log
./argo-troubleshoot-lab20/results/task-kubeconform.txt
./argo-troubleshoot-lab20/results/task1.1-workflow-name.txt
./argo-troubleshoot-lab20/results/task1.2-cli-versions.txt
./argo-troubleshoot-lab20/results/task1.2-nodes.txt
./argo-troubleshoot-lab20/results/task1.3-argo-logs-help.txt
./argo-troubleshoot-lab20/results/task1.5-troubleshoot-output.txt
./argo-troubleshoot-lab20/results/task2-original-configmap-kubeconform.txt
./argo-troubleshoot-lab20/results/task2-original-embedded-config-parse.txt
./argo-troubleshoot-lab20/results/task2-original-service-targetport-8080.txt
./argo-troubleshoot-lab20/results/task2.4-original-image-pull.txt
./argo-troubleshoot-lab20/results/task2.5-fixed-service-port-80.txt
./argo-troubleshoot-lab20/results/task2.5-git-log.txt
./argo-troubleshoot-lab20/results/task3-promtool-fixed.txt
./argo-troubleshoot-lab20/results/task3-promtool-lab.txt
./argo-troubleshoot-lab20/results/task3-rollout-traffic.txt
./argo-troubleshoot-lab20/results/task3.3-canary-image-pull.txt
./argo-troubleshoot-lab20/results/task3.3-rollout-state.txt
./argo-troubleshoot-lab20/results/task3.4-prom-up.json
./argo-troubleshoot-lab20/results/task3.4-query-prometheus.txt
./argo-troubleshoot-lab20/results/task3.6-analysis-http-check.txt
./argo-troubleshoot-lab20/results/versions.txt
./argo-troubleshoot-lab20/rollout-demo.yaml
./argo-troubleshoot-lab20/troubleshoot-argocd.sh
./argo-troubleshoot-lab20/troubleshoot-rollout.sh
./argo-troubleshoot-lab20/troubleshoot-workflow.sh
```
