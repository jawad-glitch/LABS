# GitOps Lab 16 - Troubleshooting GitOps Workflows - completion proof
Completed (UTC): 2026-11-10 09:26:06 | EC2: i-0e4b01c7cd3877488 | host: ip-172-31-10-30 | user: ubuntu

## Core checks
```
========== CORE CHECKS (GitOps Lab 16 - Troubleshooting GitOps Workflows, 2026-11-10 09:25:59 UTC) - CLUSTER/ARGO CD SIMULATED, GIT + PODS REAL ==========
PASS: Task 1/2: tools (sha256); repo with base + dev/staging overlays on main; branches development/staging
PASS: Lab default-branch check: default=master, lab 'git checkout main' rc=1 (fixed repo uses -b main)
PASS: Task 3: merge development OK; merge staging CONFLICT with markers; stages :1/:2/:3 = v1.0 / v1.1 / v1.2
PASS: Task 4.1: resolution commit (v1.3); builds valid; dev still nginx:1.20 x1 (patch overrides merge), staging nginx:1.21 x3
PASS: Task 4.2/4.3: remote pushed BEFORE the Application; Application generated with reachable http repoURL
PASS: Task 4.4 [real pod]: dev-webapp 1 pod nginx:1.20 with ENVIRONMENT=development + merged LOG_LEVEL/CACHE_ENABLED env
PASS: Task 5.3: manual scale to 5 -> selfHeal back to 1
PASS: Lab bug: 'cat >>' broken kustomization -> ComparisonError, nothing applied (dev-webapp untouched)
PASS: Fixed placement: invalid-app Pending (requests > real node capacity); then ImagePullBackOff -> Degraded
FAIL: Task 5.6: fix commit -> invalid-app pruned, Synced/Healthy, dev-webapp 1 running
PASS: Task 7: health check OK on final state, ATTENTION on broken state; corrected playbook (statefulset logs)
PASS: Time: finished in 28s (<= 300s)
CORE: 11/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE        ID             DISK USAGE   CONTENT SIZE   EXTRA
nginx:1.20   38f8c1d9613f        213MB         56.7MB        
```

## Files
```
./gitops-lab16/applications/webapp/deployment.yaml
./gitops-lab16/applications/webapp/kustomization.yaml
./gitops-lab16/applications/webapp/service.yaml
./gitops-lab16/argocd-application.yaml
./gitops-lab16/environments/dev/deployment-patch.yaml
./gitops-lab16/environments/dev/kustomization.yaml
./gitops-lab16/environments/staging/deployment-patch.yaml
./gitops-lab16/environments/staging/kustomization.yaml
./gitops-lab16/gitops-health-check.sh
./gitops-lab16/gitops-lessons-learned.md
./gitops-lab16/gitops-troubleshooting-playbook.md
./gitops-lab16/gitsrv.py
./gitops-lab16/reconcile.py
./gitops-lab16/results/SIMULATED.md
./gitops-lab16/results/argocd-events.log
./gitops-lab16/results/bug-checkout-main.txt
./gitops-lab16/results/bug-lab-append-build.txt
./gitops-lab16/results/elapsed.txt
./gitops-lab16/results/final-git-log.txt
./gitops-lab16/results/image-pull.txt
./gitops-lab16/results/s1-initial.json
./gitops-lab16/results/s2-selfheal.json
./gitops-lab16/results/s3-lab-broken.json
./gitops-lab16/results/s4-fixed-placement.json
./gitops-lab16/results/s5-imagepull.json
./gitops-lab16/results/s6-fixed.json
./gitops-lab16/results/task1.1-versions.txt
./gitops-lab16/results/task2.4-tree.txt
./gitops-lab16/results/task3.2-merge-development.txt
./gitops-lab16/results/task3.2-merge-staging.txt
./gitops-lab16/results/task3.3-conflict.txt
./gitops-lab16/results/task4.1-graph.txt
./gitops-lab16/results/task4.1-kubeconform.txt
./gitops-lab16/results/task4.1-rendered.txt
./gitops-lab16/results/task4.2-generate.err
./gitops-lab16/results/task4.3-remote.txt
./gitops-lab16/results/task4.4-dev-pod.txt
./gitops-lab16/results/task5.3-drift.txt
./gitops-lab16/results/task7.1-health-broken.txt
./gitops-lab16/results/task7.1-health-final.txt
./gitops-lab16/results/tools.txt
```
