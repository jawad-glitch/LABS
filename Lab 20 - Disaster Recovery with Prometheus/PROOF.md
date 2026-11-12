# Lab 20 - Disaster Recovery with Prometheus - completion proof
Completed (UTC): 2026-11-12 09:16:59 | EC2: i-0c7dd26d873d53570 | host: ip-172-31-10-140 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 20 - Disaster Recovery with Prometheus, 2026-11-12 09:16:54 UTC) ==========
PASS: Kind cluster & MinIO operational
PASS: Prometheus & Thanos Sidecar running
PASS: Thanos Query & Store Gateway healthy
PASS: Prometheus successfully recovered after disaster deletion
PASS: Thanos Query successfully serving metrics post-recovery
CORE: 5/5 PASS
```

## Cluster snapshot
```
error: the server doesn't have a resource type "clusterpolicy"

NAMESPACE            NAME                                                  READY   STATUS    RESTARTS   AGE
kube-system          coredns-5d78c9869d-jjlw7                              1/1     Running   0          12m
kube-system          coredns-5d78c9869d-zhj54                              1/1     Running   0          12m
kube-system          etcd-prometheus-dr-control-plane                      1/1     Running   0          12m
kube-system          kindnet-7fcwf                                         1/1     Running   0          12m
kube-system          kube-apiserver-prometheus-dr-control-plane            1/1     Running   0          12m
kube-system          kube-controller-manager-prometheus-dr-control-plane   1/1     Running   0          12m
kube-system          kube-proxy-g9f5c                                      1/1     Running   0          12m
kube-system          kube-scheduler-prometheus-dr-control-plane            1/1     Running   0          12m
local-path-storage   local-path-provisioner-6bc4bddd6b-4jlw6               1/1     Running   0          12m
minio                minio-67966cdb5b-58wv9                                1/1     Running   0          41s
monitoring           prometheus-0                                          2/2     Running   0          19s
monitoring           sample-app-6fb6d65db4-dp9hh                           1/1     Running   0          41s
thanos               thanos-query-6889577844-nv26w                         1/1     Running   0          40s
thanos               thanos-store-67cffcddd5-slc5q                         1/1     Running   0          40s

NAME	NAMESPACE	REVISION	UPDATED	STATUS	CHART	APP VERSION
```

## Docker snapshot
```
CONTAINER ID   IMAGE                  COMMAND                  CREATED          STATUS          PORTS                                                                                                                           NAMES
9e1892a5375d   kindest/node:v1.27.3   "/usr/local/bin/entr…"   13 minutes ago   Up 13 minutes   127.0.0.1:46535->6443/tcp, 0.0.0.0:9090->30090/tcp, 0.0.0.0:9091->30091/tcp, 0.0.0.0:9092->30092/tcp, 0.0.0.0:9093->30093/tcp   prometheus-dr-control-plane

IMAGE                                                                                  ID             DISK USAGE   CONTENT SIZE   EXTRA
kindest/node@sha256:3966ac761ae0136263ffdb6cfd4db23ef8a83cba8a463690e98317add2c9ba72   3966ac761ae0       1.38GB          428MB   U    
quay.io/prometheus/node-exporter:v1.6.1                                                81f94e50ea37       37.4MB         11.7MB        
quay.io/prometheus/prometheus:v2.45.0                                                  9309deb7c981        334MB         93.7MB        
quay.io/thanos/thanos:v0.32.0                                                          f725f038fab9        260MB           80MB        
```

## Files
```
./prometheus-dr-lab/results/continuity-report.txt
./prometheus-dr-lab/results/thanos-query-result.json
./prometheus-dr-lab/thanos-bucket-config.yaml
./prometheus-dr-lab/verify_data_continuity.sh
```
