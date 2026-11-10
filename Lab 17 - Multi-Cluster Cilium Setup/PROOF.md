# Lab 17 - Multi-Cluster Cilium Setup - completion proof
Completed (UTC): 2026-11-10 07:26:23 | EC2: i-02f87f95f469abb56 | host: ip-172-31-10-204 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 17 - Multi-Cluster Cilium Setup, 2026-11-10 07:26:17 UTC) - CLUSTER RUNTIME SIMULATED ==========
PASS: Task 1: docker, helm v3, cilium CLI v0.20.2 (sha256), kubeconform available
PASS: Task 3 (real CLI): lab install flags checked - 4 of the lab-specific flags absent; --set/--version present
PASS: Task 3.3/4.2: cilium clustermesh enable/connect/status exist in CLI v0.20.2
PASS: Task 2: kind configs - pod and service CIDRs of both clusters do not overlap
PASS: Task 3 fixed: chart 1.20.4 renders cluster1(id 1) and cluster2(id 2) with clustermesh-apiserver + KPR; schema-valid
PASS: Lab bug: *.svc.clusterset.local needs MCS-API (chart clustermesh.mcsapi, default off); fixed uses one global web-service in both clusters
FAIL: Tasks 5/8: fixed apps + global service + labelled test pods valid; page includes CLUSTER_NAME for the LB test
PASS: Lab bug: lab CNP uses fromClusters - rejected by the CiliumNetworkPolicy CRD schema
PASS: Lab bug + fix: lab policy denies its own unlabelled test pod; fixed allows test-client cross-cluster, denies unauthorized
PASS: Lab bug: cilium service list / hubble observe / endpoint list are not cilium CLI commands
PASS: Time: finished in 23s (<= 300s); runtime steps documented in SIMULATED.md
CORE: 10/11 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./cilium-multicluster-lab/fixed/app-cluster1.yaml
./cilium-multicluster-lab/fixed/app-cluster2.yaml
./cilium-multicluster-lab/fixed/cilium-rendered-cluster1.yaml
./cilium-multicluster-lab/fixed/cilium-rendered-cluster2.yaml
./cilium-multicluster-lab/fixed/cilium-values-cluster1.yaml
./cilium-multicluster-lab/fixed/cilium-values-cluster2.yaml
./cilium-multicluster-lab/fixed/cluster1-config.yaml
./cilium-multicluster-lab/fixed/cluster2-config.yaml
./cilium-multicluster-lab/fixed/cross-cluster-policy.yaml
./cilium-multicluster-lab/lab-original/cross-cluster-policy.yaml
./cilium-multicluster-lab/results/SIMULATED.md
./cilium-multicluster-lab/results/bug-clusterset-local-needs-mcsapi.txt
./cilium-multicluster-lab/results/bug-lab-cnp-kubeconform.txt
./cilium-multicluster-lab/results/bug-lab-nonexistent-cli-commands.txt
./cilium-multicluster-lab/results/elapsed.txt
./cilium-multicluster-lab/results/install-cilium-cli.log
./cilium-multicluster-lab/results/install-helm.log
./cilium-multicluster-lab/results/install-kubeconform.log
./cilium-multicluster-lab/results/task1.1-versions.txt
./cilium-multicluster-lab/results/task2-cidr-check.txt
./cilium-multicluster-lab/results/task3-cilium-install-help.txt
./cilium-multicluster-lab/results/task3-cilium-kubeconform.txt
./cilium-multicluster-lab/results/task3-lab-flag-check.txt
./cilium-multicluster-lab/results/task3-render-cluster1.err
./cilium-multicluster-lab/results/task3-render-cluster2.err
./cilium-multicluster-lab/results/task3-render-rc.txt
./cilium-multicluster-lab/results/task3-rendered-mesh-settings.txt
./cilium-multicluster-lab/results/task3.3-clustermesh-subcommands.txt
./cilium-multicluster-lab/results/task5-6-fixed-kubeconform.txt
./cilium-multicluster-lab/results/task6-policy-evaluation.txt
./cilium-multicluster-lab/results/versions.txt
```
