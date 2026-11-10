# GitOps Lab 20 - Disaster Recovery with GitOps - completion proof
Completed (UTC): 2026-11-10 09:53:48 | EC2: i-02ce78bbba266c1ed | host: ip-172-31-10-110 | user: ubuntu

## Core checks
```
========== CORE CHECKS (GitOps Lab 20 - Disaster Recovery with GitOps, 2026-11-10 09:53:40 UTC) - K3S/ARGO CD SIMULATED, RECOVERY + PODS + GIT REAL ==========
PASS: Task 1: argocd v3.6.1 (sha256), kubectl, git, curl, jq report versions
PASS: Task 2.1: manifests valid (ns sample-app, 3 replicas, ClusterIP, ConfigMap); tag v1.0-baseline before Application; Application automated+selfHeal+CreateNamespace
PASS: Task 2.1: controller synced from Git (no manual apply): Synced/Healthy, 3 pods, custom page, tracking label sample-web-app
PASS: Scenario A: Deployment deleted -> autonomously restored to 3 Ready in 4.2s (< 120s)
PASS: Scenario B: namespace deleted -> recreated (CreateNamespace) + 3 Running in 4.1s (< 180s)
PASS: ~/recovery-times.txt has both lines in the required format
PASS: Task 3.1: v2.0-broken tagged; new pod ErrImagePull -> Degraded; 3 old pods still Running and serving v1.0 (lab grep -c Running stays 3)
PASS: Task 3.1: history baseline -> broken -> rollback (revert is HEAD); cluster back to nginx:1.27-alpine Synced/Healthy x3
PASS: Task 3.2: dr-validate.sh clean run - 5 PASS, exit 0
PASS: Task 3.2: dr-validate.sh on degraded state - FAIL check 2 and check 5, exit 1; recovers to exit 0 after controller resumes
PASS: Time: finished in 44s (<= 300s)
CORE: 11/11 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE               ID             DISK USAGE   CONTENT SIZE   EXTRA
nginx:1.27-alpine   65645c7bb6a0       74.5MB         21.9MB        
```

## Files
```
./gitops-lab20/apps/sample-web-app/configmap.yaml
./gitops-lab20/apps/sample-web-app/deployment.yaml
./gitops-lab20/apps/sample-web-app/namespace.yaml
./gitops-lab20/apps/sample-web-app/service.yaml
./gitops-lab20/argocd-sim-controller.py
./gitops-lab20/argocd/application.yaml
./gitops-lab20/dr-validate.sh
./gitops-lab20/gitsrv.py
./gitops-lab20/html/web-app-html.html
./gitops-lab20/results/SIMULATED.md
./gitops-lab20/results/argocd-events.log
./gitops-lab20/results/controller-state.json
./gitops-lab20/results/elapsed.txt
./gitops-lab20/results/image-pull.txt
./gitops-lab20/results/recovery-times.txt
./gitops-lab20/results/task1-versions.txt
./gitops-lab20/results/task2.1-app-kubeconform.txt
./gitops-lab20/results/task2.1-generate.err
./gitops-lab20/results/task2.1-initial-state.json
./gitops-lab20/results/task2.1-initial.txt
./gitops-lab20/results/task2.1-kubeconform.txt
./gitops-lab20/results/task2.2-scenario-a.txt
./gitops-lab20/results/task2.2-scenario-b.txt
./gitops-lab20/results/task3.1-broken.txt
./gitops-lab20/results/task3.1-git-log.txt
./gitops-lab20/results/task3.1-rollback.txt
./gitops-lab20/results/task3.2-validate-clean.txt
./gitops-lab20/results/task3.2-validate-degraded.txt
./gitops-lab20/results/task3.2-validate-recovered.txt
./gitops-lab20/results/tools.txt
```
