# GitOps Policy Enforcement Lab
- `policies/templates/` Gatekeeper ConstraintTemplates (v1; Pods + pod templates)
- `policies/constraints/` Constraints
- `manifests/compliant|non-compliant/` test resources
- `policy-gate.sh` pre-merge gate (gator) - run in CI before merging to main
- `lab-original/` the lab's original templates/constraints (spec.containers bug)
