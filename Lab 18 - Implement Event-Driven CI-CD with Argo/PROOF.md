# Lab 18 - Implement Event-Driven CI-CD with Argo - completion proof
Completed (UTC): 2026-11-09 13:33:20 | EC2: i-0f214b14c16c1c341 | host: ip-172-31-10-46 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 18 - Implement Event-Driven CI-CD with Argo, 2026-11-09 13:33:14 UTC) - FAST MODE ==========
PASS: Tasks 1-4 [SIMULATED apply]: EventBus (JetStream), RBAC (executor + dedicated SAs), GitHub ES, Service, CI/CD templates, sensors, workflow ES valid (strict)
PASS: Lab bug: argo-events-sa belongs to the Argo Events controller (v1.9.11 install.yaml); fixed sensors use ci-sensor-sa
PASS: Task 1.3: EventBus = real NATS JetStream; all 4 pipeline events persisted (messages=4)
PASS: Lab bug: lab test webhook (no X-GitHub-Event, unsigned) rejected HTTP 400; signed GitHub push accepted HTTP 200
PASS: Lab bug: original CI sensor puts body.ref into repo-url (refs/heads/master) -> real git clone fails; fixed maps clone_url + ref
PASS: Lab bug: original CI DAG passes artifacts with no artifact repository -> Error; fixed uses shared workspace volume
PASS: Task 5.2: manual CI run (test-ci-pipeline-s5ecv) on real repo Succeeded (lab used argo-workflows master: default=main, master exists=0)
PASS: Task 5.4: signed push -> CI ci-pipeline-kyyt6 Succeeded - real clone/checkout, tests, package built
PASS: Task 4.2/4.3: CI success -> resource event -> CD sensor -> cd-pipeline-fh1j6 Succeeded, staging then smoke then production
PASS: Lab bug: original CD filter path body.object.* does not match the real CI-success event; labels-map filter invalid; fixed path matches
FAIL: Task 6.3/filters: failing workflow test-failure-1uqrf Failed; neither it nor manual test-ci-pipeline triggered CD (exactly 0 CD run)
PASS: Time: fast-mode run finished in 42s (<= 300s)
CORE: 11/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                    ID             DISK USAGE   CONTENT SIZE   EXTRA
alpine/git:latest        6a1fdb962814        144MB         38.9MB        
alpine:3.20              d9e853e87e55       12.2MB         3.71MB        
curlimages/curl:7.85.0   9fab1b73f45e       24.9MB         8.57MB        
nats:2.10.29             5498ba57b947       22.4MB         6.19MB        
natsio/nats-box:0.20.2   5162fca0f56e        141MB         47.3MB        
node:22-alpine           0e1754758c2d        239MB         61.7MB        
```

## Files
```
./argo-cicd-lab18/cd-deployment-template.yaml
./argo-cicd-lab18/ci-testing-template.yaml
./argo-cicd-lab18/ci18.py
./argo-cicd-lab18/cluster/Workflow-cd-pipeline-fh1j6.yaml
./argo-cicd-lab18/cluster/Workflow-ci-pipeline-kyyt6.yaml
./argo-cicd-lab18/cluster/Workflow-test-ci-pipeline-s5ecv.yaml
./argo-cicd-lab18/cluster/Workflow-test-failure-1uqrf.yaml
./argo-cicd-lab18/eventbus.yaml
./argo-cicd-lab18/failing-workflow.yaml
./argo-cicd-lab18/github-access-secret.template.yaml
./argo-cicd-lab18/github-ci-sensor.yaml
./argo-cicd-lab18/github-eventsource-svc.yaml
./argo-cicd-lab18/github-eventsource.yaml
./argo-cicd-lab18/lab-original/ci-template-artifacts.yaml
./argo-cicd-lab18/lab-original/github-ci-sensor.yaml
./argo-cicd-lab18/lab-original/workflow-cd-sensor.yaml
./argo-cicd-lab18/lab-original/workflow-event-source.yaml
./argo-cicd-lab18/manual-ci-workflow.yaml
./argo-cicd-lab18/monitor-pipelines.sh
./argo-cicd-lab18/rbac.yaml
./argo-cicd-lab18/results/SIMULATED.md
./argo-cicd-lab18/results/elapsed.txt
./argo-cicd-lab18/results/eventbus-stream-info.json
./argo-cicd-lab18/results/events/01-github-event-source-github.json
./argo-cicd-lab18/results/events/02-workflow-event-source-resource.json
./argo-cicd-lab18/results/events/03-workflow-event-source-resource.json
./argo-cicd-lab18/results/events/04-workflow-event-source-resource.json
./argo-cicd-lab18/results/image-pull.log
./argo-cicd-lab18/results/install-kubeconform.log
./argo-cicd-lab18/results/lab-original-clone-with-ref-as-url.txt
./argo-cicd-lab18/results/lab-original-replay.txt
./argo-cicd-lab18/results/pipeline.log
./argo-cicd-lab18/results/runs/cd-pipeline-fh1j6-deploy-to-production.log
./argo-cicd-lab18/results/runs/cd-pipeline-fh1j6-deploy-to-staging.log
./argo-cicd-lab18/results/runs/cd-pipeline-fh1j6-run-smoke-tests.log
./argo-cicd-lab18/results/runs/ci-pipeline-kyyt6-build-image.log
./argo-cicd-lab18/results/runs/ci-pipeline-kyyt6-clone-repo.log
./argo-cicd-lab18/results/runs/ci-pipeline-kyyt6-run-tests.log
./argo-cicd-lab18/results/runs/test-ci-pipeline-s5ecv-build-image.log
./argo-cicd-lab18/results/runs/test-ci-pipeline-s5ecv-clone-repo.log
./argo-cicd-lab18/results/runs/test-ci-pipeline-s5ecv-run-tests.log
./argo-cicd-lab18/results/runs/test-failure-1uqrf-failing-step.log
./argo-cicd-lab18/results/status.json
./argo-cicd-lab18/results/task-kubeconform.txt
./argo-cicd-lab18/results/task1.3-argo-events-inventory.txt
./argo-cicd-lab18/results/task1.3-eventbus-stream.txt
./argo-cicd-lab18/results/task5.2-argo-workflows-head.txt
./argo-cicd-lab18/results/task5.4-lab-unsigned-response.txt
./argo-cicd-lab18/results/task5.4-signed-response.txt
./argo-cicd-lab18/results/task5.4-webhook-codes.txt
./argo-cicd-lab18/results/versions.txt
./argo-cicd-lab18/workflow-cd-sensor.yaml
./argo-cicd-lab18/workflow-event-source.yaml
./argo-cicd-lab18/workspaces/ci-pipeline-kyyt6/source/README
./argo-cicd-lab18/workspaces/test-ci-pipeline-s5ecv/source/README
```
