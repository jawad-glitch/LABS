# Simulated steps (fast mode) - Lab 14 - Argo Events Installation
No cluster ran. Real: Argo Events v1.9.11 install.yaml (pinned tag, not master) inventory + schema validation; EventBus validated against the CRD;
the EventBus data plane = a real NATS JetStream server started from the exact natsImage (nats:2.10.29) that argo-events-controller-config maps to
JetStream version "latest"; stream created, event published and read back.
Simulated: controller-manager reconciling the EventBus into a StatefulSet (eventbus-default-js-*), pods Running.

Full mode:
kubectl apply -f namespace-argo-events.yaml
kubectl apply -n argo-events -f https://raw.githubusercontent.com/argoproj/argo-events/v1.9.11/manifests/install.yaml
kubectl -n argo-events rollout status deploy/controller-manager --timeout=180s     # single controller (not 3), not -w
kubectl -n argo-events logs deploy/controller-manager --tail=50
kubectl apply -f test-eventbus.yaml; kubectl -n argo-events rollout status statefulset/eventbus-default-js --timeout=180s
kubectl get eventbus default -n argo-events -o jsonpath='{.status.conditions}'
Uninstall: kubectl delete -n argo-events -f https://raw.githubusercontent.com/argoproj/argo-events/v1.9.11/manifests/install.yaml
