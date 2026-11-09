# Lab 14 - Argo Events Installation - completion proof
Completed (UTC): 2026-11-09 13:05:57 | EC2: i-0cfd55d3ddcdb6e18 | host: ip-172-31-10-238 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 14 - Argo Events Installation, 2026-11-09 13:05:52 UTC) - FAST MODE ==========
PASS: Task 2.3 [SIMULATED apply]: Argo Events v1.9.11 install.yaml (release tag, not master) + namespace pass Kubernetes schema validation
PASS: Lab bug: the 3 controllers are merged - single Deployment controller-manager, no eventbus/eventsource/sensor-controller
PASS: Task 3.4/4.3: CRDs eventbus, eventsources, sensors present (short names recorded)
PASS: Task 3.5: RBAC - ServiceAccount, argo-events ClusterRole(s) + ClusterRoleBinding(s)
PASS: Task 4.1: controller-manager image pinned to quay.io/argoproj/argo-events:v1.9.11
PASS: Task 5.1: EventBus uses JetStream version latest from controller config (native NATS Streaming is deprecated) and is valid vs EventBus CRD schema
PASS: Task 5.4 [SIMULATED EventBus pod]: NATS 2.10.29 from nats:2.10.29 healthy with JetStream enabled
PASS: Task 5.5: event bus works - stream created, event published, stored (messages=1) and read back
PASS: Time: fast-mode run finished in 12s (<= 300s)
CORE: 9/9 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                    ID             DISK USAGE   CONTENT SIZE   EXTRA
nats:2.10.29             5498ba57b947       22.4MB         6.19MB        
natsio/nats-box:0.20.2   5162fca0f56e        141MB         47.3MB        
```

## Files
```
./argo-events-lab14/argo-events-install.yaml
./argo-events-lab14/inventory.py
./argo-events-lab14/lab-original-eventbus-native.yaml
./argo-events-lab14/namespace-argo-events.yaml
./argo-events-lab14/results/SIMULATED.md
./argo-events-lab14/results/elapsed.txt
./argo-events-lab14/results/install-kubeconform.log
./argo-events-lab14/results/nats-pull.log
./argo-events-lab14/results/natsbox-pull.log
./argo-events-lab14/results/task2.2-components-preview.txt
./argo-events-lab14/results/task2.3-kubeconform.txt
./argo-events-lab14/results/task3-inventory.txt
./argo-events-lab14/results/task3-summary.txt
./argo-events-lab14/results/task5-publish.txt
./argo-events-lab14/results/task5-stream-add.txt
./argo-events-lab14/results/task5-stream-get.txt
./argo-events-lab14/results/task5-stream-info.json
./argo-events-lab14/results/task5.1-eventbus-kubeconform.txt
./argo-events-lab14/results/task5.4-nats-healthz.json
./argo-events-lab14/results/task5.4-nats-jsz.json
./argo-events-lab14/results/task5.4-nats-varz.json
./argo-events-lab14/results/task5.5-nats-server.log
./argo-events-lab14/results/versions.txt
./argo-events-lab14/test-eventbus.yaml
```
