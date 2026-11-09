# Lab 17 - Use Argo Events with S3 and NATS - completion proof
Completed (UTC): 2026-11-09 13:19:28 | EC2: i-0d4c9625e5da9c2ae | host: ip-172-31-10-202 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 17 - Use Argo Events with S3 and NATS, 2026-11-09 13:19:23 UTC) - FAST MODE ==========
PASS: Task 1-2 [SIMULATED apply]: EventBus (added - lab had none), NATS+MinIO (labelled, Secret, notify env), EventSource, WorkflowTemplate, Sensor, RBAC+executor RBAC valid (strict)
FAIL: Lab bug: pip3 install nats-py fails on Ubuntu 24.04 (PEP 668 externally-managed-environment)
PASS: Task 1.3: NATS broker (nats:2.10-alpine) up; JetStream EventBus stream created
FAIL: Task 2.1/2.2: MinIO up, bucket event-bucket created, NATS notification (put) attached
FAIL: Task 3.3/3.4: 5 files uploaded with mc -> MinIO emitted 0 real s3:ObjectCreated:Put events on s3.file.uploaded
FAIL: Lab bug: original sensor dataKey bucket/key/eventTime cannot resolve (NATS data = {subject, body}) -> 0 errors, 0 workflows
FAIL: Task 2.5/3.3: fixed sensor submitted 0 workflows from real S3 events, all Succeeded
FAIL: Task 3.3: workflow step ran for real with values from the S3 record (bucket, object keys incl. verification-test-1794230358.txt, real eventTime)
PASS: Time: fast-mode run finished in 50s (<= 300s)
CORE: 3/9 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                    ID             DISK USAGE   CONTENT SIZE   EXTRA
alpine:3.18              de0eb0b3f2a4       11.5MB          3.5MB        
nats:2.10-alpine         b83efabe3e7d       38.7MB         10.5MB        
nats:2.10.29             5498ba57b947       22.4MB         6.19MB        
natsio/nats-box:0.20.2   5162fca0f56e        141MB         47.3MB        
```

## Files
```
./argo-events-lab17/eventbus.yaml
./argo-events-lab17/events17.py
./argo-events-lab17/lab-original-nats-sensor.yaml
./argo-events-lab17/minio-deployment.yaml
./argo-events-lab17/nats-deployment.yaml
./argo-events-lab17/nats-event-source.yaml
./argo-events-lab17/nats-sensor.yaml
./argo-events-lab17/publish-s3-event.py
./argo-events-lab17/results/SIMULATED.md
./argo-events-lab17/results/all-workflow-logs.txt
./argo-events-lab17/results/bug-pip3-system-install.txt
./argo-events-lab17/results/elapsed.txt
./argo-events-lab17/results/eventbus-stream-add.txt
./argo-events-lab17/results/eventsource.log
./argo-events-lab17/results/image-pull.log
./argo-events-lab17/results/install-kubeconform.log
./argo-events-lab17/results/minio.log
./argo-events-lab17/results/sensor-fixed.log
./argo-events-lab17/results/sensor-orig.log
./argo-events-lab17/results/task-kubeconform.txt
./argo-events-lab17/results/task1.3-broker-varz.json
./argo-events-lab17/results/task2.2-mc-event-add.txt
./argo-events-lab17/results/task2.2-mc-event-ls.txt
./argo-events-lab17/results/task2.2-mc-mb.txt
./argo-events-lab17/results/task3-mc-ls.txt
./argo-events-lab17/results/task3-uploads.txt
./argo-events-lab17/results/versions.txt
./argo-events-lab17/s3-processing-workflow.yaml
./argo-events-lab17/sensor-rbac.yaml
```
