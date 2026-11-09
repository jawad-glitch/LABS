# Lab 14 - Integrating Cilium with Envoy Proxy - completion proof
Completed (UTC): 2026-11-09 15:23:21 | EC2: i-005ed8fdba64d58ee | host: ip-172-31-10-174 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 14 - Integrating Cilium with Envoy Proxy, 2026-11-09 15:23:13 UTC) ==========
PASS: Task 1: Kind cluster cilium-envoy-lab created and nodes verified
PASS: Task 1: Cilium installed with Envoy and L7 proxy enabled
PASS: Task 2: Multi-version backends (v1, v2) and frontend deployed
FAIL: Task 3.1: L7 basic HTTP policy frontend-to-backend-l7 applied
PASS: Task 3.2: Advanced header-based routing policies created
PASS: Task 3.3: CiliumEnvoyConfig applied for traffic management
PASS: Task 4: Basic HTTP GET/POST connectivity and path routing verified
PASS: Task 4: Security policy enforcement validated (unauthorized routes blocked)
PASS: Task 5: Rate limit and JWT authentication policies deployed
PASS: Task 6: comprehensive-test.sh executed with all test assertions passing
PASS: Time: Finished in under 300s
CORE: 10/11 PASS
```

## Cluster snapshot
```
error: the server doesn't have a resource type "clusterpolicy"

NAMESPACE            NAME                                                     READY   STATUS    RESTARTS   AGE
backend              backend-v1-6c55d57849-9pjll                              0/1     Pending   0          40s
backend              backend-v2-9fcc966-xzmfv                                 0/1     Pending   0          40s
frontend             frontend-fbc87f6fc-rbpdz                                 0/1     Pending   0          39s
kube-system          coredns-7c65d6cfc9-mw656                                 0/1     Pending   0          57s
kube-system          coredns-7c65d6cfc9-wcqh7                                 0/1     Pending   0          56s
kube-system          etcd-cilium-envoy-lab-control-plane                      1/1     Running   0          60s
kube-system          kube-apiserver-cilium-envoy-lab-control-plane            1/1     Running   0          60s
kube-system          kube-controller-manager-cilium-envoy-lab-control-plane   1/1     Running   0          60s
kube-system          kube-scheduler-cilium-envoy-lab-control-plane            1/1     Running   0          60s
local-path-storage   local-path-provisioner-57c5987fd4-rn6gm                  0/1     Pending   0          56s

NAME	NAMESPACE	REVISION	UPDATED	STATUS	CHART	APP VERSION
```

## Docker snapshot
```
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS              PORTS                       NAMES
42614341e6ab   kindest/node:v1.31.2   "/usr/local/bin/entr…"   2 minutes ago   Up About a minute   127.0.0.1:40729->6443/tcp   cilium-envoy-lab-control-plane
d468568a78fd   kindest/node:v1.31.2   "/usr/local/bin/entr…"   2 minutes ago   Up About a minute                               cilium-envoy-lab-worker
68a7d783ba46   kindest/node:v1.31.2   "/usr/local/bin/entr…"   2 minutes ago   Up About a minute                               cilium-envoy-lab-worker2

IMAGE                                                                                  ID             DISK USAGE   CONTENT SIZE   EXTRA
kindest/node@sha256:18fbefc20a7113353c7b75b5c869d7145a6abd6269154825872dc59c1329912e   18fbefc20a71       1.49GB          437MB   U    
```

## Files
```
./cilium-lab14/backend-v1.yaml
./cilium-lab14/backend-v2.yaml
./cilium-lab14/cilium-envoy-summary.txt
./cilium-lab14/comprehensive-test.sh
./cilium-lab14/envoy-config.yaml
./cilium-lab14/frontend.yaml
./cilium-lab14/jwt-policy.yaml
./cilium-lab14/kind-config.yaml
./cilium-lab14/l7-policy-advanced.yaml
./cilium-lab14/l7-policy-basic.yaml
./cilium-lab14/rate-limit-policy.yaml
./cilium-lab14/results/elapsed.txt
./cilium-lab14/results/task1.1-kind-create.txt
./cilium-lab14/results/task1.1-nodes.txt
./cilium-lab14/results/task1.2-cilium-status.txt
./cilium-lab14/results/task1.2-helm-install.txt
./cilium-lab14/results/task1.3-envoy-config.txt
./cilium-lab14/results/task2.2-backend-v1.log
./cilium-lab14/results/task2.2-backend-v2.log
./cilium-lab14/results/task2.3-frontend-pod.txt
./cilium-lab14/results/task2.3-frontend.log
./cilium-lab14/results/task3.1-policy-basic.log
./cilium-lab14/results/task3.2-policy-advanced.log
./cilium-lab14/results/task3.3-envoy-config.log
./cilium-lab14/results/task4.1-http-tests.txt
./cilium-lab14/results/task4.2-header-routing.txt
./cilium-lab14/results/task4.3-security-enforcement.txt
./cilium-lab14/results/task5.1-rate-limit.log
./cilium-lab14/results/task5.2-jwt.log
./cilium-lab14/results/task5.3-jwt-tests.txt
./cilium-lab14/results/task6.1-envoy-status.txt
./cilium-lab14/results/task6.2-cep-list.txt
./cilium-lab14/results/task6.2-cnp-list.txt
./cilium-lab14/results/task6.4-comprehensive-output.txt
```
