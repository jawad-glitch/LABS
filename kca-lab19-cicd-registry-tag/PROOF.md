# kca-lab19-cicd-registry-tag - completion proof
Completed (UTC): 2026-11-06 23:23:38 | EC2: i-0c2eafb9ed6c29225 | host: ip-172-31-10-11 | user: ubuntu

## Core checks
```
========== CORE CHECKS (kca-lab19-cicd-registry-tag, 2026-11-06 23:21:54 UTC) ==========
PASS: Task 1: Kyverno CLI installed
PASS: Task 2: compliant Deployment passes both policies (autogen, semver regex)
PASS: Task 3: bad registry rejected by enforce-registry
PASS: Task 3: :latest tag rejected by enforce-tags
PASS: Task 3: untagged image rejected by enforce-tags
PASS: Task 5: pipeline FAILS (exit 1) with Passed: 1 / Failed: 3
PASS: Task 6: legacy app fails WITHOUT the PolicyException
PASS: Task 6: legacy app passes WITH the PolicyException
PASS: Task 6.2: continuous-monitor.sh valid bash
PASS: Task 7: test suite 5/5 passed
PASS: Task 8: final report generated with test + pipeline results
CORE: 11/11 PASS
```

## Files
```
./lab19-registry-tag-enforcement/exceptions/policy-exemption.yaml
./lab19-registry-tag-enforcement/manifests/bad-registry-deployment.yaml
./lab19-registry-tag-enforcement/manifests/compliant-deployment.yaml
./lab19-registry-tag-enforcement/manifests/latest-tag-deployment.yaml
./lab19-registry-tag-enforcement/manifests/legacy-app-deployment.yaml
./lab19-registry-tag-enforcement/manifests/no-tag-deployment.yaml
./lab19-registry-tag-enforcement/policies/enforce-registry.yaml
./lab19-registry-tag-enforcement/policies/enforce-tags.yaml
./lab19-registry-tag-enforcement/results/final_lab_report_20261106_232136.md
./lab19-registry-tag-enforcement/results/validation_report_20261106_232117.txt
./lab19-registry-tag-enforcement/results/validation_report_20261106_232145.txt
./lab19-registry-tag-enforcement/scripts/continuous-monitor.sh
./lab19-registry-tag-enforcement/scripts/exemption-handler.sh
./lab19-registry-tag-enforcement/scripts/generate-report.sh
./lab19-registry-tag-enforcement/scripts/pipeline-validator.sh
./lab19-registry-tag-enforcement/scripts/test-suite.sh
./lab19-registry-tag-enforcement/scripts/validate-single.sh
```
