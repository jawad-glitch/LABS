# Simulated steps (fast mode) - Lab 15 - Configure Event Sources in Argo Events
No cluster / Argo Events controller ran. Real: NATS JetStream EventBus (nats:2.10.29, from v1.9.11 controller config); webhook HTTP endpoint built from
webhook-eventsource.yaml (port/endpoint/method) also on the NodePort 31000; calendar emitter from cron-eventsource.yaml (*/2 min compressed to 4s);
two sensor runtimes subscribed to the bus applying the lab-original and fixed Sensor YAML (dependency match, dataKey, dest, defaults, create).
Generated ConfigMaps are in generated/original and generated/fixed and were strictly schema-validated.

Full mode: kubectl create ns argo-events --dry-run=client -o yaml | kubectl apply -f - ;
kubectl apply -n argo-events -f https://raw.githubusercontent.com/argoproj/argo-events/v1.9.11/manifests/install.yaml ;
kubectl apply -f eventbus.yaml -f webhook-rbac.yaml (RBAC before sensors) -f webhook-eventsource.yaml -f webhook-service.yaml -f webhook-sensor.yaml -f cron-eventsource.yaml -f cron-sensor.yaml ;
kubectl -n argo-events wait --for=condition=Ready pods -l eventsource-name=webhook-eventsource --timeout=180s ;
kubectl -n argo-events wait --for=create cm -l app=cron-configmap --timeout=180s   (instead of watch & + sleep 240)
