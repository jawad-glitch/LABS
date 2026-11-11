# Prometheus Lab 3 - Service Discovery in Prometheus - completion proof
Completed (UTC): 2026-11-11 20:46:39 | EC2: i-014895ed0e00489e3 | host: ip-172-31-10-26 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Prometheus Lab 3 - Service Discovery in Prometheus, 2026-11-11 20:46:32 UTC) - ALL REAL (kind v0.22.0) ==========
PASS: Task 1: docker present; kind v0.22.0 + kubectl sha256-verified; lab's 'jammy' repo line recorded vs this OS
PASS: Task 1.3: kind cluster 'prom-lab' created, node Ready
PASS: Task 2: Prometheus pod Running 1/1 with serviceAccountName=prometheus; NodePort 30090 answers 200
PASS: Task 3.1: kube-state-metrics Running 1/1, headless Service (ClusterIP None)
PASS: Task 3.2: reload 200; all lab jobs UP (prometheus, apiservers, nodes, service-endpoints): kubernetes-apiservers,kubernetes-nodes,kubernetes-pods,kubernetes-service-endpoints,prometheus
FAIL: Task 3.3: ready replicas = 1 for prometheus and kube-state-metrics
PASS: Lab bug: KSM discovered twice (pod + service annotations) -> kubernetes-pods job extra and duplicate series per deployment
PASS: Lab bug: kube_pod_status_phase{phase=Running} returns 0/1 values; '== 1' needed to list Running pods only
PASS: Lab bug: lab's KSM ClusterRole is incomplete - KSM logs 'forbidden' (60 lines)
FAIL: Task 2.4: lab template returns None/{}; completed script reproduces Prometheus's final labels exactly
PASS: Fixed: KSM scraped once (no kubernetes-pods target, 2 series), RBAC complete (0 forbidden in last 20s)
PASS: Time: finished in 234s (<= 300s)
CORE: 10/12 PASS
```

## Cluster snapshot
```
error: the server doesn't have a resource type "clusterpolicy"

NAMESPACE            NAME                                             READY   STATUS    RESTARTS   AGE
kube-system          coredns-76f75df574-d8bjd                         1/1     Running   0          2m29s
kube-system          coredns-76f75df574-kkl6v                         1/1     Running   0          2m29s
kube-system          etcd-prom-lab-control-plane                      1/1     Running   0          2m45s
kube-system          kindnet-hptz6                                    1/1     Running   0          2m29s
kube-system          kube-apiserver-prom-lab-control-plane            1/1     Running   0          2m43s
kube-system          kube-controller-manager-prom-lab-control-plane   1/1     Running   0          2m45s
kube-system          kube-proxy-v2v7q                                 1/1     Running   0          2m29s
kube-system          kube-scheduler-prom-lab-control-plane            1/1     Running   0          2m45s
local-path-storage   local-path-provisioner-7577fdbbfb-w2x8l          1/1     Running   0          2m29s
monitoring           kube-state-metrics-7464774dd-7rmmm               1/1     Running   0          79s
monitoring           prometheus-7f97f8895d-d2c9v                      1/1     Running   0          118s

NAME	NAMESPACE	REVISION	UPDATED	STATUS	CHART	APP VERSION
```

## Docker snapshot
```
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS         PORTS                       NAMES
0d821c4386ac   kindest/node:v1.29.2   "/usr/local/bin/entr…"   3 minutes ago   Up 3 minutes   127.0.0.1:39829->6443/tcp   prom-lab-control-plane

IMAGE                                                                                  ID             DISK USAGE   CONTENT SIZE   EXTRA
kindest/node@sha256:51a1434a5397193442f0be2a297b488b6c919ce8a3931be0ce822606ea5ca245   51a1434a5397       1.39GB          409MB   U    
prom/prometheus:v2.51.0                                                                5ccad477d005        369MB          104MB        
registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.10.0                          ec5d6f6be228         60MB         13.5MB        
```

## Files
```
./prometheus-lab3/ksm-pod-discovered-labels.json
./prometheus-lab3/ksm-pod-prometheus-final-labels.json
./prometheus-lab3/ksm-pod-script-final-labels.json
./prometheus-lab3/manifests/01-rbac.yaml
./prometheus-lab3/manifests/02-configmap.yaml
./prometheus-lab3/manifests/03-prometheus.yaml
./prometheus-lab3/manifests/04-kube-state-metrics.yaml
./prometheus-lab3/manifests/05-ksm-rbac-fix.yaml
./prometheus-lab3/results/elapsed.txt
./prometheus-lab3/results/fix-apply.txt
./prometheus-lab3/results/fix-ksm-logs.txt
./prometheus-lab3/results/fix-results.txt
./prometheus-lab3/results/image-pull.txt
./prometheus-lab3/results/port-forward.log
./prometheus-lab3/results/task1-docker.txt
./prometheus-lab3/results/task1-kind.txt
./prometheus-lab3/results/task1-kubectl.txt
./prometheus-lab3/results/task1.3-cluster.txt
./prometheus-lab3/results/task1.3-kind-create.txt
./prometheus-lab3/results/task1.3-kind-load.txt
./prometheus-lab3/results/task2-apply.txt
./prometheus-lab3/results/task2.3-nodeport.txt
./prometheus-lab3/results/task2.3-prometheus.txt
./prometheus-lab3/results/task2.4-relabel-validation.txt
./prometheus-lab3/results/task3.1-apply.txt
./prometheus-lab3/results/task3.1-ksm-logs.txt
./prometheus-lab3/results/task3.1-ksm-rbac.txt
./prometheus-lab3/results/task3.1-pods.txt
./prometheus-lab3/results/task3.2-reload.txt
./prometheus-lab3/results/task3.2-targets.json
./prometheus-lab3/results/task3.2-targets.txt
./prometheus-lab3/results/task3.3-phase.json
./prometheus-lab3/results/task3.3-queries.txt
./prometheus-lab3/results/task3.3-ready.json
./prometheus-lab3/validate_labels.py
```
