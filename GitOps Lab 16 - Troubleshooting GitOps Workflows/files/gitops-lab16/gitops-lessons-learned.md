# Lessons learned (from this run)
1. A conflict resolution in the base only reaches environments whose overlays do not pin the same fields (dev pins nginx:1.20).
2. Manifest-generation errors (bad kustomization YAML) stop Argo CD before anything is applied - check repo-server logs / kustomize build.
3. selfHeal reverts manual drift on the next reconcile; manual changes are temporary by design.
4. Scheduling failures (requests > node capacity) and image pulls show as Degraded health, not sync errors.
