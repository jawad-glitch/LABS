# Simulated steps (fast mode) - Lab 8 - Use Argo CD for Application Deployment
No cluster / Argo CD server ran. Real: install.yaml (v3.6.1) analysis + schema validation, argocd CLI v3.6.1, sample-app git repo (v1, v2 pushed to a network remote served by git daemon), container reachability proof, Application CRD validation, nginx/busybox service test.

| Lab step | Full-mode command | This run |
|---|---|---|
| 1.1 cluster | kind create cluster --name argocd-lab | none |
| 1.2 install | kubectl create ns argocd --dry-run=client -o yaml \| kubectl apply -f - ; kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.6.1/manifests/install.yaml | validated + CRD size proof (387270 bytes > 262144) |
| 1.2 wait | kubectl -n argocd rollout status deploy --timeout=300s; kubectl -n argocd rollout status statefulset/argocd-application-controller --timeout=300s | inventory |
| 1.4 repo | push ~/sample-app to https://github.com/jawad-glitch/sample-app.git (file:// is unreachable from the repo-server pod) | git daemon remote + container proof |
| 1.5 app | kubectl apply -f ~/argocd-application.yaml | CRD-schema validated |
| 2.1 login | argocd login localhost:8080 --username admin --password "$ARGOCD_PASSWORD" --insecure | CLI version pinned |
| 2.3 sync | argocd app sync sample-app; argocd app wait sample-app --sync --health --timeout 300 | --help captured |
| 2.4 change | git push; argocd app get sample-app --refresh; argocd app wait sample-app --sync --health --timeout 300 (not sleep 60) | pushed + verified on remote |
| 3.2 test | kubectl run test-pod --image=busybox:1.36 --rm -i --restart=Never -- wget -qO- sample-app-service (no -t) | busybox container on shared network |
