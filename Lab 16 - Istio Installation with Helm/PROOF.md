# Lab 16 - Istio Installation with Helm - completion proof
Completed (UTC): 2026-11-11 15:31:06 | EC2: i-02b922e9648548fae | host: ip-172-31-10-9 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 16 - Istio Installation with Helm, 2026-11-11 15:30:59 UTC) ==========
PASS: Task 2: Istio Helm repo added and accessible
FAIL: Task 3: istio-base chart deployed via Helm
FAIL: Task 4: istiod control plane deployed and Running
FAIL: Task 5: istio-ingressgateway deployed via Helm
FAIL: Task 6: Sidecar proxy successfully injected (2 containers in test pod)
FAIL: Task 7: Gateway and Telemetry resources created
FAIL: Task 8: Bookinfo application and routing rules deployed
FAIL: Task 9: Service mesh request to productpage returns HTTP 200
FAIL: Task 10: Istiod upgraded with Helm revision history >= 2
PASS: Time: Execution completed within 360 seconds
CORE: 2/10 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
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
./istio-lab16/results/task9.1-proxy-status.txt
./istio-lab16/results/task9.2-traffic-result.txt
./istio-lab16/telemetry-config.yaml
./istio-lab16/updated-istiod-values.yaml
```
