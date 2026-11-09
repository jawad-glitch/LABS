# Lab 10 - Implement Blue-Green Deployment with Argo Rollouts - completion proof
Completed (UTC): 2026-11-09 12:40:11 | EC2: i-03ab5809b764d945a | host: ip-172-31-10-185 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 10 - Implement Blue-Green Deployment with Argo Rollouts, 2026-11-09 12:40:05 UTC) - FAST MODE ==========
PASS: Lab bug 1: original rollout.yaml rejected - duplicate key autoPromotionEnabled; all fixed manifests parse strictly
PASS: Task 2: all manifests valid vs Kubernetes + Rollout/AnalysisTemplate/Application CRD schemas (strict)
PASS: Lab bug 2: lab merge patch wipes container image+volumeMounts; JSON patch keeps them and sets nginx:1.27-alpine/app-html-v2/v2.0 in one revision
FAIL: Task 1.2: kubectl-argo-rollouts v1.10.2 installed; promote/undo/status/history commands present
PASS: Task 3.3 [SIMULATED cluster, real traffic]: active service serves v1.0
PASS: Task 4.3/4.4: blue-green - preview serves v2.0 while active still serves v1.0
PASS: Task 2.4: AnalysisTemplate job script (10 HTTP checks vs preview) passed before each promotion
PASS: Task 4.5/4.6: after promote active serves v2.0 and old ReplicaSet scaled down
PASS: Task 6 (lab fix): undo puts v1.0 in preview but active stays v2.0 until promote
PASS: Task 6.2: after promote, rollback complete - active serves v1.0
PASS: Task 7: auto-promotion - v3.0 promoted after analysis without manual promote
PASS: Time: fast-mode run finished in 64s (<= 300s)
CORE: 11/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                    ID             DISK USAGE   CONTENT SIZE   EXTRA
curlimages/curl:7.85.0   9fab1b73f45e       24.9MB         8.57MB        
nginx:1.26-alpine        1eadbb078203         73MB         21.5MB        
nginx:1.27-alpine        65645c7bb6a0       74.5MB         21.9MB        
```

## Files
```
./bluegreen-lab10/analysis-template.yaml
./bluegreen-lab10/app-deployment.yaml
./bluegreen-lab10/app-html-v2-configmap.yaml
./bluegreen-lab10/app-html-v3-configmap.yaml
./bluegreen-lab10/argocd-application.yaml
./bluegreen-lab10/lab-original-merge-patch-v2.json
./bluegreen-lab10/lab-original-rollout-duplicate-key.yaml
./bluegreen-lab10/namespace.yaml
./bluegreen-lab10/patch-v2.json
./bluegreen-lab10/patch-v3.json
./bluegreen-lab10/patchsim.py
./bluegreen-lab10/results/SIMULATED.md
./bluegreen-lab10/results/analysis-undo.txt
./bluegreen-lab10/results/analysis-v2.txt
./bluegreen-lab10/results/analysis-v3.txt
./bluegreen-lab10/results/bug1-duplicate-key-fixed.txt
./bluegreen-lab10/results/bug1-duplicate-key-original.txt
./bluegreen-lab10/results/bug2-merge-vs-jsonpatch.txt
./bluegreen-lab10/results/elapsed.txt
./bluegreen-lab10/results/final-replicasets.txt
./bluegreen-lab10/results/image-pull.log
./bluegreen-lab10/results/install-kubeconform.log
./bluegreen-lab10/results/install-rollouts-cli.log
./bluegreen-lab10/results/simulation-timeline.txt
./bluegreen-lab10/results/task1.2-cli-version.txt
./bluegreen-lab10/results/task2-kubeconform.txt
./bluegreen-lab10/results/task4-cli-commands-help.txt
./bluegreen-lab10/results/traffic.txt
./bluegreen-lab10/results/versions.txt
./bluegreen-lab10/rollout-auto-promote.yaml
./bluegreen-lab10/rollout.yaml
./bluegreen-lab10/sim/analysis-run.sh
./bluegreen-lab10/sim/analysis-script.sh
./bluegreen-lab10/sim/app-html-v1/index.html
./bluegreen-lab10/sim/app-html-v2/index.html
./bluegreen-lab10/sim/app-html-v3/index.html
./bluegreen-lab10/strictyaml.py
```
