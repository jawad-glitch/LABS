# GitOps Lab 14 - GitOps Rollback with Git History - completion proof
Completed (UTC): 2026-11-10 09:11:50 | EC2: i-0385ca694299256a4 | host: ip-172-31-10-127 | user: ubuntu

## Core checks
```
========== CORE CHECKS (GitOps Lab 14 - GitOps Rollback with Git History, 2026-11-10 09:11:42 UTC) - CLUSTER/ARGO CD SIMULATED, GIT + PODS REAL ==========
FAIL: Task 1: argocd v3.6.1/kubectl/kubeconform (sha256); lab's v2.11.0 install.yaml largest CRD > 262144 (needs --server-side)
PASS: Task 2.1: one commit + tag v1.0.0; 4 manifests schema-valid; lab dry-run=client fails without a cluster
PASS: Task 2.2: Application (prune+selfHeal, CreateNamespace) generated with reachable http repo; both specs CRD-valid
PASS: v1.0.0 synced: 3 pods nginx:1.20 serving v1.0.0
PASS: v2.0.0 synced: 5 pods nginx:1.21 serving v2.0.0; memory limit 128Mi enforced
PASS: v2.1.0: Degraded (ErrImagePull), 5 old nginx:1.21 pods kept - but they serve the BROKEN ConfigMap content
PASS: Task 3.1a: git revert keeps v2.1.0 in history + adds revert commit; cluster back to v2.0.0 Synced/Healthy
PASS: Lab bug: branch-at-v1.0.0 + merge --no-ff is a no-op (Already up to date; still nginx:1.21 x5)
PASS: Fixed tag rollback (tree restored from v1.0.0 in a new commit): 3 pods nginx:1.20 serving v1.0.0, Synced
FAIL: git reset --hard + push --force rewrites shared main (v2.1.0 gone) and the collaborator push is rejected
PASS: Task 3.2: gate exits 1 on nginx:broken-test, 0 when restored; committed last as 'chore: add pre-commit validation gate'
PASS: Time: finished in 54s (<= 300s)
CORE: 10/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE        ID             DISK USAGE   CONTENT SIZE   EXTRA
nginx:1.20   38f8c1d9613f        213MB         56.7MB        
nginx:1.21   2bcabc23b454        213MB         56.7MB        
```

## Files
```
./gitops-lab14/application-lab-contract.yaml
./gitops-lab14/application.yaml
./gitops-lab14/cm/sample-app-html.html
./gitops-lab14/gitsrv.py
./gitops-lab14/k8s-manifests/configmap.yaml
./gitops-lab14/k8s-manifests/deployment.yaml
./gitops-lab14/k8s-manifests/namespace.yaml
./gitops-lab14/k8s-manifests/service.yaml
./gitops-lab14/reconcile.py
./gitops-lab14/results/SIMULATED.md
./gitops-lab14/results/argocd-events.log
./gitops-lab14/results/bug-dry-run-client-no-cluster.txt
./gitops-lab14/results/bug-reset-collaborator-push.txt
./gitops-lab14/results/bug-tag-merge.txt
./gitops-lab14/results/bug-v2.11-crd-size.txt
./gitops-lab14/results/elapsed.txt
./gitops-lab14/results/final-git-log.txt
./gitops-lab14/results/image-pull.txt
./gitops-lab14/results/reset-force.err
./gitops-lab14/results/s1-serving.txt
./gitops-lab14/results/s1-v1.0.0.json
./gitops-lab14/results/s2-memlimit.txt
./gitops-lab14/results/s2-serving.txt
./gitops-lab14/results/s2-v2.0.0.json
./gitops-lab14/results/s3-serving.txt
./gitops-lab14/results/s3-v2.1.0.json
./gitops-lab14/results/s4-reverted.json
./gitops-lab14/results/s4-serving.txt
./gitops-lab14/results/s5-rollback-v1.json
./gitops-lab14/results/s5-serving.txt
./gitops-lab14/results/task2.1-git.txt
./gitops-lab14/results/task2.1-kubeconform.txt
./gitops-lab14/results/task2.2-app-kubeconform.txt
./gitops-lab14/results/task2.2-generate.err
./gitops-lab14/results/task2.2-remote.txt
./gitops-lab14/results/task3-reset-demo.txt
./gitops-lab14/results/task3.1-log-after-revert.txt
./gitops-lab14/results/task3.2-gate-broken.txt
./gitops-lab14/results/task3.2-gate-valid.txt
./gitops-lab14/results/tools.txt
./gitops-lab14/sample-app-html.html
./gitops-lab14/validate-before-commit.sh
```
