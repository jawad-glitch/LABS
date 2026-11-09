# Argo Rollouts Pause/Resume Best Practices
- Resume = `kubectl argo rollouts promote` (clears manual pause, advances past a pause step); `promote --full` skips remaining steps.
- Use `pause: {}` steps as manual gates; `pause: {duration: N}` as soak time.
- Analysis steps gate automatically: a failed AnalysisRun aborts the rollout (Degraded) - recover with `undo` or by setting the stable image.
- Monitor with `kubectl argo rollouts status <name> --timeout 300s`, not `--watch` in scripts.
- Always pin images (incl. analysis job images) and validate manifests before applying.
