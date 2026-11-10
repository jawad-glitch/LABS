# GitOps Lab 18 - Progressive Delivery with GitOps (Canary) - completion proof
Completed (UTC): 2026-11-10 09:37:56 | EC2: i-0636de89a965f9611 | host: ip-172-31-10-252 | user: ubuntu

## Core checks
```
========== CORE CHECKS (GitOps Lab 18 - Progressive Delivery with GitOps (Canary), 2026-11-10 09:37:50 UTC) - CLUSTER/CONTROLLERS SIMULATED, PODS + INGRESS + ANALYSIS REAL ==========
PASS: Task 1: argocd v3.6.1 (sha256) + kubectl-argo-rollouts v1.10.2 report versions; 4 demo-app images built
PASS: Task 2.1: Rollout (canary 20/40/60/80, canary+stable svc, nginx stableIngress) + Application (automated/prune/selfHeal) CRD-valid
PASS: Task 2.1: initial sync - Healthy, 5 pods demo-app:v1.0
PASS: Task 2.2: Git commit v2.0 -> Paused at 20% (1 canary pod v2.0, 5 stable v1.0)
PASS: Task 2.2: at 20% direct canary svc = v2.0, stable svc = v1.0; X-Canary header 50/50 -> v2.0; no header mostly v1.0
PASS: Task 2.2: 4 promotes -> Healthy, every pod demo-app:v2.0, zero on previous revision
PASS: Lab bug: 'kubectl argo rollouts history' is not a command (real plugin)
PASS: Task 3.1: web AnalysisTemplate valid; v3.0 analysis Successful (3 x status ok) -> auto-advanced to 40% pause; then promoted
PASS: Task 3.2: v4.0 analysis Failed (status degraded, failureLimit 1) -> auto-aborted Degraded, 100% traffic on v3.0
FAIL: Lab bug: abort+undo is reverted by Argo CD selfHeal (Git still v4.0) - canary v4.0 restarts and fails again
PASS: GitOps rollback (git revert): Healthy, all 5 pods demo-app:v3.0, zero v4.0 pods, 100% traffic v3.0
PASS: Time: finished in 110s (<= 300s)
CORE: 11/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE               ID             DISK USAGE   CONTENT SIZE   EXTRA
demo-app:v1.0       02ba6ebcd7ac       73.6MB           21MB        
demo-app:v2.0       f0d3bde84fd4       73.6MB           21MB        
demo-app:v3.0       23e6d9adbd0e       73.6MB           21MB        
demo-app:v4.0       3a54ec7cd550       73.6MB           21MB        
nginx:1.27-alpine   65645c7bb6a0       74.5MB         21.9MB        
```

## Files
```
./gitops-lab18/Dockerfile.demo-app
./gitops-lab18/apps/demo-app/base/ingress.yaml
./gitops-lab18/apps/demo-app/base/kustomization.yaml
./gitops-lab18/apps/demo-app/base/rollout.yaml
./gitops-lab18/apps/demo-app/base/service-canary.yaml
./gitops-lab18/apps/demo-app/base/service-stable.yaml
./gitops-lab18/apps/demo-app/overlays/production/analysis-template.yaml
./gitops-lab18/apps/demo-app/overlays/production/image-patch.yaml
./gitops-lab18/apps/demo-app/overlays/production/kustomization.yaml
./gitops-lab18/apps/demo-app/overlays/production/steps-patch.yaml
./gitops-lab18/argocd/application.yaml
./gitops-lab18/gitsrv.py
./gitops-lab18/img/Dockerfile
./gitops-lab18/ingress/default.conf
./gitops-lab18/results/SIMULATED.md
./gitops-lab18/results/bug-docker-apt-suite.txt
./gitops-lab18/results/bug-rollouts-history.txt
./gitops-lab18/results/bug-undo-vs-selfheal.txt
./gitops-lab18/results/elapsed.txt
./gitops-lab18/results/final-git-log.txt
./gitops-lab18/results/ro-output.log
./gitops-lab18/results/rollout-events.log
./gitops-lab18/results/rollout-state.json
./gitops-lab18/results/task1-images.txt
./gitops-lab18/results/task1-versions.txt
./gitops-lab18/results/task2.1-generate.err
./gitops-lab18/results/task2.1-kubeconform.txt
./gitops-lab18/results/task2.1-status.txt
./gitops-lab18/results/task2.2-paused.txt
./gitops-lab18/results/task2.2-pod-images.txt
./gitops-lab18/results/task2.2-promote.txt
./gitops-lab18/results/task2.2-traffic-at-20.txt
./gitops-lab18/results/task3.1-kubeconform.txt
./gitops-lab18/results/task3.1-v3-status.txt
./gitops-lab18/results/task3.2-final-pod-images.txt
./gitops-lab18/results/task3.2-revert-status.txt
./gitops-lab18/results/task3.2-v4-status.txt
./gitops-lab18/results/tools.txt
./gitops-lab18/ro.py
```
