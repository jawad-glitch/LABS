# Simulated steps (fast mode) - Lab 19 - Use Argo CD to Manage Multi-Environment GitOps
Real: git repos/commits/pushes/revert/promotion; repos served over git:// and cloned by the reconciler each pass; environments = real nginx containers
(replicas/image from the Deployment; bad tag = real pull failure); schema validation; ApplicationSet rendering + validation.
Simulated: cluster and Argo CD v3.6.1 (reconcile.py implements auto-sync / manual sync / selfHeal / health semantics); reconcile is forced instead of the 3-min poll.
Full mode: push each sample-app-<env> repo to https://github.com/jawad-glitch/sample-app-<env>.git ; kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.6.1/manifests/install.yaml ;
kubectl apply -f argocd-apps/ (or the ApplicationSet) ; argocd app get <app> --refresh ; argocd app wait <app> --sync --health --timeout 180 ; ./health-check.sh
