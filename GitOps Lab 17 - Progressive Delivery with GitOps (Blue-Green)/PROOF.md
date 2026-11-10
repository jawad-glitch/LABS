# GitOps Lab 17 - Progressive Delivery with GitOps (Blue-Green) - completion proof
Completed (UTC): 2026-11-10 09:30:03 | EC2: i-051a1fd998b17dec0 | host: ip-172-31-10-206 | user: ubuntu

## Core checks
```
========== CORE CHECKS (GitOps Lab 17 - Progressive Delivery with GitOps (Blue-Green), 2026-11-10 09:29:55 UTC) - CLUSTER/ARGO CD SIMULATED, PODS + TRAFFIC + GIT REAL ==========
PASS: Task 1: argocd v3.6.1, kubectl, kubeconform, yq v4.54.3 (sha256); lab docker.list uses 'jammy' on noble
FAIL: Task 2.1: exact layout (base 4 files, 2 overlays x 3 files, argocd-apps/*); blue-env/green-env builds with environment label; schema-valid
PASS: Task 2.1: 3 Applications (envs automated+prune+CreateNamespace; traffic-router +selfHeal) CRD-valid; pushed to remote
PASS: Task 2.1 acceptance [real pods]: 3 blue pods serve Environment: Blue v1.0; 3 green pods serve Environment: Green v2.0
PASS: Task 2.2: switch blue -> production serves Blue; switch green -> Green (through the production entry point, not pod IPs)
PASS: Task 2.2: invalid-arg exits 1 with usage; each switch is a Git commit (traffic-router stays Synced)
PASS: Task 3.1: validate-health blue PASSED (0); green at 0 replicas FAILED (1); restored PASSED (0)
PASS: Task 3.2: bad release live - green body is exactly BROKEN (also via production)
PASS: Task 3.2: git revert -> green Synced/Healthy serving v2.0 (bad commit kept in history, no kubectl patch)
PASS: Time: finished in 44s (<= 300s)
CORE: 9/10 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE               ID             DISK USAGE   CONTENT SIZE   EXTRA
nginx:1.27-alpine   65645c7bb6a0       74.5MB         21.9MB        
```

## Files
```
./gitops-lab17/apps/sample-app/base/configmap.yaml
./gitops-lab17/apps/sample-app/base/deployment.yaml
./gitops-lab17/apps/sample-app/base/kustomization.yaml
./gitops-lab17/apps/sample-app/base/service.yaml
./gitops-lab17/apps/sample-app/overlays/blue/configmap-patch.yaml
./gitops-lab17/apps/sample-app/overlays/blue/deployment-patch.yaml
./gitops-lab17/apps/sample-app/overlays/blue/kustomization.yaml
./gitops-lab17/apps/sample-app/overlays/green/configmap-patch.yaml
./gitops-lab17/apps/sample-app/overlays/green/deployment-patch.yaml
./gitops-lab17/apps/sample-app/overlays/green/kustomization.yaml
./gitops-lab17/argocd-apps/blue-app.yaml
./gitops-lab17/argocd-apps/green-app.yaml
./gitops-lab17/argocd-apps/traffic-router-app.yaml
./gitops-lab17/gitsrv.py
./gitops-lab17/html/blue-env-sample-app-html.html
./gitops-lab17/html/green-env-sample-app-html.html
./gitops-lab17/html/production-nginx.conf
./gitops-lab17/reconcile.py
./gitops-lab17/results/SIMULATED.md
./gitops-lab17/results/argocd-events.log
./gitops-lab17/results/bug-docker-apt-suite.txt
./gitops-lab17/results/elapsed.txt
./gitops-lab17/results/final-git-log.txt
./gitops-lab17/results/image-pull.txt
./gitops-lab17/results/no-kubectl-patch.txt
./gitops-lab17/results/s-blue-1.json
./gitops-lab17/results/s-green-1.json
./gitops-lab17/results/s-green-broken.json
./gitops-lab17/results/s-green-restored.json
./gitops-lab17/results/s-green-reverted.json
./gitops-lab17/results/s-router-1.json
./gitops-lab17/results/s-router-switch.json
./gitops-lab17/results/task2.1-acceptance.txt
./gitops-lab17/results/task2.1-apps-kubeconform.txt
./gitops-lab17/results/task2.1-kubeconform.txt
./gitops-lab17/results/task2.1-layout.txt
./gitops-lab17/results/task2.1-remote.txt
./gitops-lab17/results/task2.1-rendered.txt
./gitops-lab17/results/task2.2-switch.txt
./gitops-lab17/results/task3.1-health.txt
./gitops-lab17/results/task3.2-broken.txt
./gitops-lab17/results/task3.2-reverted.txt
./gitops-lab17/results/tools.txt
./gitops-lab17/switch-traffic.sh
./gitops-lab17/traffic-router/production-service.yaml
./gitops-lab17/validate-health.sh
```
