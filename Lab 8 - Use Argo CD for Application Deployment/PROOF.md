# Lab 8 - Use Argo CD for Application Deployment - completion proof
Completed (UTC): 2026-11-09 12:32:32 | EC2: i-05dc6c43f6921b1b0 | host: ip-172-31-10-94 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 8 - Use Argo CD for Application Deployment, 2026-11-09 12:32:27 UTC) - FAST MODE ==========
PASS: Task 1.2 [SIMULATED apply]: Argo CD v3.6.1 install.yaml (pinned tag) passes Kubernetes schema validation
PASS: Task 1.2 bug: largest CRD is 387270 bytes > 262144 annotation limit -> client-side apply fails, server-side apply required
PASS: Task 1.2: all components in manifest - server, repo-server, dex, redis, applicationset, notifications + application-controller StatefulSet
PASS: Task 1.4: sample-app repo on main with v1 commit; deployment + service valid against K8s schemas
PASS: Lab bug evidence: file:// repo NOT reachable from a container (pod analog), network git URL IS reachable
PASS: Task 1.5: Application valid against Argo CD CRD schema; https repoURL, finalizer, automated prune+selfHeal
PASS: Task 2.1 [SIMULATED login]: argocd CLI = manifest version v3.6.1 (no skew), checksum verified
PASS: Task 2.4: replica change committed AND pushed (lab omitted push) - remote main has replicas: 3
PASS: Task 3.1/3.5 [SIMULATED pods]: nginx:1.27-alpine (deployment image) serves Welcome to nginx page
PASS: Task 3.2 [SIMULATED service]: busybox reaches sample-app-service by name on shared network and gets nginx page
PASS: Time: fast-mode run finished in 24s (<= 300s)
CORE: 11/11 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE               ID             DISK USAGE   CONTENT SIZE   EXTRA
alpine/git:latest   6a1fdb962814        144MB         38.9MB        
busybox:1.36        73aaf090f3d8       6.76MB         2.21MB        
nginx:1.27-alpine   65645c7bb6a0       74.5MB         21.9MB        
```

## Files
```
./argocd-lab8/analyze.py
./argocd-lab8/argocd-application.yaml
./argocd-lab8/install.yaml
./argocd-lab8/remote/sample-app.git/HEAD
./argocd-lab8/remote/sample-app.git/config
./argocd-lab8/remote/sample-app.git/description
./argocd-lab8/remote/sample-app.git/hooks/applypatch-msg.sample
./argocd-lab8/remote/sample-app.git/hooks/commit-msg.sample
./argocd-lab8/remote/sample-app.git/hooks/fsmonitor-watchman.sample
./argocd-lab8/remote/sample-app.git/hooks/post-update.sample
./argocd-lab8/remote/sample-app.git/hooks/pre-applypatch.sample
./argocd-lab8/remote/sample-app.git/hooks/pre-commit.sample
./argocd-lab8/remote/sample-app.git/hooks/pre-merge-commit.sample
./argocd-lab8/remote/sample-app.git/hooks/pre-push.sample
./argocd-lab8/remote/sample-app.git/hooks/pre-rebase.sample
./argocd-lab8/remote/sample-app.git/hooks/pre-receive.sample
./argocd-lab8/remote/sample-app.git/hooks/prepare-commit-msg.sample
./argocd-lab8/remote/sample-app.git/hooks/push-to-checkout.sample
./argocd-lab8/remote/sample-app.git/hooks/sendemail-validate.sample
./argocd-lab8/remote/sample-app.git/hooks/update.sample
./argocd-lab8/remote/sample-app.git/info/exclude
./argocd-lab8/remote/sample-app.git/objects/35/0297062ad99c64452b98151452eed2ce8e3e1e
./argocd-lab8/remote/sample-app.git/objects/4f/f60f1915996e5047cd8e43f759c2891fbb754b
./argocd-lab8/remote/sample-app.git/objects/56/d852083d38b4c641f981df02b91d2c9d9856ab
./argocd-lab8/remote/sample-app.git/objects/67/aadbd636c2e8f78dc65a2b51f7deb5833ce20d
./argocd-lab8/remote/sample-app.git/objects/90/edc02b2d2be83aae194719caab73f46e094307
./argocd-lab8/remote/sample-app.git/objects/b6/3f6d658ab57c7df729f89d4513f47da8b0e176
./argocd-lab8/remote/sample-app.git/objects/e4/94945a5d77f1c1289b1e89294ed298c98be2a8
./argocd-lab8/remote/sample-app.git/packed-refs
./argocd-lab8/remote/sample-app.git/refs/heads/main
./argocd-lab8/results/SIMULATED.md
./argocd-lab8/results/bug-file-url-from-container.txt
./argocd-lab8/results/elapsed.txt
./argocd-lab8/results/image-pull.log
./argocd-lab8/results/install-argocd-cli.log
./argocd-lab8/results/install-jq.log
./argocd-lab8/results/install-kubeconform.log
./argocd-lab8/results/network-url-from-container.txt
./argocd-lab8/results/push.err
./argocd-lab8/results/task1.2-crd-sizes.txt
./argocd-lab8/results/task1.2-inventory.txt
./argocd-lab8/results/task1.2-kubeconform.txt
./argocd-lab8/results/task1.4-kubeconform.txt
./argocd-lab8/results/task1.5-application-kubeconform.txt
./argocd-lab8/results/task2.1-argocd-version.txt
./argocd-lab8/results/task2.3-app-wait-help.txt
./argocd-lab8/results/task2.4-diff.txt
./argocd-lab8/results/task2.4-git-log.txt
./argocd-lab8/results/task2.4-remote-head.txt
./argocd-lab8/results/task3.1-nginx-logs.txt
./argocd-lab8/results/task3.2-busybox-wget.html
./argocd-lab8/results/task3.4-syncpolicy.json
./argocd-lab8/results/task3.5-curl.html
./argocd-lab8/results/versions.txt
./sample-app/deployment.yaml
./sample-app/service.yaml
```
