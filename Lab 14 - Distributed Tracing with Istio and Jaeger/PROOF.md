# Lab 14 - Distributed Tracing with Istio and Jaeger - completion proof
Completed (UTC): 2026-11-11 15:23:51 | EC2: i-0e88b5cdb573dfc94 | host: ip-172-31-10-80 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 14 - Distributed Tracing with Istio and Jaeger, 2026-11-11 15:23:43 UTC) - CLUSTER/ISTIOD SIMULATED, JAEGER + BOOKINFO + ENVOY REAL ==========
PASS: Setup: all 8 images pulled; istioctl 1.32.0
PASS: Task 1: Jaeger all-in-one query API and UI answer 200
PASS: Lab bug: Subtask 2.1 IstioOperator via kubectl has no operator to reconcile it
PASS: Fixed Task 2: meshConfig.extensionProviders (zipkin -> jaeger:9411) renders; Telemetry 100% sampling schema-valid
PASS: Task 3: Bookinfo via gateway 200 with details, reviews and ratings rendered
PASS: Task 4: lab paths - productpage/products/reviews 200, /nonexistent 404
PASS: Task 5.3: Jaeger lists gateway, productpage, details, reviews, ratings services
PASS: Task 5.3: >= 20 productpage traces; one trace spans >= 4 services end-to-end
PASS: Task 8.2: dependency graph has gateway->productpage, productpage->details, productpage->reviews, reviews->ratings
PASS: Lab bug: lab avg uses .spans[0], which is not the root span in some traces (45 of 50)
PASS: 404s produce gateway-only traces (never reach productpage)
PASS: Time: finished in 186s (<= 300s)
CORE: 12/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                                           ID             DISK USAGE   CONTENT SIZE   EXTRA
istio/examples-bookinfo-details-v1:1.17.0       2b081e3c86dd        232MB         62.5MB        
istio/examples-bookinfo-productpage-v1:1.17.0   6668bcf42ef0        296MB         67.5MB        
istio/examples-bookinfo-ratings-v1:1.17.0       b6a6b88d3578        249MB         57.2MB        
istio/examples-bookinfo-reviews-v1:1.17.0       b8f16a765eea       1.09GB          415MB        
istio/examples-bookinfo-reviews-v2:1.17.0       72f25a55f078       1.09GB          415MB        
istio/examples-bookinfo-reviews-v3:1.17.0       8f92fc1b6592       1.09GB          415MB        
istio/proxyv2:1.32.0                            b8d47c6d8d6e        400MB         92.2MB        
jaegertracing/all-in-one:1.50                   d589499a01e1       90.1MB         30.1MB        
```

## Files
```
./istio-lab14/envoy/gen.py
./istio-lab14/envoy/istio-ingressgateway.yaml
./istio-lab14/envoy/svc-details.yaml
./istio-lab14/envoy/svc-productpage.yaml
./istio-lab14/envoy/svc-ratings.yaml
./istio-lab14/envoy/svc-reviews.yaml
./istio-lab14/k8s/istio-tracing.yaml
./istio-lab14/k8s/telemetry-tracing.yaml
./istio-lab14/lab-original/istio-tracing-operator.yaml
./istio-lab14/recent_traces.json
./istio-lab14/results/SIMULATED.md
./istio-lab14/results/elapsed.txt
./istio-lab14/results/image-pull.txt
./istio-lab14/results/kubeconform-telemetry.txt
./istio-lab14/results/task1-jaeger.txt
./istio-lab14/results/task2-fixed-config.txt
./istio-lab14/results/task2-fixed-render.err
./istio-lab14/results/task2-lab-config.txt
./istio-lab14/results/task2-lab-render.err
./istio-lab14/results/task3-bookinfo.txt
./istio-lab14/results/task4-traffic.txt
./istio-lab14/results/task5-jaeger-analysis.txt
./istio-lab14/results/task5.1-jaeger-logs.txt
./istio-lab14/results/task6.2-patterns.txt
./istio-lab14/results/tools.txt
./istio-lab14/scripts/export-trace-summary.sh
./istio-lab14/scripts/generate_trace_patterns.sh
./istio-lab14/scripts/restart-meshed-workloads.sh
./istio-lab14/service_dependencies.json
./istio-lab14/services_list.json
```
