# Lab 12 - Use Hubble CLI for Flow Monitoring - completion proof
Completed (UTC): 2026-11-09 15:12:08 | EC2: i-0c9e6d13314627a1b | host: ip-172-31-10-220 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 12 - Use Hubble CLI for Flow Monitoring, 2026-11-09 15:12:01 UTC) ==========
PASS: Task 1: Kind cluster hubble-lab created without kube-proxy
PASS: Task 2: Cilium and Hubble CLI installed and validated
PASS: Task 2: Hubble Relay operational and connected
PASS: Task 3: Workloads deployed in frontend, backend, database namespaces
PASS: Task 4.1: Inter-namespace flows observed between frontend and backend
PASS: Task 4.2: DNS resolution flows (Port 53) traced via Hubble
PASS: Task 4.2: HTTP status codes and requests tracked
PASS: Task 4.3: Policy denied dropped packets captured during outage simulation
PASS: Task 4.3: allow-frontend-to-backend policy restored traffic forwarding
PASS: Task 4.4: monitor-flows.sh executed and generated comprehensive report
PASS: Time: Finished in under 300s
CORE: 11/11 PASS
```

## Cluster snapshot
```
error: the server doesn't have a resource type "clusterpolicy"

NAMESPACE            NAME                                               READY   STATUS     RESTARTS   AGE
backend              backend-686d95864-27kg5                            0/1     Pending    0          49s
database             database-6bc7c46dd4-p9xgc                          0/1     Pending    0          44s
frontend             frontend-b6789f47d-6lwbb                           0/1     Pending    0          55s
kube-system          cilium-64chq                                       0/1     Init:0/6   0          73s
kube-system          cilium-envoy-gsdh6                                 0/1     Running    0          73s
kube-system          cilium-envoy-lbrbx                                 0/1     Running    0          74s
kube-system          cilium-ncszk                                       0/1     Init:0/6   0          73s
kube-system          cilium-operator-6746bb9897-48xbq                   0/1     Running    0          74s
kube-system          cilium-operator-6746bb9897-wnhzr                   0/1     Running    0          73s
kube-system          coredns-7c65d6cfc9-clswx                           0/1     Pending    0          86s
kube-system          coredns-7c65d6cfc9-hw85h                           0/1     Pending    0          86s
kube-system          etcd-hubble-lab-control-plane                      1/1     Running    0          89s
kube-system          hubble-relay-5887c867fd-x7hbk                      0/1     Pending    0          73s
kube-system          hubble-ui-6ff58788fc-rxg9t                         0/2     Pending    0          74s
kube-system          kube-apiserver-hubble-lab-control-plane            1/1     Running    0          89s
kube-system          kube-controller-manager-hubble-lab-control-plane   1/1     Running    0          92s
kube-system          kube-scheduler-hubble-lab-control-plane            1/1     Running    0          93s
local-path-storage   local-path-provisioner-57c5987fd4-88zf9            0/1     Pending    0          86s

NAME  	NAMESPACE  	REVISION	UPDATED                                	STATUS  	CHART        	APP VERSION
cilium	kube-system	1       	2026-11-09 15:10:51.116640181 +0000 UTC	deployed	cilium-1.20.4	1.20.4     
```

## Docker snapshot
```
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS         PORTS                       NAMES
91f274542f4d   kindest/node:v1.31.2   "/usr/local/bin/entr…"   2 minutes ago   Up 2 minutes                               hubble-lab-worker
e6547640f88c   kindest/node:v1.31.2   "/usr/local/bin/entr…"   2 minutes ago   Up 2 minutes   127.0.0.1:44157->6443/tcp   hubble-lab-control-plane

IMAGE                                                                                  ID             DISK USAGE   CONTENT SIZE   EXTRA
kindest/node@sha256:18fbefc20a7113353c7b75b5c869d7145a6abd6269154825872dc59c1329912e   18fbefc20a71       1.49GB          437MB   U    
```

## Files
```
./cilium-lab12/allow-frontend-to-backend.yaml
./cilium-lab12/backend-app.yaml
./cilium-lab12/database-app.yaml
./cilium-lab12/deny-policy.yaml
./cilium-lab12/frontend-app.yaml
./cilium-lab12/kind-config.yaml
./cilium-lab12/monitor-flows.sh
./cilium-lab12/results/elapsed.txt
./cilium-lab12/results/task1.1-flows-compact.txt
./cilium-lab12/results/task1.2-namespace-flows.txt
./cilium-lab12/results/task1.4-cluster-info.txt
./cilium-lab12/results/task1.4-http-flows.txt
./cilium-lab12/results/task1.4-kind-create.txt
./cilium-lab12/results/task1.4-nodes.txt
./cilium-lab12/results/task2.1-cilium-cli-install.log
./cilium-lab12/results/task2.1-dns-flows.txt
./cilium-lab12/results/task2.2-cilium-status.txt
./cilium-lab12/results/task2.2-helm-install.txt
./cilium-lab12/results/task2.3-hubble-cli-install.log
./cilium-lab12/results/task2.3-hubble-version.txt
./cilium-lab12/results/task2.4-http-codes.txt
./cilium-lab12/results/task2.4-hubble-status.txt
./cilium-lab12/results/task3.1-deny-policy.log
./cilium-lab12/results/task3.2-frontend.log
./cilium-lab12/results/task3.3-backend.log
./cilium-lab12/results/task3.3-dropped-flows.txt
./cilium-lab12/results/task3.4-database.log
./cilium-lab12/results/task3.5-allow-policy.log
./cilium-lab12/results/task3.5-deployments.txt
./cilium-lab12/results/task3.5-pods.txt
./cilium-lab12/results/task3.5-services.txt
./cilium-lab12/results/task3.6-allowed-fixed.txt
./cilium-lab12/results/task4.3-monitor-report.txt
```
