# Lab 2 - Install Cilium using Helm - completion proof
Completed (UTC): 2026-11-09 14:06:59 | EC2: i-00e79d1a1b25b677f | host: ip-172-31-10-25 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 2 - Install Cilium using Helm, 2026-11-09 14:06:50 UTC) ==========
PASS: Tools: kind, kubectl, helm v3, cilium CLI v0.20.2 installed (sha256 verified)
FAIL: Task 1: cluster created without default CNI - node NotReady / CoreDNS not Running before Cilium
FAIL: Task 2: cilium repo added (https://helm.cilium.io/), versions listed incl. lab 1.11.0 and latest 1.20.4
PASS: Task 3: helm release cilium deployed with pinned current chart cilium-1.20.4 (not EOL 1.11.0)
PASS: Task 3.2/4.1/4.3: cilium status --wait OK - agent DaemonSet ready, operator available
PASS: Task 4.4: node Ready and CoreDNS Running now that Cilium provides the CNI
PASS: Task 4.5: pods got Cilium IPs in node PodCIDR 10.244.0.0/24; pod-to-pod ping 0% loss; CoreDNS resolves
FAIL: Lab bug: in-pod cilium status fails (binary renamed); cilium-dbg status reports OK
PASS: Task 5: agent logs + cilium-config (ipam=kubernetes) + services captured
PASS: Time: lab finished in 246s (<= 300s)
CORE: 7/10 PASS
```

## Cluster snapshot
```
error: the server doesn't have a resource type "clusterpolicy"

NAMESPACE            NAME                                               READY   STATUS        RESTARTS   AGE
default              test-pod                                           1/1     Terminating   0          20s
default              test-pod-2                                         1/1     Terminating   0          18s
kube-system          cilium-envoy-4mwv4                                 1/1     Running       0          107s
kube-system          cilium-operator-77b647479f-kvznm                   1/1     Running       0          107s
kube-system          cilium-slnz5                                       1/1     Running       0          107s
kube-system          coredns-559f6c778d-5d6cz                           1/1     Running       0          2m49s
kube-system          coredns-559f6c778d-66v5q                           1/1     Running       0          2m49s
kube-system          etcd-cilium-lab-control-plane                      1/1     Running       0          3m1s
kube-system          kube-apiserver-cilium-lab-control-plane            1/1     Running       0          3m1s
kube-system          kube-controller-manager-cilium-lab-control-plane   1/1     Running       0          3m1s
kube-system          kube-proxy-k4qjb                                   1/1     Running       0          2m49s
kube-system          kube-scheduler-cilium-lab-control-plane            1/1     Running       0          3m1s
local-path-storage   local-path-provisioner-75f7fc7dc5-qcb69            1/1     Running       0          2m49s

NAME  	NAMESPACE  	REVISION	UPDATED                                	STATUS  	CHART        	APP VERSION
cilium	kube-system	1       	2026-11-09 14:05:10.790247293 +0000 UTC	deployed	cilium-1.20.4	1.20.4     
```

## Docker snapshot
```
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS         PORTS                       NAMES
4238664c205a   kindest/node:v1.37.0   "/usr/local/bin/entr…"   3 minutes ago   Up 3 minutes   127.0.0.1:40395->6443/tcp   cilium-lab-control-plane

IMAGE                                                                                     ID             DISK USAGE   CONTENT SIZE   EXTRA
busybox:1.36                                                                              73aaf090f3d8       6.76MB         2.21MB        
kindest/node@sha256:a1ed56cfb0e7b93589bdf97c8cd566405a265939e3620fc4f5de89adff580ae5      a1ed56cfb0e7       1.34GB          388MB   U    
quay.io/cilium/cilium-envoy:v1.39.5-1792733054-8c73b2816bc8239e27f1fd53b271884688137459   547ab45f6092        290MB         78.3MB        
quay.io/cilium/cilium:v1.20.4                                                             20fe92e4c866        999MB          256MB        
quay.io/cilium/operator-generic:v1.20.4                                                   7a7a3489dc66        165MB         36.9MB        
```

## Files
```
./cilium-lab2/kind-config.yaml
./cilium-lab2/results/bug-lab-exec-cilium-status.txt
./cilium-lab2/results/elapsed.txt
./cilium-lab2/results/helm-template.err
./cilium-lab2/results/image-pull.log
./cilium-lab2/results/install-cilium-cli.log
./cilium-lab2/results/install-helm.log
./cilium-lab2/results/install-kind.log
./cilium-lab2/results/install-kubectl.log
./cilium-lab2/results/kind-load.txt
./cilium-lab2/results/lab-original-chart-1.11.0.txt
./cilium-lab2/results/task1-before-cni.txt
./cilium-lab2/results/task1-kind-create.txt
./cilium-lab2/results/task1.2-existing-cni.txt
./cilium-lab2/results/task1.3-helm-version.txt
./cilium-lab2/results/task2.1-repo-add.txt
./cilium-lab2/results/task2.2-repo-update.txt
./cilium-lab2/results/task2.3-repo-list.txt
./cilium-lab2/results/task2.4-all-versions.txt
./cilium-lab2/results/task3-images.txt
./cilium-lab2/results/task3.1-helm-install.txt
./cilium-lab2/results/task3.2-cilium-status-wait.txt
./cilium-lab2/results/task3.3-helm-list.txt
./cilium-lab2/results/task4-verify.txt
./cilium-lab2/results/task4.5-dns.txt
./cilium-lab2/results/task4.5-ips-in-podcidr.txt
./cilium-lab2/results/task4.5-ping-pod-to-pod.txt
./cilium-lab2/results/task4.5-test-pods.txt
./cilium-lab2/results/task4.6-cleanup.txt
./cilium-lab2/results/task5-cilium-dbg-status.txt
./cilium-lab2/results/task5-cilium-endpoints.txt
./cilium-lab2/results/task5.1-agent-logs.txt
./cilium-lab2/results/task5.2-cilium-config.yaml
./cilium-lab2/results/task5.3-services.txt
./cilium-lab2/results/versions.txt
```
