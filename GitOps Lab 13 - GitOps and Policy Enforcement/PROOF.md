# GitOps Lab 13 - GitOps and Policy Enforcement - completion proof
Completed (UTC): 2026-11-10 09:08:07 | EC2: i-06a5c93eee96a6d91 | host: ip-172-31-10-127 | user: ubuntu

## Core checks
```
========== CORE CHECKS (GitOps Lab 13 - GitOps and Policy Enforcement, 2026-11-10 09:08:01 UTC) - CLUSTER SIMULATED, GATEKEEPER ENGINE REAL (gator) ==========
PASS: Tools: gator v3.23.1 (Gatekeeper engine) installed; templates/manifests schema-valid
PASS: Task 5.4 (lab policies): missing-labels Deployment DENIED (Missing required label)
PASS: Lab bug: lab limits policy reads spec.containers - non-compliant-limits Deployment is ALLOWED
PASS: Fixed limits policy (pod-template paths): non-compliant-limits DENIED
PASS: Lab bug: lab compliant-app violates the (working) security-context policy - would be DENIED on next sync
PASS: Hardened compliant-app, corrected-labels-app and Service ALLOWED by all 3 fixed policies
PASS: Runtime: lab nginx dies under read-only/non-root; hardened nginx-unprivileged serves HTTP 200
PASS: Task 6: pre-merge gate passes compliant (rc 0) and blocks non-compliant (rc 1) before the cluster
PASS: Lab bug: hand-written summary claims 'missing-limits-deployment' blocked; generated summary reflects real results
PASS: Task 8: repo committed (policies, manifests, gate, README, generated summary)
PASS: Time: finished in 17s (<= 300s)
CORE: 11/11 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                                     ID             DISK USAGE   CONTENT SIZE   EXTRA
nginx:1.27-alpine                         65645c7bb6a0       74.5MB         21.9MB        
nginxinc/nginx-unprivileged:1.27-alpine   65e3e85dbaed       73.7MB           21MB        
```

## Files
```
./gitops-policies/README.md
./gitops-policies/applications/production/namespace.yaml
./gitops-policies/deployment-summary.txt
./gitops-policies/lab-original/compliant-deployment.yaml
./gitops-policies/lab-original/constraints/require-container-limits.yaml
./gitops-policies/lab-original/constraints/require-environment-label.yaml
./gitops-policies/lab-original/constraints/require-security-context.yaml
./gitops-policies/lab-original/templates/container-limits-template.yaml
./gitops-policies/lab-original/templates/require-labels-template.yaml
./gitops-policies/lab-original/templates/require-security-context.yaml
./gitops-policies/manifests/compliant/compliant-deployment.yaml
./gitops-policies/manifests/compliant/compliant-service.yaml
./gitops-policies/manifests/compliant/corrected-labels-deployment.yaml
./gitops-policies/manifests/non-compliant/missing-labels-deployment.yaml
./gitops-policies/manifests/non-compliant/missing-limits-deployment.yaml
./gitops-policies/policies/constraints/require-container-limits.yaml
./gitops-policies/policies/constraints/require-environment-label.yaml
./gitops-policies/policies/constraints/require-security-context.yaml
./gitops-policies/policies/templates/container-limits-template.yaml
./gitops-policies/policies/templates/require-labels-template.yaml
./gitops-policies/policies/templates/require-security-context.yaml
./gitops-policies/policy-gate.sh
./gitops-policies/results/SIMULATED.md
./gitops-policies/results/elapsed.txt
./gitops-policies/results/git-log.txt
./gitops-policies/results/image-pull.txt
./gitops-policies/results/kubeconform.txt
./gitops-policies/results/task5-fixed-policy-results.txt
./gitops-policies/results/task5-lab-policy-results.txt
./gitops-policies/results/task6-gate-compliant.txt
./gitops-policies/results/task6-gate-noncompliant.txt
./gitops-policies/results/task7.3-runtime-hardening.txt
./gitops-policies/results/tools.txt
```
