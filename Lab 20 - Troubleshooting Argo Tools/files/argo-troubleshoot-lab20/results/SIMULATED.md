# Simulated steps (fast mode) - Lab 20 - Troubleshooting Argo Tools
Real: CLIs argo v4.1.6 / argocd v3.6.1 / kubectl-argo-rollouts v1.10.2 (checksum-verified); workflow steps executed as containers with timestamped logs;
nonexistent-image pull failure; Service targetPort mismatch reproduced (curl :8080 refused vs :80 served); Prometheus v3.16.0 crash with lab flags,
ready with fixed flags, promtool checks; lab keep-rule checked against the real Rollouts v1.10.2 install.yaml; canary pods as nginx containers with
measured traffic (40 HTTP requests per state), invalid-tag pull failure, HTTP analysis check.
Simulated: cluster, Workflows/CD/Rollouts controllers (step/health/canary semantics emulated); pause durations skipped.
Full mode: kubectl apply -n argo -f https://github.com/argoproj/argo-workflows/releases/download/v4.1.6/install.yaml ;
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.6.1/manifests/install.yaml ;
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/download/v1.10.2/install.yaml ; kubectl apply -f prometheus.yaml -f rollout-demo.yaml ;
WF=$(argo submit -n argo failing-workflow.yaml -o name); argo wait -n argo $WF; ./troubleshoot-workflow.sh $WF ;
push git-repo to https://github.com/jawad-glitch/git-repo.git ; kubectl apply -f argocd-app.yaml ; ./troubleshoot-argocd.sh sample-app ;
kubectl argo rollouts set image rollout-demo -n rollout-demo rollout-demo=nginx:invalid-tag ; kubectl argo rollouts status rollout-demo -n rollout-demo --timeout 120s ; ./troubleshoot-rollout.sh rollout-demo rollout-demo
