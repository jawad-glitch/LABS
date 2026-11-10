# Simulated - GitOps Lab 4 - Deploy an Application using Argo CD
NOT executed: minikube/cluster, Argo CD pods, sync, guestbook pods, port-forwards (fast mode; minikube --memory=4096 also exceeds this 3848 MiB VM).
Real: argocd CLI v3.6.1, install.yaml analysis, argocd-example-apps rendered (dir/helm/kustomize), CRD-schema validation, sample-app Git repo + real nginx
serving its ConfigMap page, commit 7bd4b39 -> aef60ac diff.
## Full-mode commands (kind instead of minikube; bounded)
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.6.1/manifests/install.yaml
kubectl -n argocd wait --for=condition=available deploy --all --timeout=300s && kubectl -n argocd rollout status sts/argocd-application-controller --timeout=300s
argocd admin initial-password -n argocd ; nohup kubectl port-forward svc/argocd-server -n argocd 8080:443 >pf.log 2>&1 </dev/null & disown
argocd login localhost:8080 --username admin --insecure        # prompts for password
kubectl apply -f applications/ && argocd app wait sample-nginx-app local-sample-app updated-sample-app sample-nginx-local --sync --health --timeout 300
nohup kubectl -n guestbook port-forward svc/local-sample-app-helm-guestbook 8081:80 >pf2.log 2>&1 </dev/null & disown ; curl -s localhost:8081 | head
