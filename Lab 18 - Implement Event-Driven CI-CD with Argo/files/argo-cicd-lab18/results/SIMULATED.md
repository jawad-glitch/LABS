# Simulated steps (fast mode) - Lab 18 - Implement Event-Driven CI-CD with Argo
Real: JetStream EventBus (nats:2.10.29, Argo Events v1.9.11), GitHub webhook endpoint with HMAC-SHA256 + X-GitHub-Event checks (built from github-eventsource.yaml),
every workflow step executed as a container (git clone of https://github.com/octocat/Hello-World.git, node test, package build, deploy/smoke steps) with a shared workspace volume,
resource events for workflow phase changes, sensor filters/parameters from the YAML, and replay of the lab-original configs against the real events.
Simulated: cluster, Argo Events controllers and Argo Workflows v4.1.6 controller (DAG executor emulator follows dependencies, when, parameters, volumeClaimTemplates, artifact-repo check).
Full mode: kubectl apply -n argo -f https://github.com/argoproj/argo-workflows/releases/download/v4.1.6/install.yaml ; kubectl create ns argo-events ;
kubectl apply -n argo-events -f https://raw.githubusercontent.com/argoproj/argo-events/v1.9.11/manifests/install.yaml ; kubectl apply -f eventbus.yaml -f rbac.yaml ;
kubectl create secret generic github-access -n argo-events --from-literal=secret=<webhook-secret> ; kubectl apply -f github-eventsource.yaml -f github-eventsource-svc.yaml -f ci-testing-template.yaml -f cd-deployment-template.yaml -f github-ci-sensor.yaml -f workflow-event-source.yaml -f workflow-cd-sensor.yaml ;
GitHub repo -> Settings -> Webhooks: payload URL = public URL of github-eventsource-svc /push, content type JSON, same secret, push events ;
kubectl -n argo wait --for=jsonpath='{.status.phase}'=Succeeded workflow -l workflows.argoproj.io/phase --timeout=300s
