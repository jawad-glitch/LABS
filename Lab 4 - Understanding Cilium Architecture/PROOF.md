# Lab 4 - Understanding Cilium Architecture - completion proof
Completed (UTC): 2026-11-09 14:36:48 | EC2: i-089cbca21bd1378c8 | host: ip-172-31-10-237 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 4 - Understanding Cilium Architecture, 2026-11-09 14:36:41 UTC) ==========
PASS: Setup: 2-node kind without kube-proxy; Cilium 1.20.4 (KPR + Hubble relay/UI) via Helm; cilium status --wait OK
FAIL: Task 1: cilium/hubble CLIs installed (sha256); status shows Cilium OK, Operator OK, Hubble Relay OK; verbose captured
FAIL: Task 2: data plane read from agent via cilium-dbg (endpoints, BPF LB, policy); lab host cilium endpoint list fails
PASS: Task 3.1: hubble-relay + hubble-ui Running; relay config is hubble-relay-config (lab hubble-config does not exist)
PASS: Task 3.2-3.4: hubble CLI v1.20.4, Hubble UI HTTP 200, hubble status healthy via relay
FAIL: Task 4.1: KubeProxyReplacement True, 0 kube-proxy pods (lab never enabled KPR)
FAIL: Task 4.2/4.3: test-app ClusterIP 10.96.245.213 in eBPF service table with 3 backends; client got nginx 20/20
FAIL: Task 4.3 (Hubble): service traffic spread across 0 distinct test-app backends
PASS: Task 5.3: cross-namespace ping 0% loss; Hubble shows 1 flows test-ns-1/pod-1 -> test-ns-2/pod-2
FAIL: Task 5.1/5.2: connectivity test (no-policies) successful; test namespace is cilium-test-1 (not cilium-test)
FAIL: Task 6: architecture report generated with working commands (status, config view, hubble, cilium-dbg services/policy)
FAIL: Time: lab finished in 737s (<= 300s)
CORE: 4/12 PASS
```

## Cluster snapshot
```
error: the server doesn't have a resource type "clusterpolicy"

NAMESPACE            NAME                                               READY   STATUS        RESTARTS   AGE
cilium-test-1        client-867c5c9785-4nchh                            0/1     Completed     0          4m40s
cilium-test-1        client2-6cd77948c8-g4bvn                           0/1     Completed     0          4m40s
cilium-test-1        echo-same-node-56ff8dc794-b5pkm                    0/2     Error         0          4m40s
cilium-test-1        l7-lb-84b789556f-lds7w                             0/2     Completed     0          4m39s
cilium-test-ccnp1    client-ccnp-5b864f656f-stz5q                       0/1     Completed     0          4m40s
cilium-test-ccnp2    client-ccnp-5b864f656f-4rg4c                       0/1     Completed     0          4m39s
kube-system          cilium-envoy-8fr4g                                 1/1     Running       0          8m12s
kube-system          cilium-envoy-wjml7                                 1/1     Running       0          8m13s
kube-system          cilium-operator-85b6b5bb87-mjk9x                   1/1     Running       0          8m13s
kube-system          cilium-rvz4m                                       1/1     Running       0          8m13s
kube-system          cilium-wgqpl                                       1/1     Running       0          8m12s
kube-system          coredns-559f6c778d-8zhm7                           1/1     Running       0          10m
kube-system          coredns-559f6c778d-ww9c8                           1/1     Running       0          10m
kube-system          etcd-cilium-lab-control-plane                      1/1     Running       0          10m
kube-system          hubble-relay-59bb8bbb55-wtnh6                      1/1     Running       0          8m13s
kube-system          hubble-ui-647df7f64c-t56zx                         2/2     Running       0          8m13s
kube-system          kube-apiserver-cilium-lab-control-plane            1/1     Running       0          10m
kube-system          kube-controller-manager-cilium-lab-control-plane   1/1     Running       0          10m
kube-system          kube-scheduler-cilium-lab-control-plane            1/1     Running       0          10m
local-path-storage   local-path-provisioner-75f7fc7dc5-nk6qf            1/1     Running       0          10m
test-ns-1            pod-1                                              1/1     Terminating   0          110s
test-ns-2            pod-2                                              1/1     Terminating   0          109s

NAME  	NAMESPACE  	REVISION	UPDATED                                	STATUS  	CHART        	APP VERSION
cilium	kube-system	1       	2026-11-09 14:28:32.902026465 +0000 UTC	deployed	cilium-1.20.4	1.20.4     
```

## Docker snapshot
```
CONTAINER ID   IMAGE                  COMMAND                  CREATED          STATUS          PORTS                       NAMES
af586fa3289e   kindest/node:v1.37.0   "/usr/local/bin/entr…"   12 minutes ago   Up 11 minutes   127.0.0.1:39123->6443/tcp   cilium-lab-control-plane
ddb13d716af0   kindest/node:v1.37.0   "/usr/local/bin/entr…"   12 minutes ago   Up 11 minutes                               cilium-lab-worker

IMAGE                                                                                     ID             DISK USAGE   CONTENT SIZE   EXTRA
busybox:1.36                                                                              73aaf090f3d8       6.76MB         2.21MB        
kindest/node@sha256:a1ed56cfb0e7b93589bdf97c8cd566405a265939e3620fc4f5de89adff580ae5      a1ed56cfb0e7       1.34GB          388MB   U    
nginx:1.27-alpine                                                                         65645c7bb6a0       74.5MB         21.9MB        
quay.io/cilium/alpine-curl:v1.10.0                                                        913e8c9f3d96       36.9MB           11MB        
quay.io/cilium/cilium-envoy:v1.39.5-1792733054-8c73b2816bc8239e27f1fd53b271884688137459   547ab45f6092        290MB         78.3MB        
quay.io/cilium/cilium:v1.20.4                                                             20fe92e4c866        999MB          256MB        
quay.io/cilium/hubble-relay:v1.20.4                                                       cb2340820969        109MB         24.4MB        
quay.io/cilium/hubble-ui-backend:v0.13.6                                                  83b3fc763f3d       99.1MB         22.2MB        
quay.io/cilium/hubble-ui:v0.13.6                                                          049a80a03585       48.2MB         11.5MB        
quay.io/cilium/json-mock:v1.4.1                                                           6a66df90808a        433MB          102MB        
quay.io/cilium/operator-generic:v1.20.4                                                   7a7a3489dc66        165MB         36.9MB        
registry.k8s.io/coredns/coredns:v1.14.7                                                   7efd3c635b03        106MB         24.3MB        
```

## Files
```
./cilium-lab4/cilium-architecture-report.txt
./cilium-lab4/kind-config.yaml
./cilium-lab4/results/bug-lab-host-cilium-commands.txt
./cilium-lab4/results/bug-lab-hubble-config-cm.txt
./cilium-lab4/results/elapsed.txt
./cilium-lab4/results/helm-install.txt
./cilium-lab4/results/hubble-relay-pf.log
./cilium-lab4/results/hubble-ui-pf.log
./cilium-lab4/results/image-pull.log
./cilium-lab4/results/install-helm.log
./cilium-lab4/results/install-kind.log
./cilium-lab4/results/install-kubectl.log
./cilium-lab4/results/kind-create.txt
./cilium-lab4/results/kind-load.txt
./cilium-lab4/results/preloaded-images.txt
./cilium-lab4/results/status-wait.txt
./cilium-lab4/results/task1.1-pods.txt
./cilium-lab4/results/task1.2-install-cilium-cli.log
./cilium-lab4/results/task1.3-cilium-status-verbose.txt
./cilium-lab4/results/task1.3-cilium-status.txt
./cilium-lab4/results/task2.1-agent-logs.txt
./cilium-lab4/results/task2.1-config-view.txt
./cilium-lab4/results/task2.1-ds-describe.txt
./cilium-lab4/results/task2.2-operator.txt
./cilium-lab4/results/task2.3-bpf-lb-list.txt
./cilium-lab4/results/task2.3-endpoint-list.txt
./cilium-lab4/results/task2.3-policy-get.txt
./cilium-lab4/results/task3.1-cilium-hubble-status.txt
./cilium-lab4/results/task3.1-hubble-pods.txt
./cilium-lab4/results/task3.1-hubble-relay-config.yaml
./cilium-lab4/results/task3.2-hubble-version.txt
./cilium-lab4/results/task3.2-install-hubble-cli.log
./cilium-lab4/results/task3.3-hubble-ui.html
./cilium-lab4/results/task3.4-hubble-observe-last20.txt
./cilium-lab4/results/task3.4-hubble-status.txt
./cilium-lab4/results/task4.1-kpr-config.txt
./cilium-lab4/results/task4.1-kpr.txt
./cilium-lab4/results/task4.1-kube-proxy-pods.txt
./cilium-lab4/results/task4.2-bpf-endpoint-list.txt
./cilium-lab4/results/task4.2-service-list.txt
./cilium-lab4/results/task4.3-backends-hit.txt
./cilium-lab4/results/task4.3-client.txt
./cilium-lab4/results/task4.3-service.txt
./cilium-lab4/results/task4.3-test-app-lb.txt
./cilium-lab4/results/task5.1-connectivity-test.txt
./cilium-lab4/results/task5.2-test-namespaces.txt
./cilium-lab4/results/task5.3-hubble-flows.txt
./cilium-lab4/results/task5.3-ping.txt
./cilium-lab4/results/task6.2-events.txt
./cilium-lab4/results/versions.txt
```
