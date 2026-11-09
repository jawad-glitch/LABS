# Lab 13 - Debugging with Cilium Flow Visibility - completion proof
Completed (UTC): 2026-11-09 15:18:19 | EC2: i-00d62fb22ad798505 | host: ip-172-31-10-101 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 13 - Debugging with Cilium Flow Visibility, 2026-11-09 15:18:10 UTC) ==========
PASS: Task 1: Kind cluster cilium-debug-lab initialized and Cilium status verified
PASS: Task 1: Hubble CLI installed and connectivity confirmed
PASS: Task 2: Applications deployed (frontend, backend, test-client)
PASS: Task 2: Restrictive deny-all network policy created
PASS: Task 3: Real-time flow observation recorded dropped packets
PASS: Task 4: Root cause diagnosis report documented
FAIL: Task 5: Corrected policy backend-allow-frontend applied
PASS: Task 6: Connectivity test confirmed all communications operational
PASS: Task 7: Comprehensive monitoring report generated
PASS: Time: Finished in under 300s
CORE: 9/10 PASS
```

## Cluster snapshot
```
error: the server doesn't have a resource type "clusterpolicy"

NAMESPACE            NAME                                                     READY   STATUS     RESTARTS   AGE
default              backend-app-5f654d894b-dfwld                             0/1     Pending    0          68s
default              backend-app-5f654d894b-pxbb5                             0/1     Pending    0          67s
default              frontend-app-7ccb748546-mgs85                            0/1     Pending    0          71s
default              frontend-app-7ccb748546-wnfmn                            0/1     Pending    0          71s
default              test-client                                              0/1     Pending    0          59s
kube-system          cilium-cw945                                             0/1     Init:0/6   0          82s
kube-system          cilium-envoy-9fl6m                                       0/1     Running    0          82s
kube-system          cilium-envoy-cfvcz                                       0/1     Running    0          82s
kube-system          cilium-envoy-zstp7                                       0/1     Running    0          82s
kube-system          cilium-operator-6746bb9897-cwzmw                         0/1     Running    0          82s
kube-system          cilium-operator-6746bb9897-hxrt6                         0/1     Running    0          81s
kube-system          cilium-qg9l7                                             0/1     Init:0/6   0          82s
kube-system          cilium-xkl8b                                             0/1     Init:0/6   0          82s
kube-system          coredns-7c65d6cfc9-dmjn2                                 0/1     Pending    0          102s
kube-system          coredns-7c65d6cfc9-t4cck                                 0/1     Pending    0          102s
kube-system          etcd-cilium-debug-lab-control-plane                      1/1     Running    0          105s
kube-system          hubble-relay-5887c867fd-6zmcw                            0/1     Pending    0          82s
kube-system          hubble-ui-6ff58788fc-8kgjn                               0/2     Pending    0          82s
kube-system          kube-apiserver-cilium-debug-lab-control-plane            1/1     Running    0          105s
kube-system          kube-controller-manager-cilium-debug-lab-control-plane   1/1     Running    0          105s
kube-system          kube-scheduler-cilium-debug-lab-control-plane            1/1     Running    0          105s
local-path-storage   local-path-provisioner-57c5987fd4-jrf45                  0/1     Pending    0          102s

NAME  	NAMESPACE  	REVISION	UPDATED                                	STATUS  	CHART        	APP VERSION
cilium	kube-system	1       	2026-11-09 15:16:54.375986194 +0000 UTC	deployed	cilium-1.20.4	1.20.4     
```

## Docker snapshot
```
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS         PORTS                       NAMES
f8ff0e0c66d2   kindest/node:v1.31.2   "/usr/local/bin/entr…"   2 minutes ago   Up 2 minutes                               cilium-debug-lab-worker
d4fd4c7c8e50   kindest/node:v1.31.2   "/usr/local/bin/entr…"   2 minutes ago   Up 2 minutes                               cilium-debug-lab-worker2
732c83351494   kindest/node:v1.31.2   "/usr/local/bin/entr…"   2 minutes ago   Up 2 minutes   127.0.0.1:37181->6443/tcp   cilium-debug-lab-control-plane

IMAGE                                                                                  ID             DISK USAGE   CONTENT SIZE   EXTRA
kindest/node@sha256:18fbefc20a7113353c7b75b5c869d7145a6abd6269154825872dc59c1329912e   18fbefc20a71       1.49GB          437MB   U    
```

## Files
```
./cilium-lab13/backend-app.yaml
./cilium-lab13/cilium-monitor.log
./cilium-lab13/connectivity-test.sh
./cilium-lab13/frontend-app.yaml
./cilium-lab13/kind-config.yaml
./cilium-lab13/monitoring-report.txt
./cilium-lab13/network-diagnosis-report.txt
./cilium-lab13/network-policy-fixed.yaml
./cilium-lab13/network-policy-restrictive.yaml
./cilium-lab13/results/elapsed.txt
./cilium-lab13/results/task1.1-kind-create.txt
./cilium-lab13/results/task1.1-nodes.txt
./cilium-lab13/results/task1.2-cilium-status.txt
./cilium-lab13/results/task1.2-cli-install.log
./cilium-lab13/results/task1.2-helm-install.txt
./cilium-lab13/results/task1.3-hubble-install.log
./cilium-lab13/results/task1.3-hubble-status.txt
./cilium-lab13/results/task2.1-frontend.log
./cilium-lab13/results/task2.2-backend.log
./cilium-lab13/results/task2.3-policy-restrictive.log
./cilium-lab13/results/task2.4-client.log
./cilium-lab13/results/task3.3-dropped-flows.txt
./cilium-lab13/results/task3.4-flow-stats.txt
./cilium-lab13/results/task4.3-diagnosis-report.txt
./cilium-lab13/results/task5.1-policy-fixed.log
./cilium-lab13/results/task6.2-connectivity-output.txt
./cilium-lab13/results/task7.3-monitoring-report.txt
./cilium-lab13/test-client.yaml
```
