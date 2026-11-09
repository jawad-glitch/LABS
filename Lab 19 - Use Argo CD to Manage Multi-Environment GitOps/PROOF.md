# Lab 19 - Use Argo CD to Manage Multi-Environment GitOps - completion proof
Completed (UTC): 2026-11-09 13:37:57 | EC2: i-0bb9494842a7afea2 | host: ip-172-31-10-30 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 19 - Use Argo CD to Manage Multi-Environment GitOps, 2026-11-09 13:37:51 UTC) - FAST MODE ==========
PASS: Task 2/3 [SIMULATED apply]: 9 env manifests + 3 Applications + ApplicationSet valid (strict); scripts parse
PASS: Lab bug: file:// repo unreachable from a container (repo-server analog); network git URL reachable
PASS: Task 2.3: 4 repos with commits; env repos pushed to network remotes
PASS: Task 3: dev auto-synced on create; staging/prod OutOfSync until manual sync, then Synced Healthy 2/2 and 3/3
PASS: Task 4.3: dev commit (1->2 replicas) auto-synced with no manual step - 2 live containers
PASS: Lab bug: lab sed adds version under both labels: blocks and breaks YAML; fixed edit touches metadata.labels only
PASS: Task 4.4: prod (manual policy) OutOfSync after commit, Synced with version-label=1.0.1 only after manual sync
PASS: Task 4.5: killed staging container - not repaired with selfHeal off, repaired by self-heal on
FAIL: Task 5.3: nginx:invalid-tag auto-synced -> Degraded (real pull failure); git revert -> auto-sync -> Healthy
PASS: Task 6.1: promote-changes.sh moved nginx:1.27-alpine dev -> staging (commit+push), staging auto-synced; prod untouched
PASS: Lab bug: original ApplicationSet renders selfHeal as a literal string (invalid Applications); fixed goTemplate+templatePatch renders 3 valid apps, selfHeal true only for dev
PASS: Final: all 3 environments Synced + Healthy (dev 2, staging 2, prod 3 replicas)
PASS: Time: fast-mode run finished in 45s (<= 300s)
CORE: 12/13 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE               ID             DISK USAGE   CONTENT SIZE   EXTRA
alpine/git:latest   6a1fdb962814        144MB         38.9MB        
nginx:1.26-alpine   1eadbb078203         73MB         21.5MB        
nginx:1.27-alpine   65645c7bb6a0       74.5MB         21.9MB        
```

## Files
```
./gitops-lab/applicationset.yaml
./gitops-lab/argocd-apps/app-dev.yaml
./gitops-lab/argocd-apps/app-prod.yaml
./gitops-lab/argocd-apps/app-staging.yaml
./gitops-lab/health-check.sh
./gitops-lab/lab-original-applicationset.yaml
./gitops-lab/lab-original-prod-sed-result.yaml
./gitops-lab/promote-changes.sh
./gitops-lab/reconcile.py
./gitops-lab/render_appset.py
./gitops-lab/results/SIMULATED.md
./gitops-lab/results/appset-fixed-kubeconform.txt
./gitops-lab/results/appset-fixed-rendered.yaml
./gitops-lab/results/appset-fixed-selfheal.txt
./gitops-lab/results/appset-original-rendered.yaml
./gitops-lab/results/argocd-sim-tagged.log
./gitops-lab/results/argocd-sim.log
./gitops-lab/results/argocd-sim.log.tags
./gitops-lab/results/bug-appset-original-kubeconform.txt
./gitops-lab/results/bug-file-url-from-container.txt
./gitops-lab/results/bug-prod-sed-yaml.txt
./gitops-lab/results/elapsed.txt
./gitops-lab/results/final-git-logs.txt
./gitops-lab/results/final-live-containers.txt
./gitops-lab/results/image-pull.log
./gitops-lab/results/install-kubeconform.log
./gitops-lab/results/network-url-from-container.txt
./gitops-lab/results/task-kubeconform.txt
./gitops-lab/results/task2.3-repos.txt
./gitops-lab/results/task6.1-promote.txt
./gitops-lab/results/versions.txt
./gitops-lab/sample-app-dev/manifests/deployment.yaml
./gitops-lab/sample-app-dev/manifests/namespace.yaml
./gitops-lab/sample-app-dev/manifests/service.yaml
./gitops-lab/sample-app-prod/manifests/deployment.yaml
./gitops-lab/sample-app-prod/manifests/namespace.yaml
./gitops-lab/sample-app-prod/manifests/service.yaml
./gitops-lab/sample-app-source/Dockerfile
./gitops-lab/sample-app-source/src/index.html
./gitops-lab/sample-app-staging/manifests/deployment.yaml
./gitops-lab/sample-app-staging/manifests/namespace.yaml
./gitops-lab/sample-app-staging/manifests/service.yaml
```
