# Simulated steps (fast mode) - Lab 10 - Implement Blue-Green Deployment with Argo Rollouts
No cluster, Rollouts controller or Argo CD ran. Real: schema validation (K8s + Rollout/AnalysisTemplate/Application CRDs), YAML/patch bug reproduction,
CLI v1.10.2, and the blue-green traffic flow: each ReplicaSet = a real nginx container serving its ConfigMap page; Services = DNS aliases
(incl. *.blue-green-demo.svc.cluster.local) moved between containers exactly where Rollouts would rewrite the Service selector; the AnalysisTemplate's own
job script ran unmodified (10 HTTP checks) against the preview service before each promotion. Timeline: results/simulation-timeline.txt

| Lab step | Full-mode command |
|---|---|
| 3.1 apply | kubectl apply -f namespace.yaml -f analysis-template.yaml -f rollout.yaml |
| 3.2 watch | kubectl argo rollouts status demo-app-rollout -n blue-green-demo --timeout 180s (not --watch) |
| 3.3 test | kubectl run test-pod --image=curlimages/curl:7.85.0 -n blue-green-demo --rm -i --restart=Never -- curl -s http://demo-app-active.blue-green-demo.svc.cluster.local |
| 4.2 update | kubectl apply -f app-html-v2-configmap.yaml; kubectl patch rollout demo-app-rollout -n blue-green-demo --type=json --patch-file patch-v2.json |
| 4.5 promote | kubectl argo rollouts promote demo-app-rollout -n blue-green-demo; kubectl argo rollouts status demo-app-rollout -n blue-green-demo --timeout 180s |
| 5.1 Argo CD | kubectl port-forward svc/argocd-server -n argocd 8080:443 (localhost only) + ssh -L 8080:localhost:8080 ubuntu@EC2 |
| 6 rollback | kubectl argo rollouts undo demo-app-rollout -n blue-green-demo; (analysis runs) kubectl argo rollouts promote demo-app-rollout -n blue-green-demo |
| 7 auto | kubectl apply -f rollout-auto-promote.yaml -f app-html-v3-configmap.yaml; kubectl patch rollout demo-app-rollout -n blue-green-demo --type=json --patch-file patch-v3.json |
