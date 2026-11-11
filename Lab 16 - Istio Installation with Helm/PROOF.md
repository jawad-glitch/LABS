# Lab 16 - Istio Installation with Helm - completion proof
Completed (UTC): 2026-11-11 15:37:38 | EC2: i-02b922e9648548fae | host: ip-172-31-10-9 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 16 - Istio Installation with Helm, 2026-11-11 15:37:29 UTC) ==========
PASS: Task 1: Kubernetes running with nodes ready
PASS: Task 2: Istio Helm repo added and accessible
FAIL: Task 3: istio-base chart deployed via Helm
PASS: Task 4: istiod control plane deployed and Running
PASS: Task 5: istio-ingressgateway deployed via Helm
PASS: Task 6: Sidecar proxy successfully injected (2 containers in test pod)
PASS: Task 7: Gateway and Telemetry resources created
PASS: Task 8: Bookinfo application and routing rules deployed
FAIL: Task 9: Service mesh request to productpage returns HTTP 200
FAIL: Task 10: Istiod upgraded with Helm revision history >= 2
PASS: Time: Execution completed within 420 seconds
CORE: 8/11 PASS
```

## Cluster snapshot
```
error: the server doesn't have a resource type "clusterpolicy"

NAMESPACE            NAME                                               READY   STATUS    RESTARTS   AGE
bookinfo             details-v1-698d88b-b2dbd                           2/2     Running   0          2m27s
bookinfo             productpage-v1-675fc69cf-67mtm                     2/2     Running   0          2m26s
bookinfo             ratings-v1-6484c4d9bb-kznk6                        2/2     Running   0          2m27s
bookinfo             reviews-v1-5b5d6494f4-snj8g                        2/2     Running   0          2m26s
bookinfo             reviews-v2-5b667bcbf8-lmn7j                        2/2     Running   0          2m26s
bookinfo             reviews-v3-5b9bd44f4-n9ckb                         2/2     Running   0          2m26s
istio-system         istio-ingressgateway-84df8b89c4-6f9lk              1/1     Running   0          2m43s
istio-system         istiod-b56584994-zghnt                             1/1     Running   0          20s
kube-system          coredns-76f75df574-4gfqp                           1/1     Running   0          3m17s
kube-system          coredns-76f75df574-schvc                           1/1     Running   0          3m17s
kube-system          etcd-istio-helm-control-plane                      1/1     Running   0          3m33s
kube-system          kindnet-b29dh                                      1/1     Running   0          3m17s
kube-system          kube-apiserver-istio-helm-control-plane            1/1     Running   0          3m33s
kube-system          kube-controller-manager-istio-helm-control-plane   1/1     Running   0          3m33s
kube-system          kube-proxy-t4sdt                                   1/1     Running   0          3m17s
kube-system          kube-scheduler-istio-helm-control-plane            1/1     Running   0          3m33s
local-path-storage   local-path-provisioner-7577fdbbfb-hdzj2            1/1     Running   0          3m17s
test-injection       nginx-7fcd5b7c79-75crd                             2/2     Running   0          2m36s

NAME                	NAMESPACE   	REVISION	UPDATED                                	STATUS  	CHART         	APP VERSION
istio-base          	istio-system	1       	2026-11-11 15:34:36.9129345 +0000 UTC  	deployed	base-1.30.8   	1.30.8     
istio-ingressgateway	istio-system	1       	2026-11-11 15:34:55.91716943 +0000 UTC 	deployed	gateway-1.30.8	1.30.8     
istiod              	istio-system	2       	2026-11-11 15:37:13.663537944 +0000 UTC	deployed	istiod-1.30.8 	1.30.8     
```

## Docker snapshot
```
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS         PORTS                       NAMES
ceddec2b11e1   kindest/node:v1.29.2   "/usr/local/bin/entr…"   4 minutes ago   Up 4 minutes   127.0.0.1:38551->6443/tcp   istio-helm-control-plane

IMAGE                                                                                  ID             DISK USAGE   CONTENT SIZE   EXTRA
kindest/node@sha256:51a1434a5397193442f0be2a297b488b6c919ce8a3931be0ce822606ea5ca245   51a1434a5397       1.39GB          409MB   U    
```

## Files
```
./istio-lab16/bookinfo-destination-rule.yaml
./istio-lab16/bookinfo-virtualservice.yaml
./istio-lab16/gateway-values.yaml
./istio-lab16/istio-gateway.yaml
./istio-lab16/istio-helm-architecture-report.txt
./istio-lab16/istiod-values.yaml
./istio-lab16/results/elapsed.txt
./istio-lab16/results/k8s-start.log
./istio-lab16/results/task1.1-cluster-info.txt
./istio-lab16/results/task1.1-nodes.txt
./istio-lab16/results/task10.2-helm-upgrade.txt
./istio-lab16/results/task10.2-istiod-history.txt
./istio-lab16/results/task2.1-helm-version.txt
./istio-lab16/results/task2.2-repo-list.txt
./istio-lab16/results/task2.2-search-repo.txt
./istio-lab16/results/task3.2-helm-base.txt
./istio-lab16/results/task3.2-helm-list-base.txt
./istio-lab16/results/task4.2-helm-istiod.txt
./istio-lab16/results/task4.2-istiod-pods.txt
./istio-lab16/results/task4.2-istiod-svc.txt
./istio-lab16/results/task5.2-gateway-pods.txt
./istio-lab16/results/task5.2-gateway-svc.txt
./istio-lab16/results/task5.2-helm-gateway.txt
./istio-lab16/results/task6.1-all-resources.txt
./istio-lab16/results/task6.1-helm-releases.txt
./istio-lab16/results/task6.2-istioctl-analyze.txt
./istio-lab16/results/task6.2-istioctl-version.txt
./istio-lab16/results/task6.3-injection-pods.txt
./istio-lab16/results/task7-crds.txt
./istio-lab16/results/task7.1-gateway.txt
./istio-lab16/results/task7.2-telemetry.txt
./istio-lab16/results/task8.1-bookinfo-status.txt
./istio-lab16/results/task8.2-dr.txt
./istio-lab16/results/task8.2-vs.txt
./istio-lab16/results/task9.1-proxy-clusters.txt
./istio-lab16/results/task9.1-proxy-status.txt
./istio-lab16/results/task9.2-traffic-result.txt
./istio-lab16/telemetry-config.yaml
./istio-lab16/updated-istiod-values.yaml
```
