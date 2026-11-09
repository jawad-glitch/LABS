# Lab 3 - Validate Cilium Installation - completion proof
Completed (UTC): 2026-11-09 14:22:01 | EC2: i-05bc4bd707e0742d5 | host: ip-172-31-10-11 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 3 - Validate Cilium Installation, 2026-11-09 14:21:55 UTC) ==========
PASS: Setup: 2-node kind (no default CNI) + Cilium 1.20.4 via Helm; cilium status --wait OK
PASS: Task 1.1/1.3: 2 agent pods Running 1/1; DaemonSet DESIRED=CURRENT=READY=2
FAIL: Task 2.1: cilium status - Cilium OK, Operator OK (Hubble Relay disabled by default, not OK as lab expects)
PASS: Task 2.3: cilium connectivity test (no-policies, concurrency 1) all tests successful
PASS: Task 3.1/3.4: cilium_host, cilium_net, cilium_vxlan and lxc* interfaces exist (agent pod + kind node netns)
PASS: Lab bug: EC2 host shows 0 cilium/lxc interfaces - they live inside the kind node namespace
FAIL: Task 3.2: ipam=kubernetes, enable-ipv4=true, tunnel routing (cilium config view); in-pod cilium config fails (renamed cilium-dbg)
FAIL: Task 3.3: cilium-dbg endpoint list - all endpoints ready (lab cilium endpoint list fails)
PASS: Task 4: operator Running, Cilium CRDs installed, both nodes registered as CiliumNodes
PASS: Task 5.1: agent metrics served on node:9962 (1239 cilium_* samples, prometheus.enabled fix)
PASS: Task 5.2: DNS resolves kubernetes.default via CoreDNS; cross-node pod ping over cilium_vxlan 0% loss
FAIL: Time: lab finished in 318s (<= 300s)
CORE: 8/12 PASS
```

## Cluster snapshot
```
error: the server doesn't have a resource type "clusterpolicy"

NAMESPACE            NAME                                               READY   STATUS        RESTARTS   AGE
cilium-test-1        client-867c5c9785-rvfg5                            1/1     Running       0          70s
cilium-test-1        client2-6cd77948c8-qn5hg                           1/1     Running       0          70s
cilium-test-1        echo-same-node-86cb7b8d46-nlqp4                    2/2     Running       0          70s
cilium-test-1        l7-lb-84b789556f-pswh4                             2/2     Running       0          68s
cilium-test-ccnp1    client-ccnp-5b864f656f-6ndzm                       1/1     Running       0          69s
cilium-test-ccnp2    client-ccnp-5b864f656f-7drkk                       1/1     Running       0          69s
default              xnode-control-plane                                1/1     Terminating   0          14s
default              xnode-worker                                       1/1     Terminating   0          14s
kube-system          cilium-envoy-mnk9d                                 1/1     Running       0          2m42s
kube-system          cilium-envoy-pd2s7                                 1/1     Running       0          2m42s
kube-system          cilium-operator-77b647479f-66h7h                   1/1     Running       0          2m42s
kube-system          cilium-tzjlh                                       1/1     Running       0          2m42s
kube-system          cilium-zsjq2                                       1/1     Running       0          2m42s
kube-system          coredns-559f6c778d-7z6rb                           1/1     Running       0          4m2s
kube-system          coredns-559f6c778d-bkp4c                           1/1     Running       0          4m2s
kube-system          etcd-cilium-lab-control-plane                      1/1     Running       0          4m11s
kube-system          kube-apiserver-cilium-lab-control-plane            1/1     Running       0          4m9s
kube-system          kube-controller-manager-cilium-lab-control-plane   1/1     Running       0          4m9s
kube-system          kube-proxy-82dmm                                   1/1     Running       0          4m
kube-system          kube-proxy-gxd4f                                   1/1     Running       0          4m3s
kube-system          kube-scheduler-cilium-lab-control-plane            1/1     Running       0          4m9s
local-path-storage   local-path-provisioner-75f7fc7dc5-kcp5z            1/1     Running       0          4m2s

NAME  	NAMESPACE  	REVISION	UPDATED                                	STATUS  	CHART        	APP VERSION
cilium	kube-system	1       	2026-11-09 14:19:16.200207686 +0000 UTC	deployed	cilium-1.20.4	1.20.4     
```

## Docker snapshot
```
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS         PORTS                       NAMES
61c11cee34a4   kindest/node:v1.37.0   "/usr/local/bin/entr…"   4 minutes ago   Up 4 minutes                               cilium-lab-worker
ab3081a2666c   kindest/node:v1.37.0   "/usr/local/bin/entr…"   4 minutes ago   Up 4 minutes   127.0.0.1:33781->6443/tcp   cilium-lab-control-plane

IMAGE                                                                                     ID             DISK USAGE   CONTENT SIZE   EXTRA
busybox:1.36                                                                              73aaf090f3d8       6.76MB         2.21MB        
kindest/node@sha256:a1ed56cfb0e7b93589bdf97c8cd566405a265939e3620fc4f5de89adff580ae5      a1ed56cfb0e7       1.34GB          388MB   U    
quay.io/cilium/alpine-curl:v1.10.0                                                        913e8c9f3d96       36.9MB           11MB        
quay.io/cilium/cilium-envoy:v1.39.5-1792733054-8c73b2816bc8239e27f1fd53b271884688137459   547ab45f6092        290MB         78.3MB        
quay.io/cilium/cilium:v1.20.4                                                             20fe92e4c866        999MB          256MB        
quay.io/cilium/json-mock:v1.4.1                                                           6a66df90808a        433MB          102MB        
quay.io/cilium/operator-generic:v1.20.4                                                   7a7a3489dc66        165MB         36.9MB        
registry.k8s.io/coredns/coredns:v1.14.7                                                   7efd3c635b03        106MB         24.3MB        
```

## Files
```
./cilium-lab3/kind-config.yaml
./cilium-lab3/results/agent-logs.txt
./cilium-lab3/results/bug-ec2-host-interfaces.txt
./cilium-lab3/results/bug-lab-in-pod-cilium-config.txt
./cilium-lab3/results/bug-lab-in-pod-cilium-endpoint.txt
./cilium-lab3/results/elapsed.txt
./cilium-lab3/results/helm-install.txt
./cilium-lab3/results/image-pull.log
./cilium-lab3/results/install-cilium-cli.log
./cilium-lab3/results/install-helm.log
./cilium-lab3/results/install-kind.log
./cilium-lab3/results/install-kubectl.log
./cilium-lab3/results/kind-create.txt
./cilium-lab3/results/kind-load.txt
./cilium-lab3/results/preloaded-images.txt
./cilium-lab3/results/task1.1-cilium-pods.txt
./cilium-lab3/results/task1.2-describe-cilium-pods.txt
./cilium-lab3/results/task1.3-daemonset.txt
./cilium-lab3/results/task2.1-cilium-status.txt
./cilium-lab3/results/task2.2-cilium-status-wait.txt
./cilium-lab3/results/task2.3-connectivity-test.txt
./cilium-lab3/results/task3.1-agent-pod-interfaces.txt
./cilium-lab3/results/task3.1-pod.txt
./cilium-lab3/results/task3.2-cilium-config-view.txt
./cilium-lab3/results/task3.2-key-settings.txt
./cilium-lab3/results/task3.2-node-podcidrs.txt
./cilium-lab3/results/task3.3-endpoint-list.txt
./cilium-lab3/results/task3.4-cilium-ifaces.txt
./cilium-lab3/results/task3.4-kind-node-interfaces.txt
./cilium-lab3/results/task4.1-operator-logs.txt
./cilium-lab3/results/task4.1-operator-pods.txt
./cilium-lab3/results/task4.2-crds.txt
./cilium-lab3/results/task4.3-ciliumnodes.txt
./cilium-lab3/results/task5-cross-node-ping.txt
./cilium-lab3/results/task5-test-pods.txt
./cilium-lab3/results/task5.1-metrics-head.txt
./cilium-lab3/results/task5.2-dns.txt
./cilium-lab3/results/troubleshoot-cni-config-in-node.txt
./cilium-lab3/results/troubleshoot-kernel.txt
./cilium-lab3/results/versions.txt
```
