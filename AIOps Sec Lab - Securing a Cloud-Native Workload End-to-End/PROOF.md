# AIOps Sec Lab - Securing a Cloud-Native Workload End-to-End - completion proof
Completed (UTC): 2026-11-10 19:00:31 | EC2: i-0c9768683dc3d3660 | host: ip-172-31-10-42 | user: ubuntu

## Core checks
```
========== CORE CHECKS (AIOps Sec Lab - Securing a Cloud-Native Workload End-to-End, 2026-11-10 19:00:19 UTC) ==========
PASS: Task 1: k3d cluster Ready; kube-bench baseline saved (benchmark used: k3s-cis-1.7)
FAIL: Task 2: insecure Terraform fails Checkov (exit 1) and tfsec (exit 1)
PASS: Task 2: fixed Terraform passes Checkov and tfsec (explicit, logged excludes); validate OK
PASS: Task 2: applied to LocalStack - policy scoped (ListBucket + Get/Put orders/*), no s3:*, PAB all true, versioning, SSE
FAIL: Task 3: v0 (bullseye, root) fails the image gate; hardened current-alpine image passes, runs as 10001
PASS: Task 3: lab alpine3.20 base gate result recorded (EOL base)
PASS: Task 3: manifest gate - insecure Deployment fails (HIGH), hardened Deployment passes
PASS: Task 4: RBAC - ci-deployer can create deployments only in shop; cannot read secrets/exec/RBAC/delete; shop-api has no API rights
PASS: Task 4 (gator): nginx + busybox Pods DENIED (repo + non-root), hardened shop-api Pod ALLOWED, Deployment not matched (ALLOWED)
PASS: Task 5 (kyverno CLI): no-limits Pod and Deployment (autogen) fail; hardened Pod passes
FAIL: Task 5 (live cluster): default-deny blocks DNS/egress - curl exit 6
FAIL: Task 6 (live cluster): allowed client gets shop-api JSON; denied client blocked by name AND by IP (exit 28)
FAIL: Lab bug: expected client-denied exit=6 is wrong once DNS is allowed (real exit 28)
PASS: Task 6 (Vault k8s auth vs k3d): shop-api SA reads shop/db (shop_app); admin/root 403; ci-deployer SA rejected
FAIL: Task 6: Vault Agent rendered DB_USER/DB_PASS into tmpfs; app over TLS (private CA, hostname verified) reports db_secret_loaded true; no DB Secret in k8s
FAIL: Task 7 (Falco 0.45.2): Terminal shell + custom Vault-secret rule fired for the intruder; none for the python app
FAIL: Task 8: Isolation Forest puts >=3 attack windows in the top 5 (got 3); live Falco windows flagged: 0
PASS: Lab bug: two validate.sh checks pass vacuously (non-existent pod / no Calico)
FAIL: Time: finished in 481s (<= 300s)
CORE: 10/19 PASS
```

## Cluster snapshot
```
error: the server doesn't have a resource type "clusterpolicy"

NAMESPACE     NAME                                      READY   STATUS             RESTARTS   AGE
default       kube-bench-flbtw                          0/1     Completed          0          6m11s
kube-system   coredns-576bfc4dc7-6m5k6                  1/1     Running            0          6m28s
kube-system   local-path-provisioner-6795b5f9d8-2w2b5   1/1     Running            0          6m28s
shop          client-allowed                            1/1     Running            0          4m5s
shop          client-denied                             1/1     Running            0          4m5s
shop          shop-api-6b87554b8-nft2h                  0/1     ImagePullBackOff   0          4m5s

NAME	NAMESPACE	REVISION	UPDATED	STATUS	CHART	APP VERSION
```

## Docker snapshot
```
CONTAINER ID   IMAGE                      COMMAND                  CREATED         STATUS         PORTS                     NAMES
e4e4569626e9   rancher/k3s:v1.30.4-k3s1   "/bin/k3d-entrypoint…"   6 minutes ago   Up 6 minutes   0.0.0.0:45261->6443/tcp   k3d-aiops-sec-server-0

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
shop/api:0.9.0                   3607d1e26a7d        187MB         45.5MB        
shop/api:1.0.0                   f240087609d7       74.2MB         18.1MB        
shop/api:1.0.0-alpine3.20        0802531d797e       72.8MB         17.6MB        
```

## Files
```
./app/Dockerfile
./app/Dockerfile.alpine
./app/Dockerfile.alpine3.20
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
./results/bug-validate-false-pass.txt
./results/elapsed.txt
./results/falco-raw.jsonl
./results/task0-images.txt
./results/task0-tools.txt
./results/task0-venv-ml.txt
./results/task0-venv-sec.txt
./results/task1-bench.txt
./results/task1-k3d.log
./results/task1-nodes.txt
./results/task1-section5.txt
./results/task2-accepted-risks.txt
./results/task2-account.txt
./results/task2-apply.txt
./results/task2-checkov-fixed.txt
./results/task2-checkov-insecure.txt
./results/task2-deployed.txt
./results/task2-tf-init.txt
./results/task2-tf-validate.txt
./results/task2-tfsec-deprecation.txt
./results/task2-tfsec-fixed.txt
./results/task2-tfsec-insecure.txt
./results/task2-trivy-config-terraform.txt
./results/task3-image-gates.txt
./results/task3-k3d-import.txt
./results/task3-manifest-gates.txt
./results/task3-trivy-config-hardened.txt
./results/task3-trivy-config-insecure.txt
./results/task3-trivy-shop_api_0.9.0.txt
./results/task3-trivy-shop_api_1.0.0-alpine3.20.txt
./results/task3-trivy-shop_api_1.0.0.txt
./results/task4-gatekeeper-gator.txt
./results/task4-rbac.txt
./results/task5-default-deny.txt
./results/task5-kyverno-cli.txt
./results/task6-cert.txt
./results/task6-certmanager-kubeconform.txt
./results/task6-k8s-auth-config.txt
./results/task6-secret-and-tls.txt
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
./terraform/main.tf
./terraform/providers.tf
./terraform/terraform.tfstate
./vault/agent.hcl
```
