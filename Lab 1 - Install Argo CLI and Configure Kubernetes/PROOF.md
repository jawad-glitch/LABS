# Lab 1 - Install Argo CLI and Configure Kubernetes - completion proof
Completed (UTC): 2026-11-07 17:51:58 | EC2: i-05c6c32f7061f0824 | host: ip-172-31-10-230 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 1 - Install Argo CLI and Configure Kubernetes, 2026-11-07 17:51:52 UTC) ==========
PASS: Task 1.3: architecture is x86_64
PASS: Task 1.2: curl, wget, gnupg, jq installed
FAIL: Task 2.1-2.3: kubectl in /usr/local/bin, version prints
PASS: Task 2.4: minikube in /usr/local/bin
PASS: Task 2.5: minikube host/kubelet/apiserver Running
PASS: Task 2.6: kubectl get nodes shows Ready
PASS: Task 2.6: kubectl cluster-info reachable
PASS: Task 3.1-3.3: argo CLI installed and reports a version
PASS: Task 4.1: namespace argo exists and is Active
FAIL: Task 4.2: argo-server + workflow-controller 1/1 available
PASS: Task 4.3: all argo pods Running (>=2 pods)
PASS: Task 4.4: rolebinding default-admin exists in argo ns
FAIL: Task 6.2: hello-world workflow was submitted
FAIL: Task 6.2: workflow reached phase Succeeded
FAIL: Task 6.5: argo logs contain 'Hello World from Argo'
FAIL: Task 6.3: workflow appears in argo list
PASS: Task 7.1: comprehensive verification report produced
FAIL: Task 7.2: argo delete --all left zero workflows
CORE: 11/18 PASS
```

## Cluster snapshot
```
error: the server doesn't have a resource type "clusterpolicy"

NAMESPACE     NAME                                   READY   STATUS    RESTARTS   AGE
argo          argo-server-7bdc95447-g4tf7            1/1     Running   0          34s
argo          workflow-controller-7884db94b5-67jhb   1/1     Running   0          34s
kube-system   coredns-559f6c778d-sg9cb               1/1     Running   0          58s
kube-system   etcd-minikube                          1/1     Running   0          69s
kube-system   kindnet-db6sr                          1/1     Running   0          58s
kube-system   kube-apiserver-minikube                1/1     Running   0          69s
kube-system   kube-controller-manager-minikube       1/1     Running   0          69s
kube-system   kube-proxy-pk9n5                       1/1     Running   0          58s
kube-system   kube-scheduler-minikube                1/1     Running   0          68s
kube-system   storage-provisioner                    1/1     Running   0          58s

NAME	NAMESPACE	REVISION	UPDATED	STATUS	CHART	APP VERSION
```

## Docker snapshot
```
CONTAINER ID   IMAGE                                 COMMAND                  CREATED              STATUS              PORTS                                                                                                                                  NAMES
58d4068523a6   gcr.io/k8s-minikube/kicbase:v0.0.51   "/usr/local/bin/entr…"   About a minute ago   Up About a minute   127.0.0.1:32768->22/tcp, 127.0.0.1:32769->2376/tcp, 127.0.0.1:32770->5000/tcp, 127.0.0.1:32771->8443/tcp, 127.0.0.1:32772->32443/tcp   minikube

IMAGE                                                                                                 ID             DISK USAGE   CONTENT SIZE   EXTRA
gcr.io/k8s-minikube/kicbase:v0.0.51                                                                   146cd636030e       1.89GB          532MB        
gcr.io/k8s-minikube/kicbase@sha256:4a1c825b61479e6c898851ea66f13c620aaeab6002746e95067fc2c4b38a0b24   4a1c825b6147       1.89GB          532MB   U    
```

## Files
```
./results/arch.txt
./results/argo-auth-token.txt
./results/argo-delete.txt
./results/argo-install-apply.txt
./results/argo-list-after-delete.txt
./results/argo-list.txt
./results/argo-pods.txt
./results/argo-submit.txt
./results/argo-ui-http.txt
./results/argo-version.txt
./results/cluster-info.txt
./results/docker-group.txt
./results/hello-world-workflow.yaml.txt
./results/host-mem.txt
./results/kubectl-get-nodes.txt
./results/kubectl-stable.txt
./results/kubectl-version.txt
./results/minikube-mem.txt
./results/minikube-start.log
./results/minikube-status.txt
./results/minikube-version.txt
./results/namespace-argo.txt
./results/port-forward.log
./results/rolebinding.txt
./results/system-verification.txt
./results/which-argo.txt
./results/which-kubectl.txt
./results/which-minikube.txt
```
