# GitOps Lab 13 - GitOps and Policy Enforcement - completion proof
Completed (UTC): 2026-11-10 09:06:26 | EC2: i-06a5c93eee96a6d91 | host: ip-172-31-10-127 | user: ubuntu

## Core checks
```
(none saved)
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
