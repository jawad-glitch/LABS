# Lab 16 - Configure Sensors and Triggers in Argo Events - completion proof
Completed (UTC): 2026-11-09 13:14:54 | EC2: i-05daf37b76a93012e | host: ip-172-31-10-190 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 16 - Configure Sensors and Triggers in Argo Events, 2026-11-09 13:14:48 UTC) - FAST MODE ==========
PASS: Task 1-5 [SIMULATED apply]: fixed EventBus/RBAC/4 EventSources/4 Sensors valid (strict, K8s + Argo Events CRDs)
PASS: Lab bug: argo-events-sa is the controller-manager ServiceAccount in install.yaml v1.9.11 (lab cleanup would delete it); fixed uses sensor-trigger-sa
PASS: Task 1.4: EventBus = real NATS JetStream (latest) - all 15 published events persisted (messages=15)
PASS: Task 3.1/4.2: webhook -> Job ran for real (2 jobs); fixed log shows real date, lab original prints literal $(date)
PASS: Lab bug: original file EventSource (wrong fields, no dir at start) never fired - 0 pods
PASS: Task 4.3/4.4: fixed file EventSource (eventType+watchPathConfig, emptyDir) -> CREATE -> Pod ran with real date
PASS: Lab bug: final-test overwrite is a WRITE (ignored by eventType CREATE); rm+create fired a 2nd Pod
PASS: Task 5.2: chain ConfigMaps - fixed carry real eventTime + event id (3); lab original holds literal Go template text
PASS: Task 5 (real chaining): resource EventSource saw chain ConfigMaps -> step-2 Job ran 3 times with CHAIN_TS from the ConfigMap
PASS: Task 4.5: all resources created by fixed sensors (Jobs, Pods, ConfigMaps) valid (strict)
PASS: Time: fast-mode run finished in 54s (<= 300s)
CORE: 11/11 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                    ID             DISK USAGE   CONTENT SIZE   EXTRA
alpine:3.20              d9e853e87e55       12.2MB         3.71MB        
alpine:latest            f59abe656b69         13MB         3.94MB        
nats:2.10.29             5498ba57b947       22.4MB         6.19MB        
natsio/nats-box:0.20.2   5162fca0f56e        141MB         47.3MB        
```

## Files
```
./argo-events-lab16/calendar-eventsource.yaml
./argo-events-lab16/chain-job-sensor.yaml
./argo-events-lab16/chain-sensor.yaml
./argo-events-lab16/cluster/fixed/ConfigMap-chain-event-9d0uv.yaml
./argo-events-lab16/cluster/fixed/ConfigMap-chain-event-ozks0.yaml
./argo-events-lab16/cluster/fixed/ConfigMap-chain-event-uj9d3.yaml
./argo-events-lab16/cluster/fixed/Job-chain-step2-job-cip76.yaml
./argo-events-lab16/cluster/fixed/Job-chain-step2-job-jhj3x.yaml
./argo-events-lab16/cluster/fixed/Job-chain-step2-job-vf59x.yaml
./argo-events-lab16/cluster/fixed/Job-webhook-triggered-job-23zkz.yaml
./argo-events-lab16/cluster/fixed/Job-webhook-triggered-job-9e1al.yaml
./argo-events-lab16/cluster/fixed/Pod-file-triggered-pod-731jp.yaml
./argo-events-lab16/cluster/fixed/Pod-file-triggered-pod-gd73t.yaml
./argo-events-lab16/cluster/orig/ConfigMap-chain-event-2x8iu.yaml
./argo-events-lab16/cluster/orig/ConfigMap-chain-event-s9b1x.yaml
./argo-events-lab16/cluster/orig/ConfigMap-chain-event-wwgwp.yaml
./argo-events-lab16/cluster/orig/Job-webhook-triggered-job-50iys.yaml
./argo-events-lab16/cluster/orig/Job-webhook-triggered-job-x0lre.yaml
./argo-events-lab16/eventbus.yaml
./argo-events-lab16/events_sim.py
./argo-events-lab16/file-eventsource.yaml
./argo-events-lab16/file-sensor.yaml
./argo-events-lab16/fs/fixed/tmp/events/trigger.txt
./argo-events-lab16/fs/orig/tmp/events/trigger.txt
./argo-events-lab16/lab-original-calendar-eventsource.yaml
./argo-events-lab16/lab-original-chain-sensor.yaml
./argo-events-lab16/lab-original-file-eventsource.yaml
./argo-events-lab16/lab-original-file-sensor.yaml
./argo-events-lab16/lab-original-webhook-sensor.yaml
./argo-events-lab16/resource-eventsource.yaml
./argo-events-lab16/results/SIMULATED.md
./argo-events-lab16/results/all-workload-logs.txt
./argo-events-lab16/results/elapsed.txt
./argo-events-lab16/results/eventsource-fixed.log
./argo-events-lab16/results/eventsource-orig.log
./argo-events-lab16/results/fixed-created-resources-kubeconform.txt
./argo-events-lab16/results/image-pull.log
./argo-events-lab16/results/install-kubeconform.log
./argo-events-lab16/results/nats-pull.log
./argo-events-lab16/results/runs/fixed-Job-chain-step2-job-cip76.log
./argo-events-lab16/results/runs/fixed-Job-chain-step2-job-jhj3x.log
./argo-events-lab16/results/runs/fixed-Job-chain-step2-job-vf59x.log
./argo-events-lab16/results/runs/fixed-Job-webhook-triggered-job-23zkz.log
./argo-events-lab16/results/runs/fixed-Job-webhook-triggered-job-9e1al.log
./argo-events-lab16/results/runs/fixed-Pod-file-triggered-pod-731jp.log
./argo-events-lab16/results/runs/fixed-Pod-file-triggered-pod-gd73t.log
./argo-events-lab16/results/runs/orig-Job-webhook-triggered-job-50iys.log
./argo-events-lab16/results/runs/orig-Job-webhook-triggered-job-x0lre.log
./argo-events-lab16/results/sensor-fixed.log
./argo-events-lab16/results/sensor-orig.log
./argo-events-lab16/results/task-kubeconform.txt
./argo-events-lab16/results/task1-install-inventory.txt
./argo-events-lab16/results/task1.4-stream-add.txt
./argo-events-lab16/results/task4.1-webhook.txt
./argo-events-lab16/results/task4.3-file.txt
./argo-events-lab16/results/task4.5-stream-info.json
./argo-events-lab16/results/versions.txt
./argo-events-lab16/sensor-rbac.yaml
./argo-events-lab16/webhook-eventsource.yaml
./argo-events-lab16/webhook-sensor.yaml
```
