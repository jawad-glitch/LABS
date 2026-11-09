# Simulated steps (fast mode) - Lab 16 - Configure Sensors and Triggers in Argo Events
No cluster / controller ran. Real: NATS JetStream EventBus (nats:2.10.29 from Argo Events v1.9.11), webhook/file/calendar/resource event sources and sensors
built from the YAML in this folder (two stacks: lab-original vs fixed), and every triggered Job/Pod executed as a real container (logs in runs/).
Calendar */2 min compressed to 5s. Created objects are in cluster/orig and cluster/fixed.
Full mode: kubectl create ns argo-events --dry-run=client -o yaml | kubectl apply -f - ; kubectl apply -n argo-events -f https://raw.githubusercontent.com/argoproj/argo-events/v1.9.11/manifests/install.yaml ;
kubectl -n argo-events rollout status deploy/controller-manager --timeout=180s ; kubectl apply -f eventbus.yaml -f sensor-rbac.yaml (before sensors) -f *eventsource.yaml -f *sensor.yaml (fixed versions) ;
file test: kubectl exec <file-es-pod> -- sh -c 'rm -f /tmp/events/trigger.txt; echo hi > /tmp/events/trigger.txt' ; logs: kubectl -n argo-events logs deploy/controller-manager --tail=50
