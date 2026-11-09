# Lab 3 - Create Simple Workflow in Argo Workflows - completion proof
Completed (UTC): 2026-11-09 11:55:42 | EC2: i-068eda895d1aa2a0e | host: ip-172-31-10-173 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 3 - Create Simple Workflow in Argo Workflows, 2026-11-09 11:55:35 UTC) ==========
PASS: Task 1: hello-world.yaml accepted by API server (Workflow CRD schema, dry-run=server)
PASS: Task 2.1: argo-workflows-workflow-controller and argo-workflows-server available (Argo v4.1.6)
PASS: Task 2.2: argo submit printed Name hello-world-* in Namespace argo
PASS: Task 2.3: --output name captured hello-world-xfqlc
PASS: Task 3: argo list + get + watch show hello-world-xfqlc Succeeded
PASS: Task 4.1: logs show greeting, real date line and completion line
PASS: Task 4.2/4.3: follow logs returned, per-pod main-container logs (hello-world-xfqlc)
PASS: Task 1/Best practice: pod got requests 100m/64Mi, limits 200m/128Mi
PASS: Task 5.1/5.2: Status Succeeded, no artifacts in workflow status (argo artifacts not a CLI command - captured)
PASS: Example 1: multi-step multi-step-ph7ph Succeeded, 3 step pods Succeeded, 3 messages logged
PASS: Example 2: -p overrides -> "Welcome, DevOps Engineer!"
PASS: Best practices: labels + workflow-executor SA + retryStrategy, ran as uid=1000
PASS: Task 5.3: argo delete + delete --completed left 0 workflows
PASS: Time budget: lab finished in 280s (<= 300s)
CORE: 14/14 PASS
```

## Cluster snapshot
```
error: the server doesn't have a resource type "clusterpolicy"

NAMESPACE            NAME                                                  READY   STATUS    RESTARTS   AGE
argo                 argo-workflows-server-5d8c8f8b-s28lg                  1/1     Running   0          104s
argo                 argo-workflows-workflow-controller-6b5ff6d9bb-rd78m   1/1     Running   0          104s
kube-system          coredns-559f6c778d-8zvlc                              1/1     Running   0          3m34s
kube-system          coredns-559f6c778d-kddw2                              1/1     Running   0          3m33s
kube-system          etcd-argo-control-plane                               1/1     Running   0          3m45s
kube-system          kindnet-vlb5m                                         1/1     Running   0          3m34s
kube-system          kube-apiserver-argo-control-plane                     1/1     Running   0          3m39s
kube-system          kube-controller-manager-argo-control-plane            1/1     Running   0          3m44s
kube-system          kube-proxy-94lmz                                      1/1     Running   0          3m34s
kube-system          kube-scheduler-argo-control-plane                     1/1     Running   0          3m45s
local-path-storage   local-path-provisioner-75f7fc7dc5-56wkl               1/1     Running   0          3m33s

NAME          	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART                	APP VERSION
argo-workflows	argo     	1       	2026-11-09 11:53:03.602585457 +0000 UTC	deployed	argo-workflows-2.0.18	v4.1.6     
```

## Docker snapshot
```
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS         PORTS                       NAMES
4647026f6172   kindest/node:v1.37.0   "/usr/local/bin/entr…"   4 minutes ago   Up 4 minutes   127.0.0.1:35369->6443/tcp   argo-control-plane

IMAGE                                                                                  ID             DISK USAGE   CONTENT SIZE   EXTRA
alpine:3.16                                                                            452e7292acee       9.01MB         2.81MB        
kindest/node@sha256:a1ed56cfb0e7b93589bdf97c8cd566405a265939e3620fc4f5de89adff580ae5   a1ed56cfb0e7       1.34GB          388MB   U    
quay.io/argoproj/argocli:v4.1.6                                                        acb4c1de9a9c        279MB         76.6MB        
quay.io/argoproj/argoexec:v4.1.6                                                       28432d912a71        243MB         70.2MB        
quay.io/argoproj/workflow-controller:v4.1.6                                            a012a639ead3        176MB         50.2MB        
```

## Files
```
./argo-workflows-lab/best-practices-workflow.yaml
./argo-workflows-lab/executor-rbac.yaml
./argo-workflows-lab/hello-world.yaml
./argo-workflows-lab/multi-step-workflow.yaml
./argo-workflows-lab/parameterized-workflow.yaml
./argo-workflows-lab/results/argo-wait.txt
./argo-workflows-lab/results/bestpractice-logs.txt
./argo-workflows-lab/results/bestpractice-meta.txt
./argo-workflows-lab/results/elapsed.txt
./argo-workflows-lab/results/events.txt
./argo-workflows-lab/results/example1-multistep-logs.txt
./argo-workflows-lab/results/example1-nodes.txt
./argo-workflows-lab/results/example2-param-logs.txt
./argo-workflows-lab/results/executor-rbac-apply.txt
./argo-workflows-lab/results/helm-install.log
./argo-workflows-lab/results/image-pull.log
./argo-workflows-lab/results/install-argo-cli.log
./argo-workflows-lab/results/install.log
./argo-workflows-lab/results/kind-create.log
./argo-workflows-lab/results/kind-load.log
./argo-workflows-lab/results/lab-original-argo-artifacts.txt
./argo-workflows-lab/results/lab-original-task4.3-c-template.txt
./argo-workflows-lab/results/phases-before-cleanup.txt
./argo-workflows-lab/results/submitted.txt
./argo-workflows-lab/results/task1-dryrun-server.txt
./argo-workflows-lab/results/task1-pod-resources.txt
./argo-workflows-lab/results/task1.4-cat-hello-world.txt
./argo-workflows-lab/results/task2.1-pods.txt
./argo-workflows-lab/results/task2.2-submit.txt
./argo-workflows-lab/results/task2.3-name.txt
./argo-workflows-lab/results/task3.1-list.txt
./argo-workflows-lab/results/task3.2-get.txt
./argo-workflows-lab/results/task3.3-watch.txt
./argo-workflows-lab/results/task4.1-logs.txt
./argo-workflows-lab/results/task4.2-logs-follow.txt
./argo-workflows-lab/results/task4.3-logs-pod-main.txt
./argo-workflows-lab/results/task5.1-status.txt
./argo-workflows-lab/results/task5.2-workflow.json
./argo-workflows-lab/results/task5.3-after-cleanup.txt
./argo-workflows-lab/results/task5.3-delete-completed.txt
./argo-workflows-lab/results/task5.3-delete-one.txt
./argo-workflows-lab/results/versions.txt
```
