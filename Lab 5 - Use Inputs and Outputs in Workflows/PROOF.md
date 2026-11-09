# Lab 5 - Use Inputs and Outputs in Workflows - completion proof
Completed (UTC): 2026-11-09 12:21:32 | EC2: i-04f9410e4d0ede92e | host: ip-172-31-10-213 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 5 - Use Inputs and Outputs in Workflows, 2026-11-09 12:21:19 UTC) ==========
FAIL: Task 1.1: cluster Ready; Argo v3.7.18 controller/server + MinIO up; S3 artifact repository configured
PASS: Task 1.2: argo CLI = v3.7.18, namespace argo set in context
FAIL: Task 2.2: default params -> Message: Hello World to Student (basic-input-bhzjs)
FAIL: Task 2.3: -p override -> Message: Welcome to Argo Workflows to DevOps Engineer (basic-input-tgb6w)
FAIL: Task 3.1/3.2: artifact-output Succeeded, result-file saved to S3 repo, contents logged
PASS: Lab bug evidence: original args-as-string YAML rejected by argo lint; all 7 fixed workflows lint clean
FAIL: Task 3.3/3.4: artifact passed between steps - processor read item1..3 and wrote status processed
FAIL: Task 4.2: comprehensive I/O Succeeded - mysql/production/2.1.0 config, sha256 hash param, validation + HTML report artifact
FAIL: Task 4.3: per-step logs (setup-config, validate-config, generate-report) via step pods
FAIL: Task 5: global outputs in .status.outputs - final-status=completed-successfully, build-info for my-awesome-app
FAIL: Task 6.2: valid mode -> artifact-handling Succeeded; invalid-mode -> validation FAILED + artifact-handling Skipped
FAIL: Task 6.4: best-practices Succeeded - summary Processed 6 fields in json, global final-output artifact
PASS: Task 7: outputs summary written for all 9 workflows, argo delete --all left 0
FAIL: Time budget: lab finished in 483s (<= 300s)
CORE: 3/14 PASS
```

## Cluster snapshot
```
error: the server doesn't have a resource type "clusterpolicy"

NAMESPACE     NAME                                  READY   STATUS             RESTARTS   AGE
argo          argo-server-7c587c9bbb-zggt2          1/1     Running            0          7m45s
argo          httpbin-5ffc6df597-j99nm              1/1     Running            0          7m45s
argo          minio-fcbb79d47-dhzhk                 0/1     ImagePullBackOff   0          7m45s
argo          workflow-controller-6446b5594-d7cvr   1/1     Running            0          7m45s
kube-system   coredns-577d995dff-jqpr5              1/1     Running            0          7m47s
kube-system   helm-install-gateway-api-crd-5mbp6    0/1     Completed          0          7m47s

NAME           	NAMESPACE  	REVISION	UPDATED                               	STATUS  	CHART                  	APP VERSION
gateway-api-crd	kube-system	1       	2026-11-09 12:13:56.63614664 +0000 UTC	deployed	gateway-api-crd-1.6.301	v1.6.3     
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./argo-lab5/artifact-output-workflow.yaml
./argo-lab5/basic-input-workflow.yaml
./argo-lab5/best-practices-workflow.yaml
./argo-lab5/comprehensive-io-workflow.yaml
./argo-lab5/executor-rbac.yaml
./argo-lab5/global-params-workflow.yaml
./argo-lab5/lab-original-artifact-output.yaml
./argo-lab5/multi-step-artifact-workflow.yaml
./argo-lab5/quick-start-minimal.yaml
./argo-lab5/results/elapsed.txt
./argo-lab5/results/events.txt
./argo-lab5/results/executor-rbac-apply.txt
./argo-lab5/results/image-pull.log
./argo-lab5/results/images.txt
./argo-lab5/results/install-argo-cli.log
./argo-lab5/results/install-jq.log
./argo-lab5/results/install-k3s.log
./argo-lab5/results/lab-original-argo-get-watch.txt
./argo-lab5/results/lab-original-args-string-lint.txt
./argo-lab5/results/lab-original-logs-c-setup-config.txt
./argo-lab5/results/lint-fixed.txt
./argo-lab5/results/logs-artifact-output-64cxs.txt
./argo-lab5/results/logs-basic-input-bhzjs.txt
./argo-lab5/results/logs-basic-input-tgb6w.txt
./argo-lab5/results/logs-best-practices-ftcdc.txt
./argo-lab5/results/logs-comprehensive-io-7hvgt.txt
./argo-lab5/results/logs-global-params-nlg2j.txt
./argo-lab5/results/logs-multi-step-artifact-lwr5n.txt
./argo-lab5/results/logs-troubleshooting-2mkgt.txt
./argo-lab5/results/logs-troubleshooting-gprr4.txt
./argo-lab5/results/phases.txt
./argo-lab5/results/submitted.txt
./argo-lab5/results/task1-artifact-repo-config.yaml
./argo-lab5/results/task1-images-in-k3s.txt
./argo-lab5/results/task1-install-apply.txt
./argo-lab5/results/task1.1-cluster.txt
./argo-lab5/results/task1.2-argo-version.txt
./argo-lab5/results/task2.2-argo-list.txt
./argo-lab5/results/task2.2-get-basic.txt
./argo-lab5/results/task3.2-get-artifact.txt
./argo-lab5/results/task4.2-watch-comprehensive.txt
./argo-lab5/results/task4.3-comprehensive.yaml
./argo-lab5/results/task4.3-step-logs.txt
./argo-lab5/results/task5.2-global-outputs.json
./argo-lab5/results/task6.4-best-practices-outputs.json
./argo-lab5/results/task7.1-outputs-summary.txt
./argo-lab5/results/task7.2-after-cleanup.txt
./argo-lab5/results/task7.2-delete.txt
./argo-lab5/results/tools-image-build.log
./argo-lab5/results/tools-image-import.log
./argo-lab5/results/versions.txt
./argo-lab5/results/wf-artifact-output-64cxs.json
./argo-lab5/results/wf-basic-input-bhzjs.json
./argo-lab5/results/wf-basic-input-tgb6w.json
./argo-lab5/results/wf-best-practices-ftcdc.json
./argo-lab5/results/wf-comprehensive-io-7hvgt.json
./argo-lab5/results/wf-global-params-nlg2j.json
./argo-lab5/results/wf-multi-step-artifact-lwr5n.json
./argo-lab5/results/wf-troubleshooting-2mkgt.json
./argo-lab5/results/wf-troubleshooting-gprr4.json
./argo-lab5/troubleshooting-workflow.yaml
```
