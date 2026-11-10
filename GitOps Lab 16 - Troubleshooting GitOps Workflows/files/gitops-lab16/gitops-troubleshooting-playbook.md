# GitOps Troubleshooting Playbook (corrected)
- Status: `kubectl -n argocd get application <app> -o jsonpath='{.status.sync.status} {.status.health.status}'`; conditions: `argocd app get <app>`
- Controller logs: `kubectl -n argocd logs statefulset/argocd-application-controller --tail=100` (StatefulSet, not Deployment)
- Repo/manifest errors (ComparisonError): `kubectl -n argocd logs deploy/argocd-repo-server --tail=100`; reproduce locally with `kubectl kustomize <path>`
- Force refresh/sync: `argocd app get <app> --refresh` ; `argocd app sync <app>` ; bounded wait: `argocd app wait <app> --sync --health --timeout 180`
- Pods: `kubectl -n <ns> describe pod <pod>` (Events: FailedScheduling / ErrImagePull); `kubectl -n <ns> get events --sort-by=.lastTimestamp`
- DNS: `kubectl run debug --image=busybox:1.36 --rm -i --restart=Never -- nslookup <svc>.<ns>.svc.cluster.local` (no -t)
- Never append list items with `cat >>` into kustomization.yaml - edit `resources:` (or `kustomize edit add resource`), then `kubectl kustomize` before committing.
