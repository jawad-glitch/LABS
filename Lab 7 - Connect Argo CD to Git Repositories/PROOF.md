# Lab 7 - Connect Argo CD to Git Repositories - completion proof
Completed (UTC): 2026-11-09 12:29:03 | EC2: i-01563327c55d47f6c | host: ip-172-31-10-145 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 7 - Connect Argo CD to Git Repositories, 2026-11-09 12:28:58 UTC) - FAST MODE, git=local ==========
PASS: Task 1.1 [SIMULATED: token cannot create/push GitHub repo]: local bare Git remote created with README
PASS: Task 1.3: namespace/deployment/service/configmap valid against Kubernetes schemas (strict)
PASS: Task 1.3 fix: Deployment mounts ConfigMap nginx-config at /usr/share/nginx/html
PASS: Task 1.4: v1 commit 1ed9ddc pushed to remote main with all 4 manifests
PASS: Task 2 [SIMULATED login/repo add]: argocd CLI v3.6.1 installed; repo add supports --type/--name; repo get --refresh documented
FAIL: Task 3.1: real argocd CLI generated the CLI app spec - automated prune+selfHeal
FAIL: Task 3.2: YAML Application (and CLI spec) valid against Argo CD Application CRD schema
FAIL: Lab bug evidence: CLI app and YAML app target identical repo/path/destination (shared-resource conflict)
PASS: Task 3.3/3.4 [SIMULATED sync]: desired state = Namespace + Deployment + Service + ConfigMap in demo-app
PASS: Task 3.5: GitOps change pushed - remote HEAD has replicas: 3 and Version: 1.1; diff shows both
PASS: Verification: nginx:1.27-alpine served v1 page (Version: 1.0) then v2 page (Version: 1.1) from the ConfigMap content
PASS: Time: fast-mode run finished in 12s (<= 300s)
CORE: 9/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE               ID             DISK USAGE   CONTENT SIZE   EXTRA
nginx:1.27-alpine   65645c7bb6a0       74.5MB         21.9MB        
```

## Files
```
./argocd-lab7/argocd-application.yaml
./argocd-lab7/argocd-demo-app/README.md
./argocd-lab7/argocd-demo-app/k8s-manifests/configmap.yaml
./argocd-lab7/argocd-demo-app/k8s-manifests/deployment.yaml
./argocd-lab7/argocd-demo-app/k8s-manifests/namespace.yaml
./argocd-lab7/argocd-demo-app/k8s-manifests/service.yaml
./argocd-lab7/cli-app-spec.yaml
./argocd-lab7/remote/argocd-demo-app.git/HEAD
./argocd-lab7/remote/argocd-demo-app.git/config
./argocd-lab7/remote/argocd-demo-app.git/description
./argocd-lab7/remote/argocd-demo-app.git/hooks/applypatch-msg.sample
./argocd-lab7/remote/argocd-demo-app.git/hooks/commit-msg.sample
./argocd-lab7/remote/argocd-demo-app.git/hooks/fsmonitor-watchman.sample
./argocd-lab7/remote/argocd-demo-app.git/hooks/post-update.sample
./argocd-lab7/remote/argocd-demo-app.git/hooks/pre-applypatch.sample
./argocd-lab7/remote/argocd-demo-app.git/hooks/pre-commit.sample
./argocd-lab7/remote/argocd-demo-app.git/hooks/pre-merge-commit.sample
./argocd-lab7/remote/argocd-demo-app.git/hooks/pre-push.sample
./argocd-lab7/remote/argocd-demo-app.git/hooks/pre-rebase.sample
./argocd-lab7/remote/argocd-demo-app.git/hooks/pre-receive.sample
./argocd-lab7/remote/argocd-demo-app.git/hooks/prepare-commit-msg.sample
./argocd-lab7/remote/argocd-demo-app.git/hooks/push-to-checkout.sample
./argocd-lab7/remote/argocd-demo-app.git/hooks/sendemail-validate.sample
./argocd-lab7/remote/argocd-demo-app.git/hooks/update.sample
./argocd-lab7/remote/argocd-demo-app.git/info/exclude
./argocd-lab7/remote/argocd-demo-app.git/objects/08/e5e289dcd7efe890d93b203a1a086c5f82b6c4
./argocd-lab7/remote/argocd-demo-app.git/objects/0d/9b90c4e62efe58f09d0bb5c337a7a734d71dfa
./argocd-lab7/remote/argocd-demo-app.git/objects/11/7e0bae45899e9a9c3922c3458beeab219163a8
./argocd-lab7/remote/argocd-demo-app.git/objects/1e/d9ddc9361329ecd3847cefd537a4baec138ac8
./argocd-lab7/remote/argocd-demo-app.git/objects/1f/a128f220b60304f46c2703ea27095342b7bd1b
./argocd-lab7/remote/argocd-demo-app.git/objects/23/6a77c7c4ddaf01ca2292cf72761470780af30c
./argocd-lab7/remote/argocd-demo-app.git/objects/23/7896f40d0077cb155da02459b3e0bc4d8849ce
./argocd-lab7/remote/argocd-demo-app.git/objects/31/1df8f38d3e90e49ea092c4f2b6bd490581be39
./argocd-lab7/remote/argocd-demo-app.git/objects/3c/f1b83de00f24cb36a30df9a7ead4e815d1f59e
./argocd-lab7/remote/argocd-demo-app.git/objects/6c/344fa9e354a669cce29fd105485d28a2a280b8
./argocd-lab7/remote/argocd-demo-app.git/objects/99/b0b76cf0d5098a1e6f36072662e6e6503705e8
./argocd-lab7/remote/argocd-demo-app.git/objects/ae/d6e2401de64f37838e9254c6cd1f84cb7ce35a
./argocd-lab7/remote/argocd-demo-app.git/objects/b2/d65850fcf71ad4f3e1b6909029bfc3a1aa84f8
./argocd-lab7/remote/argocd-demo-app.git/objects/d9/45f779a01b14a27d78b3d20dbdf4d438fe2e50
./argocd-lab7/remote/argocd-demo-app.git/objects/ec/c79c9ddf25e6697b56da1efe708645dece052a
./argocd-lab7/remote/argocd-demo-app.git/refs/heads/main
./argocd-lab7/results/SIMULATED.md
./argocd-lab7/results/clone.err
./argocd-lab7/results/elapsed.txt
./argocd-lab7/results/gh-repo-create.json
./argocd-lab7/results/gh-repo-get.json
./argocd-lab7/results/git-mode.txt
./argocd-lab7/results/install-argocd-cli.log
./argocd-lab7/results/install-kubeconform.log
./argocd-lab7/results/nginx-pull.log
./argocd-lab7/results/push-v1.err
./argocd-lab7/results/push-v2.err
./argocd-lab7/results/task1.1-github.txt
./argocd-lab7/results/task1.3-kubeconform.txt
./argocd-lab7/results/task1.4-push.txt
./argocd-lab7/results/task2-argocd-version.txt
./argocd-lab7/results/task2.2-repo-add-help.txt
./argocd-lab7/results/task2.3-repo-get-help.txt
./argocd-lab7/results/task3-cli-vs-yaml.txt
./argocd-lab7/results/task3.1-generate-spec.err
./argocd-lab7/results/task3.2-application-kubeconform.txt
./argocd-lab7/results/task3.4-desired-state.txt
./argocd-lab7/results/task3.5-git-log.txt
./argocd-lab7/results/task3.5-gitops-diff.txt
./argocd-lab7/results/task3.5-remote-head.txt
./argocd-lab7/results/verify-curl-v1.html
./argocd-lab7/results/verify-curl-v2.html
```
