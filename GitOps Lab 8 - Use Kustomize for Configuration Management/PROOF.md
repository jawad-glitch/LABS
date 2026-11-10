# GitOps Lab 8 - Use Kustomize for Configuration Management - completion proof
Completed (UTC): 2026-11-10 08:43:15 | EC2: i-06d5c9cdfb6c8509b | host: ip-172-31-10-217 | user: ubuntu

## Core checks
```
(none saved)
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE               ID             DISK USAGE   CONTENT SIZE   EXTRA
nginx:1.27          6784fb0834aa        282MB         75.5MB        
nginx:1.27-alpine   65645c7bb6a0       74.5MB         21.9MB        
```

## Files
```
./gitops-lab8/base/database/deployment.yaml
./gitops-lab8/base/database/service.yaml
./gitops-lab8/base/kustomization.yaml
./gitops-lab8/base/webapp/configmap.yaml
./gitops-lab8/base/webapp/deployment.yaml
./gitops-lab8/base/webapp/service.yaml
./gitops-lab8/fixed-build/development.yaml
./gitops-lab8/fixed-build/namespaces.yaml
./gitops-lab8/fixed-build/production.yaml
./gitops-lab8/fixed-build/staging.yaml
./gitops-lab8/flux/flux-dev-kustomization.yaml
./gitops-lab8/flux/flux-namespaces-kustomization.yaml
./gitops-lab8/flux/flux-prod-kustomization.yaml
./gitops-lab8/flux/flux-source.yaml
./gitops-lab8/flux/flux-staging-kustomization.yaml
./gitops-lab8/gitsrv.py
./gitops-lab8/infrastructure/namespaces/development.yaml
./gitops-lab8/infrastructure/namespaces/kustomization.yaml
./gitops-lab8/infrastructure/namespaces/production.yaml
./gitops-lab8/infrastructure/namespaces/staging.yaml
./gitops-lab8/lab-original-build/development.yaml
./gitops-lab8/lab-original-build/production.yaml
./gitops-lab8/lab-original-build/staging.yaml
./gitops-lab8/lab-original/base/database/deployment.yaml
./gitops-lab8/lab-original/base/database/service.yaml
./gitops-lab8/lab-original/base/kustomization.yaml
./gitops-lab8/lab-original/base/webapp/configmap.yaml
./gitops-lab8/lab-original/base/webapp/deployment.yaml
./gitops-lab8/lab-original/base/webapp/service.yaml
./gitops-lab8/lab-original/overlays/development/database/deployment-patch.yaml
./gitops-lab8/lab-original/overlays/development/kustomization.yaml
./gitops-lab8/lab-original/overlays/development/webapp/configmap-patch.yaml
./gitops-lab8/lab-original/overlays/development/webapp/deployment-patch.yaml
./gitops-lab8/lab-original/overlays/production/database/deployment-patch.yaml
./gitops-lab8/lab-original/overlays/production/kustomization.yaml
./gitops-lab8/lab-original/overlays/production/webapp/configmap-patch.yaml
./gitops-lab8/lab-original/overlays/production/webapp/deployment-patch.yaml
./gitops-lab8/lab-original/overlays/staging/database/deployment-patch.yaml
./gitops-lab8/lab-original/overlays/staging/kustomization.yaml
./gitops-lab8/lab-original/overlays/staging/webapp/configmap-patch.yaml
./gitops-lab8/lab-original/overlays/staging/webapp/deployment-patch.yaml
./gitops-lab8/overlays/development/database/deployment-patch.yaml
./gitops-lab8/overlays/development/kustomization.yaml
./gitops-lab8/overlays/development/webapp/configmap-patch.yaml
./gitops-lab8/overlays/development/webapp/deployment-patch.yaml
./gitops-lab8/overlays/production/database/deployment-patch.yaml
./gitops-lab8/overlays/production/kustomization.yaml
./gitops-lab8/overlays/production/webapp/configmap-patch.yaml
./gitops-lab8/overlays/production/webapp/deployment-patch.yaml
./gitops-lab8/overlays/staging/database/deployment-patch.yaml
./gitops-lab8/overlays/staging/kustomization.yaml
./gitops-lab8/overlays/staging/webapp/configmap-patch.yaml
./gitops-lab8/overlays/staging/webapp/deployment-patch.yaml
./gitops-lab8/results/SIMULATED.md
./gitops-lab8/results/bug-kustomize-dry-run.txt
./gitops-lab8/results/bug-lab-build-analysis.txt
./gitops-lab8/results/bug-prod-probes-runtime.txt
./gitops-lab8/results/bug-python-http-server.txt
./gitops-lab8/results/bug-task3.5-base-replica-change.txt
./gitops-lab8/results/elapsed.txt
./gitops-lab8/results/fixed-build-development.err
./gitops-lab8/results/fixed-build-production.err
./gitops-lab8/results/fixed-build-staging.err
./gitops-lab8/results/flux-create.err
./gitops-lab8/results/git-log.txt
./gitops-lab8/results/image-pull.txt
./gitops-lab8/results/install-kubeconform.txt
./gitops-lab8/results/lab-build-development.err
./gitops-lab8/results/lab-build-production.err
./gitops-lab8/results/lab-build-staging.err
./gitops-lab8/results/task1-fixed-build-rc.txt
./gitops-lab8/results/task1.1-flux.txt
./gitops-lab8/results/task1.1-kubectl.txt
./gitops-lab8/results/task1.1-versions.txt
./gitops-lab8/results/task2-3-kubeconform.txt
./gitops-lab8/results/task2.2-smart-http.txt
./gitops-lab8/results/task2.3-flux-files.txt
./gitops-lab8/results/task3.1-3.3-runtime.txt
./gitops-lab8/results/task3.4-fixed-compare.txt
./gitops-lab8/results/task3.5-after-base-change.txt
./gitops-lab8/results/task3.6-dev-vs-prod.diff
./gitops-lab8/results/task3.6-lab-build-rc.txt
```
