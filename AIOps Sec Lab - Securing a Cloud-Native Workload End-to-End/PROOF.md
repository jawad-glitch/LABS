# AIOps Sec Lab - Securing a Cloud-Native Workload End-to-End - completion proof
Completed (UTC): 2026-11-10 19:25:16 | EC2: i-0ab6e5e5ca8eb49e2 | host: ip-172-31-10-22 | user: ubuntu

## Core checks
```
========== CORE CHECKS (AIOps Sec Lab - Securing a Cloud-Native Workload End-to-End, 2026-11-10 19:25:04 UTC) - full run + resume ==========
PASS: Task 1: k3d cluster Ready; kube-bench baseline saved (benchmark used: k3s-cis-1.7)
PASS: Lab bug: lab's Checkov list (resource-only IAM checks) PASSES the s3:* data-source policy
PASS: Task 2: insecure Terraform fails Checkov with data-source checks (CKV_AWS_107-111/356) and tfsec
PASS: Task 2: fixed Terraform passes Checkov (all checks) and tfsec (logged excludes); validate OK
PASS: Task 2: applied to LocalStack - scoped policy, no s3:*, PAB all true, versioning, SSE
PASS: Task 3: v0 (bullseye, root) fails the gate with findings; hardened image passes (0), runs as 10001
PASS: Task 3: lab alpine3.20 base scanned (result recorded)
PASS: Task 3: manifest gate - insecure Deployment fails, hardened passes
PASS: Task 4: RBAC least privilege (ci-deployer / shop-api) via auth can-i
PASS: Task 4 (gator): nginx + busybox DENIED, hardened Pod ALLOWED, Deployment not matched
PASS: Task 5 (kyverno CLI): no-limits Pod + Deployment (autogen) fail; hardened Pod passes; generate passes
PASS: Task 5 (live): default-deny blocks DNS - lookup fails (exit 6)
PASS: Task 6 (live): shop-api Ready; allowed client gets JSON; denied client blocked by name (7) and IP (7)
PASS: Lab bug: expected client-denied exit=6 is wrong once DNS is allowed (got 7)
PASS: Task 6 (Vault k8s auth vs k3d): shop-api reads shop/db; admin/root 403; ci-deployer rejected
PASS: Task 6: Vault Agent sidecar rendered DB_USER/DB_PASS to tmpfs; TLS app (CA + hostname verified) db_secret_loaded true; no DB Secret in k8s
PASS: Task 7 (Falco 0.45.2): Terminal shell + custom Vault-secret rule fired for the intruder; none for python
PASS: Task 8: >=3 attack windows in top 5 (got 3); live Falco windows flagged (got 1)
PASS: Lab bug: two validate.sh checks pass vacuously (non-existent pod / no Calico)
PASS: Time: resume 46s (<= 300s); full cold run Elapsed: 483s recorded
CORE: 20/20 PASS
```

## Cluster snapshot
```
error: the server doesn't have a resource type "clusterpolicy"

NAMESPACE     NAME                                      READY   STATUS      RESTARTS   AGE
default       kube-bench-ncrm8                          0/1     Completed   0          8m26s
kube-system   coredns-576bfc4dc7-ctff9                  1/1     Running     0          9m4s
kube-system   local-path-provisioner-6795b5f9d8-td79k   1/1     Running     0          9m4s
shop          client-allowed                            1/1     Running     0          6m16s
shop          client-denied                             1/1     Running     0          6m16s
shop          shop-api-6b87554b8-llfkb                  1/1     Running     0          49s

NAME	NAMESPACE	REVISION	UPDATED	STATUS	CHART	APP VERSION
```

## Docker snapshot
```
CONTAINER ID   IMAGE                      COMMAND                  CREATED         STATUS         PORTS                     NAMES
e988751f7aca   rancher/k3s:v1.30.4-k3s1   "/bin/k3d-entrypoint…"   9 minutes ago   Up 9 minutes   0.0.0.0:45451->6443/tcp   k3d-aiops-sec-server-0

IMAGE                            ID             DISK USAGE   CONTENT SIZE   EXTRA
aquasec/kube-bench:v0.8.0        ea3e33bc3c4e        194MB         54.6MB        
curlimages/curl:8.9.1            8addc281f0ea       31.9MB         9.38MB        
falcosecurity/falco:0.45.2       1562a643953f        155MB         40.7MB        
ghcr.io/k3d-io/k3d-tools:5.9.0   c57abce697e6         35MB         11.2MB        
hashicorp/vault:2.2.1            962a92876e16        766MB          202MB        
localstack/localstack:3.7.2      811d4cd67e6c       1.68GB          442MB        
python:3.12-alpine               e064671ca452       74.8MB         18.7MB        
python:3.12-alpine3.20           25849f9599e0       73.5MB         18.3MB        
python:3.9-slim-bullseye         b9e06687fbfc        190MB         48.3MB        
rancher/k3s:v1.30.4-k3s1         983a88efba91        282MB         71.7MB   U    
shop/api:0.9.0                   e7f9e5439701        187MB         45.5MB        
shop/api:1.0.0                   2743a6cb3ea3       83.5MB         20.7MB        
shop/api:1.0.0-alpine3.20        7ded26f7662d       72.8MB         17.6MB        
```

## Files
```
./app/Dockerfile
./app/Dockerfile.lab-alpine3.20
./app/Dockerfile.v0
./app/app.py
./falco-live.jsonl
./k8s/bench/kube-bench-job.yaml
./k8s/falco/aiops-rules.yaml
./k8s/gatekeeper/constraints.yaml
./k8s/gatekeeper/t/bad-deploy.yaml
./k8s/gatekeeper/t/bad-nginx.yaml
./k8s/gatekeeper/t/busybox.yaml
./k8s/gatekeeper/t/shop-api-pod.yaml
./k8s/gatekeeper/tpl-allowed-repos.yaml
./k8s/gatekeeper/tpl-pod-security.yaml
./k8s/kyverno/generate-default-deny.yaml
./k8s/kyverno/nolimit-deploy.yaml
./k8s/kyverno/nolimit-pod.yaml
./k8s/kyverno/ns-shop.yaml
./k8s/kyverno/require-limits.yaml
./k8s/pki/ca.crt
./k8s/pki/ca.srl
./k8s/pki/ca.yaml
./k8s/pki/ext.cnf
./k8s/pki/tls.crt
./k8s/pki/tlsdir/tls.crt
./k8s/scan/insecure-deploy.yaml
./k8s/shop/clients.yaml
./k8s/shop/default-deny.yaml
./k8s/shop/deployment.yaml
./k8s/shop/netpol-allow.yaml
./k8s/shop/rbac.yaml
./kube-bench-baseline.txt
./ml/answers.txt
./ml/events_week.csv
./ml/gen_events.py
./ml/live_scored.csv
./ml/triage.py
./ml/triage_report.csv
./results/SIMULATED.md
./results/bug-k3d-import.txt
./results/bug-trivy-image-no-docker-access.txt
./results/bug-validate-false-pass.txt
./results/elapsed-resume.txt
./results/elapsed.txt
./results/falco-raw.jsonl
./results/task0-images.txt
./results/task0-tools.txt
./results/task0-venv-ml.txt
./results/task0-venv-sec.txt
./results/task1-bench.txt
./results/task1-k3d.log
./results/task1-nodes.txt
./results/task2-accepted-risks.txt
./results/task2-apply.txt
./results/task2-checkov-fixed.txt
./results/task2-checkov-fixed.txt.rc
./results/task2-checkov-insecure-LABLIST.txt
./results/task2-checkov-insecure-LABLIST.txt.rc
./results/task2-checkov-insecure.txt
./results/task2-checkov-insecure.txt.rc
./results/task2-checkov-summary.txt
./results/task2-deployed.txt
./results/task2-tf-init.txt
./results/task2-tf-validate.txt
./results/task2-tfsec-fixed.txt
./results/task2-tfsec-insecure.txt
./results/task3-ctr-import.txt
./results/task3-image-gates.txt
./results/task3-k3d-import.txt
./results/task3-manifest-gates.txt
./results/task3-trivy-config-hardened.txt
./results/task3-trivy-config-insecure.txt
./results/task3-trivy-flag.txt
./results/task3-trivy-shop_api_0.9.0.err
./results/task3-trivy-shop_api_0.9.0.json
./results/task3-trivy-shop_api_1.0.0-alpine3.20.err
./results/task3-trivy-shop_api_1.0.0-alpine3.20.json
./results/task3-trivy-shop_api_1.0.0.err
./results/task3-trivy-shop_api_1.0.0.json
./results/task4-gatekeeper-gator.txt
./results/task4-rbac.txt
./results/task5-default-deny.txt
./results/task5-kyverno-cli.txt
./results/task6-cert.txt
./results/task6-certmanager-kubeconform.txt
./results/task6-k8s-auth-config.txt
./results/task6-secret-and-tls.txt
./results/task6-shop-api-ready.txt
./results/task6-traffic-matrix.txt
./results/task6-vault-agent.log
./results/task6-vault-boundary.txt
./results/task6-vault-policy.txt
./results/task7-alerts.txt
./results/task7-falco-start.txt
./results/task8-gen.txt
./results/task8-triage.txt
./terraform/.terraform.lock.hcl
./terraform/.terraform/providers/registry.terraform.io/hashicorp/aws/5.100.0/linux_amd64/LICENSE.txt
./terraform/bucket_hardening.tf
./terraform/iam_policy.tf
./terraform/insecure-main.tf.example
./terraform/main.tf
./terraform/providers.tf
./terraform/terraform.tfstate
./vault/agent.hcl
```
