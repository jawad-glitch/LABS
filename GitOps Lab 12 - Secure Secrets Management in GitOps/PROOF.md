# GitOps Lab 12 - Secure Secrets Management in GitOps - completion proof
Completed (UTC): 2026-11-10 09:02:30 | EC2: i-050402e61772bebda | host: ip-172-31-10-72 | user: ubuntu

## Core checks
```
(none saved)
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                                                                                  ID             DISK USAGE   CONTENT SIZE   EXTRA
bitnami/sealed-secrets-controller:0.41.2                                               e63ec6ec2b12        123MB         33.5MB        
kindest/node@sha256:a1ed56cfb0e7b93589bdf97c8cd566405a265939e3620fc4f5de89adff580ae5   a1ed56cfb0e7       1.34GB          388MB        
nginx:1.27-alpine                                                                      65645c7bb6a0       74.5MB         21.9MB        
```

## Files
```
./.gitignore
./RECOVERY.md
./manifests/base/app-deployment.yaml
./manifests/base/kustomization.yaml
./manifests/base/sealed-api-credentials.yaml
./manifests/base/sealed-db-password.yaml
./manifests/base/sealed-secret.yaml
./manifests/overlays/production/kustomization.yaml
./manifests/overlays/production/replica-patch.yaml
./public.pem
./results/.gitignore
./results/RECOVERY.md
./results/bug-backup-by-name.txt
./results/bug-gitignore-key-leak.txt
./results/bug-task7.1-update.txt
./results/elapsed.txt
./results/fetch-cert.err
./results/image-pull.txt
./results/kind-load.txt
./results/manifests/base/app-deployment.yaml
./results/manifests/base/kustomization.yaml
./results/manifests/base/sealed-api-credentials.yaml
./results/manifests/base/sealed-db-password.yaml
./results/manifests/base/sealed-secret.yaml
./results/manifests/overlays/production/kustomization.yaml
./results/manifests/overlays/production/replica-patch.yaml
./results/public.pem
./results/rotate-secrets.sh
./results/task1-kind-create.txt
./results/task1.1-cluster.txt
./results/task2.1-controller-apply.txt
./results/task2.1-controller-image.txt
./results/task2.1-controller-pod.txt
./results/task2.1-rollout.txt
./results/task2.3-cert.txt
./results/task3.2-base64-is-not-encryption.txt
./results/task3.3-no-plaintext.txt
./results/task3.4-sealed-files.txt
./results/task4.1-apply.txt
./results/task4.1-sealed-and-secrets.txt
./results/task4.3-env-check.txt
./results/task5.3-apply-k.txt
./results/task5.3-build.err
./results/task5.3-production-build.yaml
./results/task6.1-git-log.txt
./results/task6.1-tracked-files.txt
./results/task6.2-sync-state.txt
./results/task7.1-fixed-update.txt
./results/task7.2-rotate.txt
./results/task7.3-backup.txt
./results/task8-strict-scope.txt
./results/tools.txt
./rotate-secrets.sh
```
