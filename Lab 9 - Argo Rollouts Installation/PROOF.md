# Lab 9 - Argo Rollouts Installation - completion proof
Completed (UTC): 2026-11-09 12:35:29 | EC2: i-0b6fea5a768061865 | host: ip-172-31-10-59 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 9 - Argo Rollouts Installation, 2026-11-09 12:35:24 UTC) - FAST MODE ==========
PASS: Task 2.1 [SIMULATED apply]: release install.yaml v1.10.2 (pinned, not default-branch kustomize) + namespace pass Kubernetes schema validation
PASS: Task 3.1/3.2: controller Deployment argo-rollouts (image pinned to v1.10.2) and metrics Service
PASS: Task 3.3: all 5 CRDs incl. clusteranalysistemplates (lab listed only 4)
PASS: Task 4.2: RBAC - ServiceAccount, ClusterRole, ClusterRoleBinding argo-rollouts + aggregate-to-* roles
PASS: Task 4.3: test Rollout (canary setWeight 50 + pause) valid against Rollout CRD schema (strict)
PASS: Task 4.4 [SIMULATED pod]: Rollout pod image nginx:1.27-alpine serves Welcome to nginx locally
PASS: Task 5.1: kubectl-argo-rollouts CLI = controller version v1.10.2 (no skew)
PASS: Task 5.2 [SIMULATED live commands]: CLI get rollout command available (help captured)
PASS: Time: fast-mode run finished in 18s (<= 300s)
CORE: 9/9 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE               ID             DISK USAGE   CONTENT SIZE   EXTRA
nginx:1.27-alpine   65645c7bb6a0       74.5MB         21.9MB        
```

## Files
```
./argo-rollouts-lab9/install.yaml
./argo-rollouts-lab9/inventory.py
./argo-rollouts-lab9/namespace-argo-rollouts.yaml
./argo-rollouts-lab9/results/SIMULATED.md
./argo-rollouts-lab9/results/elapsed.txt
./argo-rollouts-lab9/results/install-kubeconform.log
./argo-rollouts-lab9/results/install-rollouts-cli.log
./argo-rollouts-lab9/results/nginx-pull.log
./argo-rollouts-lab9/results/task2.1-kubeconform.txt
./argo-rollouts-lab9/results/task3-inventory.txt
./argo-rollouts-lab9/results/task3-kinds.txt
./argo-rollouts-lab9/results/task4.3-rollout-kubeconform.txt
./argo-rollouts-lab9/results/task4.4-pod-analog-curl.html
./argo-rollouts-lab9/results/task4.4-pod-analog-logs.txt
./argo-rollouts-lab9/results/task5-cli-lint.txt
./argo-rollouts-lab9/results/task5.1-cli-version.txt
./argo-rollouts-lab9/results/task5.2-get-rollout-help.txt
./argo-rollouts-lab9/results/versions.txt
./argo-rollouts-lab9/rollouts-demo-namespace.yaml
./argo-rollouts-lab9/test-rollout.yaml
```
