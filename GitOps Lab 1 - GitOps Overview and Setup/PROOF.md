# GitOps Lab 1 - GitOps Overview and Setup - completion proof
Completed (UTC): 2026-11-10 08:21:08 | EC2: i-0038a73b22c887ed6 | host: ip-172-31-10-62 | user: ubuntu

## Core checks
```
========== CORE CHECKS (GitOps Lab 1 - GitOps Overview and Setup, 2026-11-10 08:21:00 UTC) ==========
PASS: Tasks 2/4/5/6: git, kubectl, helm v3, kind, docker available (kubectl/helm/kind sha256-verified)
PASS: Task 2.4: git user.name/user.email configured
PASS: Task 3: repo gitops-lab-demo on local-bare remote - initial structure pushed; all 8 dirs survive a fresh clone (.gitkeep)
PASS: Task 4.5: kubectl completion + alias k in ~/.bashrc exactly once
PASS: Task 6: kind cluster gitops-lab with 2 Ready nodes; control-plane labelled ingress-ready=true
PASS: Task 7.2/7.3: sample-app deployed from a fresh clone of the remote - 1/1 ready, service present
PASS: Task 5.5/5.6: stable + bitnami repos listed
PASS: Task 7.4/7.5: helm release my-nginx deployed and its pod Running
PASS: Task 7.6/7.7: scale commit pushed to remote; apply from fresh clone -> 2/2 replicas ready; 2+ commits in history
PASS: Lab bug: quoted heredoc keeps $(...) literal; kubectl --short flag removed - fixed summary has real values
PASS: Time: lab finished in 179s (<= 300s)
CORE: 11/11 PASS
```

## Cluster snapshot
```
error: the server doesn't have a resource type "clusterpolicy"

NAMESPACE            NAME                                               READY   STATUS    RESTARTS   AGE
default              my-nginx-c7f9d8c8f-9vwvk                           1/1     Running   0          15s
default              sample-app-54bd9d6577-jfmsn                        1/1     Running   0          65s
default              sample-app-54bd9d6577-wj26n                        1/1     Running   0          12s
kube-system          coredns-559f6c778d-c6fg9                           1/1     Running   0          104s
kube-system          coredns-559f6c778d-mvbq2                           1/1     Running   0          104s
kube-system          etcd-gitops-lab-control-plane                      1/1     Running   0          116s
kube-system          kindnet-lj2z6                                      1/1     Running   0          96s
kube-system          kindnet-xqz6x                                      1/1     Running   0          105s
kube-system          kube-apiserver-gitops-lab-control-plane            1/1     Running   0          115s
kube-system          kube-controller-manager-gitops-lab-control-plane   1/1     Running   0          115s
kube-system          kube-proxy-fxz9k                                   1/1     Running   0          105s
kube-system          kube-proxy-qfkwj                                   1/1     Running   0          96s
kube-system          kube-scheduler-gitops-lab-control-plane            1/1     Running   0          115s
local-path-storage   local-path-provisioner-75f7fc7dc5-l5dll            1/1     Running   0          103s

NAME    	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART         	APP VERSION
my-nginx	default  	1       	2026-11-10 08:20:53.751734241 +0000 UTC	deployed	my-nginx-0.1.0	1.16.0     
```

## Docker snapshot
```
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS         PORTS                                                                 NAMES
58af46b91d6e   kindest/node:v1.37.0   "/usr/local/bin/entr…"   2 minutes ago   Up 2 minutes   0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, 127.0.0.1:34653->6443/tcp   gitops-lab-control-plane
69b064338d5e   kindest/node:v1.37.0   "/usr/local/bin/entr…"   2 minutes ago   Up 2 minutes                                                                         gitops-lab-worker

IMAGE                                                                                  ID             DISK USAGE   CONTENT SIZE   EXTRA
kindest/node@sha256:a1ed56cfb0e7b93589bdf97c8cd566405a265939e3620fc4f5de89adff580ae5   a1ed56cfb0e7       1.34GB          388MB   U    
nginx:1.27-alpine                                                                      65645c7bb6a0       74.5MB         21.9MB        
```

## Files
```
./gitops-lab1/gitops-lab-demo-snapshot/LICENSE
./gitops-lab1/gitops-lab-demo-snapshot/README.md
./gitops-lab1/gitops-lab-demo-snapshot/applications/dev/.gitkeep
./gitops-lab1/gitops-lab-demo-snapshot/applications/dev/sample-app.yaml
./gitops-lab1/gitops-lab-demo-snapshot/applications/prod/.gitkeep
./gitops-lab1/gitops-lab-demo-snapshot/applications/staging/.gitkeep
./gitops-lab1/gitops-lab-demo-snapshot/clusters/dev/.gitkeep
./gitops-lab1/gitops-lab-demo-snapshot/clusters/local/.gitkeep
./gitops-lab1/gitops-lab-demo-snapshot/clusters/prod/.gitkeep
./gitops-lab1/gitops-lab-demo-snapshot/infrastructure/base/.gitkeep
./gitops-lab1/gitops-lab-demo-snapshot/infrastructure/overlays/.gitkeep
./gitops-lab1/kind-config.yaml
./gitops-lab1/my-nginx/.helmignore
./gitops-lab1/my-nginx/Chart.yaml
./gitops-lab1/my-nginx/templates/NOTES.txt
./gitops-lab1/my-nginx/templates/_helpers.tpl
./gitops-lab1/my-nginx/templates/deployment.yaml
./gitops-lab1/my-nginx/templates/hpa.yaml
./gitops-lab1/my-nginx/templates/httproute.yaml
./gitops-lab1/my-nginx/templates/ingress.yaml
./gitops-lab1/my-nginx/templates/service.yaml
./gitops-lab1/my-nginx/templates/serviceaccount.yaml
./gitops-lab1/my-nginx/templates/tests/test-connection.yaml
./gitops-lab1/my-nginx/values.yaml
./gitops-lab1/results/bug-kubectl-short-flag.txt
./gitops-lab1/results/bug-lab-summary-quoted-heredoc.txt
./gitops-lab1/results/elapsed.txt
./gitops-lab1/results/gitops-environment-summary.txt
./gitops-lab1/results/kind-load.txt
./gitops-lab1/results/nginx-pull.log
./gitops-lab1/results/task2-git-config.txt
./gitops-lab1/results/task3-remote.txt
./gitops-lab1/results/task3.2-create-repo.txt
./gitops-lab1/results/task3.3-clone.err
./gitops-lab1/results/task3.4-structure-from-fresh-clone.txt
./gitops-lab1/results/task3.6-push.err
./gitops-lab1/results/task4-install-kubectl.log
./gitops-lab1/results/task5-install-helm.log
./gitops-lab1/results/task5.5-repo-add.txt
./gitops-lab1/results/task5.6-repo-list.txt
./gitops-lab1/results/task6-install-kind.log
./gitops-lab1/results/task6.7-kind-create.txt
./gitops-lab1/results/task6.8-7.1-cluster.txt
./gitops-lab1/results/task7.2-deploy.txt
./gitops-lab1/results/task7.3-verify.txt
./gitops-lab1/results/task7.4-bitnami-nginx-image.txt
./gitops-lab1/results/task7.4-helm-install.txt
./gitops-lab1/results/task7.5-helm-verify.txt
./gitops-lab1/results/task7.6-git-log.txt
./gitops-lab1/results/task7.6-push.err
./gitops-lab1/results/task7.7-deploy.txt
./gitops-lab1/results/task7.7-pods.txt
```
