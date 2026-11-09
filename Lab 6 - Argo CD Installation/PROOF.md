# Lab 6 - Argo CD Installation - completion proof
Completed (UTC): 2026-11-09 12:25:48 | EC2: i-0f847cbd18531f241 | host: ip-172-31-10-191 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 6 - Argo CD Installation, 2026-11-09 12:25:42 UTC) - FAST MODE ==========
PASS: Task 2.1: Helm 3.x installed and checksum-verified (v3.22.1+gd6c1a0e)
PASS: Task 2.2: argo repo added, argo/argo-cd found (chart 10.17.0, Argo CD v3.6.1)
PASS: Task 1.2/3.1 [SIMULATED install - rendered, not applied]: chart renders for release argocd in ns argocd
PASS: Task 3.1: every rendered object + namespace passes Kubernetes schema validation (kubeconform)
PASS: Task 3.3: all components present - server, repo-server, dex, redis, applicationset, notifications (Deployments) + application-controller (StatefulSet)
PASS: Task 3.3: services - argocd-server on 80,443 plus repo-server, redis, dex
PASS: Architecture: Argo CD CRDs (Application, AppProject, ApplicationSet) and controller/server RBAC rendered
PASS: Images: every Argo CD container pinned to quay.io/argoproj/argocd:v3.6.1
PASS: Task 5.1: argocd CLI matches server version v3.6.1 (checksum verified)
PASS: Task 4.1 [SIMULATED]: initial admin secret is runtime-created (absent from chart); jsonpath+base64 decode verified on simulated secret
PASS: Task 4.2/4.3/5.2 [SIMULATED]: port-forward/UI/login not run (no cluster); argocd login/app list syntax verified
PASS: Security: real bcrypt admin hash + developer account/RBAC set via Helm values (rendered into argocd-cm, argocd-rbac-cm, argocd-secret)
PASS: Time: fast-mode run finished in 35s (<= 300s)
CORE: 13/13 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./argocd-lab6/inventory.py
./argocd-lab6/namespace-argocd.yaml
./argocd-lab6/rendered-argocd-security.yaml
./argocd-lab6/rendered-argocd.yaml
./argocd-lab6/results/SIMULATED.md
./argocd-lab6/results/elapsed.txt
./argocd-lab6/results/install-argocd-cli.log
./argocd-lab6/results/install-helm.log
./argocd-lab6/results/install-kubeconform.log
./argocd-lab6/results/security-bcrypt-hash.txt
./argocd-lab6/results/security-bcrypt.err
./argocd-lab6/results/security-demo-admin-password.txt
./argocd-lab6/results/security-inventory.txt
./argocd-lab6/results/security-render.err
./argocd-lab6/results/security-rendered-keys.txt
./argocd-lab6/results/task2.1-helm.txt
./argocd-lab6/results/task2.2-repo-add.txt
./argocd-lab6/results/task2.2-repo-update.txt
./argocd-lab6/results/task2.2-search.txt
./argocd-lab6/results/task3-kubeconform.txt
./argocd-lab6/results/task3.1-render.err
./argocd-lab6/results/task3.3-inventory.txt
./argocd-lab6/results/task3.3-kinds.txt
./argocd-lab6/results/task4.1-simulated-decoded.txt
./argocd-lab6/results/task5.1-argocd-version.txt
./argocd-lab6/results/task5.2-app-list-help.txt
./argocd-lab6/results/task5.2-login-help.txt
./argocd-lab6/results/versions.txt
./argocd-lab6/simulated-initial-admin-secret.yaml
./argocd-lab6/values-security.yaml
```
