# Lab 4 - Use Workflow Templates and DAGs - completion proof
Completed (UTC): 2026-11-09 12:05:12 | EC2: i-0587bdd544373f2ec | host: ip-172-31-10-253 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 4 - Use Workflow Templates and DAGs, 2026-11-09 12:05:06 UTC) ==========
PASS: Task 1.1: cluster up, node Ready (v1.37.2+k3s1)
PASS: Task 1.2/1.3: Argo v3.7.18 controller + server available, argo CLI = v3.7.18
PASS: Task 2.4/5.1: both WorkflowTemplates listed by argo template list
PASS: Task 3.2: simple-dag-run-v96mp (from template) Succeeded, all 5 DAG tasks Succeeded
PASS: Task 4.4/7.2: DAG order from real timestamps - A before B/C/E, D after B and C, B||C parallel
PASS: Task 3.3: parameters reach the template (param run env=production, batch=1000; default run dev/100)
PASS: Task 4.3: task-a pod logs (simple-dag-run-v96mp-print-message-3443934944) with real timestamp (quoting fixed)
PASS: Task 5.2 dev: build+test+deploy-dev Succeeded, deploy-prod Skipped
PASS: Task 5.2 prod: build Succeeded, test Skipped, deploy-prod Succeeded, deploy-dev Skipped
PASS: Task 4.4/6.2/6.3: analyze sorted 5 tasks; validator passes good file, rejects broken; monitor reports Succeeded
PASS: Task 7.1: --from runs test-dag-49d7f and test-conditional-fbv67 Succeeded
PASS: Task 7.2: test-dag-patterns.sh - both dependency checks pass, no violations
PASS: Task 8: cleanup left 0 workflows and 0 workflowtemplates
PASS: Time budget: lab finished in 227s (<= 300s)
CORE: 14/14 PASS
```

## Cluster snapshot
```
error: the server doesn't have a resource type "clusterpolicy"

NAMESPACE     NAME                                  READY   STATUS      RESTARTS   AGE
argo          argo-server-7f79487488-r7p7j          1/1     Running     0          3m16s
argo          workflow-controller-6446b5594-t8j6x   1/1     Running     0          3m16s
kube-system   coredns-577d995dff-6tkf7              1/1     Running     0          3m17s
kube-system   helm-install-gateway-api-crd-zq67m    0/1     Completed   0          3m17s

NAME           	NAMESPACE  	REVISION	UPDATED                                	STATUS  	CHART                  	APP VERSION
gateway-api-crd	kube-system	1       	2026-11-09 12:02:16.576336365 +0000 UTC	deployed	gateway-api-crd-1.6.301	v1.6.3     
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./argo-lab4/analyze-dag.sh
./argo-lab4/conditional-dag-template.yaml
./argo-lab4/executor-rbac.yaml
./argo-lab4/install.yaml
./argo-lab4/monitor-performance.sh
./argo-lab4/parameterized-dag-workflow.yaml
./argo-lab4/results/broken-template.yaml
./argo-lab4/results/elapsed.txt
./argo-lab4/results/events.txt
./argo-lab4/results/executor-rbac-apply.txt
./argo-lab4/results/image-pull.log
./argo-lab4/results/install-argo-cli.log
./argo-lab4/results/install-jq.log
./argo-lab4/results/install-k3s.log
./argo-lab4/results/lab-original-task4.2-list-o-name.txt
./argo-lab4/results/lab-original-task4.3-c-task-a.txt
./argo-lab4/results/submitted.txt
./argo-lab4/results/task1.1-cluster-info.txt
./argo-lab4/results/task1.2-install-apply.txt
./argo-lab4/results/task1.2-pods.txt
./argo-lab4/results/task1.2-wait.txt
./argo-lab4/results/task1.3-argo-version.txt
./argo-lab4/results/task2.4-apply.txt
./argo-lab4/results/task2.4-template-get.txt
./argo-lab4/results/task2.4-template-list.txt
./argo-lab4/results/task3.2-watch.txt
./argo-lab4/results/task3.3-logs-param.txt
./argo-lab4/results/task4.1-list.txt
./argo-lab4/results/task4.2-get-simple.txt
./argo-lab4/results/task4.3-logs-simple.txt
./argo-lab4/results/task4.3-logs-task-a.txt
./argo-lab4/results/task4.4-analyze-dag.txt
./argo-lab4/results/task5.1-apply.txt
./argo-lab4/results/task5.3-dev-get.txt
./argo-lab4/results/task5.3-prod-get.txt
./argo-lab4/results/task6.2-validate-broken.txt
./argo-lab4/results/task6.2-validate-good.txt
./argo-lab4/results/task6.3-monitor.txt
./argo-lab4/results/task7.1-template-list.txt
./argo-lab4/results/task7.2-test-dag-patterns.txt
./argo-lab4/results/task8.1-delete-workflows.txt
./argo-lab4/results/task8.2-delete-templates.txt
./argo-lab4/results/versions.txt
./argo-lab4/results/wf-conditional-dev-nb2fp.json
./argo-lab4/results/wf-conditional-prod-rvccm.json
./argo-lab4/results/wf-param-dag-run-rh74d.json
./argo-lab4/results/wf-simple-dag-run-v96mp.json
./argo-lab4/results/wf-test-conditional-fbv67.json
./argo-lab4/results/wf-test-dag-49d7f.json
./argo-lab4/simple-dag-workflow.yaml
./argo-lab4/test-conditional-dev.yaml
./argo-lab4/test-conditional-prod.yaml
./argo-lab4/test-dag-patterns.sh
./argo-lab4/troubleshooting-guide.md
./argo-lab4/validate-workflow.sh
./argo-lab4/workflow-template.yaml
```
