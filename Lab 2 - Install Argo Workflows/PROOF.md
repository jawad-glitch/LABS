# Lab 2 - Install Argo Workflows - completion proof
Completed (UTC): 2026-11-07 18:05:05 | EC2: i-03aee7f51e18836ea | host: ip-172-31-10-238 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 2 - Install Argo Workflows, 2026-11-07 18:04:59 UTC) ==========
PASS: Task 1.1: kubectl cluster-info reachable
FAIL: Task 1.1: at least one node Ready
FAIL: Task 1.2: helm 3.x installed
PASS: Task 2.1: argo helm repository added
PASS: Task 2.2: helm search shows argo/argo-workflows
PASS: Task 3.1: argo namespace exists and is Active
PASS: Task 3.2: helm release argo-workflows is deployed
PASS: Task 3.3: >=2 pods in argo ns, all Running+Ready
PASS: Task 4.1: deployment argo-workflows-server is available
PASS: Task 4.1: deployment argo-workflows-workflow-controller is available
PASS: Task 4.1: service argo-workflows-server exists
PASS: Task 4.1: helm chart configmaps present in argo ns
PASS: Task 4.3: serviceaccount argo-workflows-server exists
PASS: Task 4.3: argo-workflows clusterrolebindings exist
FAIL: Task 5.2: /api/v1/info returns HTTP 200
FAIL: Task 5.2: /api/v1/info contains version field
FAIL: Task 6.1: argo CLI installed and reports v3
FAIL: Task 6.2: argo CLI reaches the server (argo list)
CORE: 12/18 PASS
```

## Cluster snapshot
```
error: the server doesn't have a resource type "clusterpolicy"

NAMESPACE     NAME                                                 READY   STATUS    RESTARTS   AGE
argo          argo-workflows-server-7dfdccdd8-tpg9n                1/1     Running   0          81s
argo          argo-workflows-workflow-controller-55df46c7b-2qkls   1/1     Running   0          81s
kube-system   coredns-559f6c778d-klwd2                             1/1     Running   0          2m24s
kube-system   etcd-minikube                                        1/1     Running   0          2m34s
kube-system   kindnet-gfwx4                                        1/1     Running   0          2m24s
kube-system   kube-apiserver-minikube                              1/1     Running   0          2m34s
kube-system   kube-controller-manager-minikube                     1/1     Running   0          2m34s
kube-system   kube-proxy-dxzrr                                     1/1     Running   0          2m24s
kube-system   kube-scheduler-minikube                              1/1     Running   0          2m34s
kube-system   storage-provisioner                                  1/1     Running   0          2m23s

NAME          	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART                	APP VERSION
argo-workflows	argo     	1       	2026-11-07 18:02:53.583637066 +0000 UTC	deployed	argo-workflows-2.0.18	v4.1.6     
```

## Docker snapshot
```
CONTAINER ID   IMAGE                                 COMMAND                  CREATED         STATUS         PORTS                                                                                                                                  NAMES
61d8ce137dcc   gcr.io/k8s-minikube/kicbase:v0.0.51   "/usr/local/bin/entr…"   3 minutes ago   Up 3 minutes   127.0.0.1:32768->22/tcp, 127.0.0.1:32769->2376/tcp, 127.0.0.1:32770->5000/tcp, 127.0.0.1:32771->8443/tcp, 127.0.0.1:32772->32443/tcp   minikube

IMAGE                                                                                                 ID             DISK USAGE   CONTENT SIZE   EXTRA
gcr.io/k8s-minikube/kicbase:v0.0.51                                                                   146cd636030e       1.89GB          532MB        
gcr.io/k8s-minikube/kicbase@sha256:4a1c825b61479e6c898851ea66f13c620aaeab6002746e95067fc2c4b38a0b24   4a1c825b6147       1.89GB          532MB   U    
```

## Files
```
./results/argo-all.txt
./results/argo-env.txt
./results/argo-list.txt
./results/argo-pods.txt
./results/argo-server-info.txt
./results/argo-version.txt
./results/cluster-info.txt
./results/clusterrolebindings.txt
./results/clusterroles.txt
./results/configmaps.txt
./results/controller-logs.txt
./results/deployments.txt
./results/helm-install.log
./results/helm-repo-add.log
./results/helm-repo-initial.txt
./results/helm-repo-list.txt
./results/helm-repo-update.log
./results/helm-search-argo.txt
./results/helm-status.txt
./results/helm-version.txt
./results/kubectl-get-nodes.txt
./results/kubectl-version.txt
./results/minikube-start.log
./results/namespace-argo.txt
./results/namespaces.txt
./results/pf-pid.txt
./results/pods.txt
./results/port-forward.log
./results/pre-cleanup.txt
./results/server-logs.txt
./results/serviceaccounts.txt
./results/services.txt
./results/ui-info.json
./results/which-argo.txt
./results/which-helm.txt
```
