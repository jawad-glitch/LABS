# Lab 20 - Disaster Recovery with Prometheus - completion proof
Completed (UTC): 2026-11-12 09:11:10 | EC2: i-0c7dd26d873d53570 | host: ip-172-31-10-140 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 20 - Disaster Recovery with Prometheus, 2026-11-12 09:11:04 UTC) ==========
FAIL: Kind cluster & MinIO operational
FAIL: Prometheus & Thanos Sidecar running
PASS: Thanos Query & Store Gateway healthy
FAIL: Prometheus successfully recovered after disaster deletion
FAIL: Thanos Query successfully serving metrics post-recovery
CORE: 1/5 PASS
```

## Cluster snapshot
```
error: the server doesn't have a resource type "clusterpolicy"

NAMESPACE            NAME                                                  READY   STATUS              RESTARTS      AGE
kube-system          coredns-5d78c9869d-jjlw7                              1/1     Running             0             6m49s
kube-system          coredns-5d78c9869d-zhj54                              1/1     Running             0             6m49s
kube-system          etcd-prometheus-dr-control-plane                      1/1     Running             0             7m2s
kube-system          kindnet-7fcwf                                         1/1     Running             0             6m50s
kube-system          kube-apiserver-prometheus-dr-control-plane            1/1     Running             0             7m3s
kube-system          kube-controller-manager-prometheus-dr-control-plane   1/1     Running             0             7m4s
kube-system          kube-proxy-g9f5c                                      1/1     Running             0             6m50s
kube-system          kube-scheduler-prometheus-dr-control-plane            1/1     Running             0             7m2s
local-path-storage   local-path-provisioner-6bc4bddd6b-4jlw6               1/1     Running             0             6m49s
minio                minio-546b5f758c-n88pb                                0/1     ImagePullBackOff    0             70s
minio                minio-64dd4786c6-cl9c4                                0/1     ImagePullBackOff    0             6m43s
monitoring           prometheus-0                                          0/2     ContainerCreating   0             2m11s
thanos               thanos-query-58b8867b76-brsmn                         1/1     Running             0             58s
thanos               thanos-store-749d6b9cd5-8rhnm                         1/1     Running             1 (28s ago)   59s

NAME	NAMESPACE	REVISION	UPDATED	STATUS	CHART	APP VERSION
```

## Docker snapshot
```
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS         PORTS                                                                                                                           NAMES
9e1892a5375d   kindest/node:v1.27.3   "/usr/local/bin/entr…"   7 minutes ago   Up 7 minutes   127.0.0.1:46535->6443/tcp, 0.0.0.0:9090->30090/tcp, 0.0.0.0:9091->30091/tcp, 0.0.0.0:9092->30092/tcp, 0.0.0.0:9093->30093/tcp   prometheus-dr-control-plane

IMAGE                                                                                  ID             DISK USAGE   CONTENT SIZE   EXTRA
kindest/node@sha256:3966ac761ae0136263ffdb6cfd4db23ef8a83cba8a463690e98317add2c9ba72   3966ac761ae0       1.38GB          428MB   U    
```

## Files
```
./prometheus-dr-lab/results/cluster-info.log
./prometheus-dr-lab/results/kind-create.log
./prometheus-dr-lab/results/thanos-query-result.json
./prometheus-dr-lab/thanos-bucket-config.yaml
```
