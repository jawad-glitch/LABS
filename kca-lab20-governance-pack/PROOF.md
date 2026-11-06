# kca-lab20-governance-pack - completion proof
Completed (UTC): 2026-11-06 23:30:13 | EC2: i-0b53fa6c083cc787e | host: ip-172-31-10-67 | user: ubuntu

## Core checks
```
========== CORE CHECKS (kca-lab20-governance-pack, 2026-11-06 23:30:04 UTC) ==========
PASS: Task 1: Kyverno running; CRDs + webhooks present
PASS: Task 5: all 4 policies Ready
PASS: Task 6.1: privileged pod DENIED
PASS: Task 6.1: non-privileged pod ADMITTED
PASS: Task 6.2: 'nginx' mutated to docker.io/library/nginx
PASS: Task 6.2: approved gcr.io image untouched; bitnami/nginx -> docker.io/bitnami/nginx
PASS: Task 6.2: pod labels managed-by=kyverno, environment=policy-test, created-date=2026-11-06
PASS: Task 6.2: deployment + template labelled; its pods labelled
PASS: Task 4: services receive default labels
PASS: Task 6.3: Role namespace-admin + RoleBinding (subject rbac-test-admin) generated
PASS: Task 6.3: generated RBAC works (rbac-test-admin admin in rbac-test only)
PASS: Task 6.4: badregistry.com image REJECTED (not rewritten to docker.io)
CORE: 12/12 PASS
```

## Cluster snapshot
```
Warning: kyverno.io/v1 ClusterPolicy is deprecated and will be removed in a future release; migrate to ValidatingPolicy, MutatingPolicy, GeneratingPolicy or ImageValidatingPolicy (policies.kyverno.io), see https://kyverno.io/docs/guides/migration-to-cel/
NAME                         ADMISSION   BACKGROUND   READY   AGE   MESSAGE
add-default-labels           true        false        True    38s   Ready
auto-namespace-rbac          true        true         True    39s   Ready
deny-privileged-containers   true        true         True    42s   Ready
enforce-registry             true        true         True    41s   Ready

NAMESPACE            NAME                                             READY   STATUS    RESTARTS   AGE
kube-system          coredns-559f6c778d-lsscf                         1/1     Running   0          2m11s
kube-system          coredns-559f6c778d-zg28z                         1/1     Running   0          2m11s
kube-system          etcd-kca-control-plane                           1/1     Running   0          2m24s
kube-system          kindnet-glt4d                                    1/1     Running   0          2m12s
kube-system          kube-apiserver-kca-control-plane                 1/1     Running   0          2m24s
kube-system          kube-controller-manager-kca-control-plane        1/1     Running   0          2m24s
kube-system          kube-proxy-t82d7                                 1/1     Running   0          2m12s
kube-system          kube-scheduler-kca-control-plane                 1/1     Running   0          2m24s
kyverno              kyverno-admission-controller-75c55c6475-fph2n    1/1     Running   0          86s
kyverno              kyverno-background-controller-7f5648c454-dk4jt   1/1     Running   0          86s
kyverno              kyverno-cleanup-controller-6b96f7d9b-sj8bf       1/1     Running   0          86s
kyverno              kyverno-reports-controller-7866559564-2rl5c      1/1     Running   0          86s
local-path-storage   local-path-provisioner-75f7fc7dc5-7965t          1/1     Running   0          2m11s
policy-test          normal-test                                      1/1     Running   0          33s
policy-test          registry-test                                    1/1     Running   0          33s
policy-test          test-deployment-54cdd74589-ckkhw                 1/1     Running   0          30s

NAME   	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART        	APP VERSION
kyverno	kyverno  	1       	2026-11-06 23:28:30.331502306 +0000 UTC	deployed	kyverno-3.9.2	v1.19.2    
```

## Files
```
./kyverno-policies/auto-namespace-rbac.yaml
./kyverno-policies/default-labels.yaml
./kyverno-policies/deny-privileged.yaml
./kyverno-policies/enforce-registry.yaml
./kyverno-policies/kyverno-generate-rbac-permissions.yaml
./policy-validation-report.txt
./test-deployment.yaml
./test-invalid-registry.yaml
./test-normal-pod.yaml
./test-privileged-pod.yaml
./test-registry-mutation.yaml
```
