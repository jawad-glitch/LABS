# Lab 1 - Install and Set Up Kubernetes - completion proof
Completed (UTC): 2026-11-09 14:00:32 | EC2: i-0c658a0d477ac45d7 | host: ip-172-31-10-19 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 1 - Install and Set Up Kubernetes, 2026-11-09 14:00:23 UTC) ==========
PASS: Task 1: Docker CE running (preinstalled, no duplicate repo/keyring added), hello-world ran
PASS: Task 2.1: kind v0.33.0 installed (sha256 verified)
FAIL: Task 2.2: kubectl v1.37.2 installed (sha256 verified)
PASS: Task 2.3: completion + alias k in ~/.bashrc exactly once each (idempotent)
PASS: Task 3: cluster my-cluster created, context kind-my-cluster current, API reachable
PASS: Task 4.1: node my-cluster-control-plane Ready, label ingress-ready=true, host ports 80/443 mapped
PASS: Task 4.2: all kube-system pods Running (apiserver, etcd, coredns, kube-proxy, CNI)
PASS: Task 4.3: nginx-test deployment rolled out (nginx:1.27-alpine) - 1/1 Running
PASS: Task 4.4: lab curl localhost:NodePort fails (HTTP 000) - node IP:NodePort serves the nginx page (HTTP 200)
PASS: Task 5.1: api-resources listed (72 lines), events + kubeconfig captured
PASS: Task 5.2: test-namespace created and set as context namespace
PASS: Lab bug: cleanup without -n fails NotFound (context ns = test-namespace); -n default works; context reset
PASS: Time: lab finished in 118s (<= 300s)
CORE: 12/13 PASS
```

## Cluster snapshot
```
error: the server doesn't have a resource type "clusterpolicy"

NAMESPACE            NAME                                               READY   STATUS    RESTARTS   AGE
kube-system          coredns-559f6c778d-48f7q                           1/1     Running   0          54s
kube-system          coredns-559f6c778d-f6blt                           1/1     Running   0          55s
kube-system          etcd-my-cluster-control-plane                      1/1     Running   0          66s
kube-system          kindnet-c5x2h                                      1/1     Running   0          55s
kube-system          kube-apiserver-my-cluster-control-plane            1/1     Running   0          66s
kube-system          kube-controller-manager-my-cluster-control-plane   1/1     Running   0          66s
kube-system          kube-proxy-wrvqx                                   1/1     Running   0          55s
kube-system          kube-scheduler-my-cluster-control-plane            1/1     Running   0          66s
local-path-storage   local-path-provisioner-75f7fc7dc5-hqsms            1/1     Running   0          54s

NAME	NAMESPACE	REVISION	UPDATED	STATUS	CHART	APP VERSION
```

## Docker snapshot
```
CONTAINER ID   IMAGE                  COMMAND                  CREATED              STATUS              PORTS                                                                 NAMES
7390512542c9   kindest/node:v1.37.0   "/usr/local/bin/entr…"   About a minute ago   Up About a minute   0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, 127.0.0.1:46467->6443/tcp   my-cluster-control-plane

IMAGE                                                                                  ID             DISK USAGE   CONTENT SIZE   EXTRA
hello-world:latest                                                                     c567b231f656       25.9kB         9.49kB        
kindest/node@sha256:a1ed56cfb0e7b93589bdf97c8cd566405a265939e3620fc4f5de89adff580ae5   a1ed56cfb0e7       1.34GB          388MB   U    
nginx:1.27-alpine                                                                      65645c7bb6a0       74.5MB         21.9MB        
```

## Files
```
./k8s-lab1/basic-cluster.yaml
./k8s-lab1/results/bug-cleanup-without-namespace.txt
./k8s-lab1/results/cleanup-fixed.txt
./k8s-lab1/results/elapsed.txt
./k8s-lab1/results/kind-load.txt
./k8s-lab1/results/nginx-pull.log
./k8s-lab1/results/task1-docker.txt
./k8s-lab1/results/task1.3-hello-world.txt
./k8s-lab1/results/task2-versions.txt
./k8s-lab1/results/task2.1-install-kind.log
./k8s-lab1/results/task2.2-install-kubectl.log
./k8s-lab1/results/task2.3-bashrc-lines.txt
./k8s-lab1/results/task3-port-mappings.txt
./k8s-lab1/results/task3.2-kind-create.txt
./k8s-lab1/results/task3.3-context.txt
./k8s-lab1/results/task4.1-nodes.txt
./k8s-lab1/results/task4.2-all-pods.txt
./k8s-lab1/results/task4.2-componentstatuses-deprecated.txt
./k8s-lab1/results/task4.3-deployment.txt
./k8s-lab1/results/task4.4-nodeport-response.html
./k8s-lab1/results/task4.4-service.txt
./k8s-lab1/results/task5.1-api-resources.txt
./k8s-lab1/results/task5.1-config-view.txt
./k8s-lab1/results/task5.1-events.txt
./k8s-lab1/results/task5.1-get-all.txt
./k8s-lab1/results/task5.2-current-namespace.txt
./k8s-lab1/results/task5.2-namespaces.txt
```
