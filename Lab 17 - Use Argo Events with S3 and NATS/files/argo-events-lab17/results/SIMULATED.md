# Simulated steps (fast mode) - Lab 17 - Use Argo Events with S3 and NATS
Real: NATS broker (nats:2.10-alpine), MinIO (minio/minio:RELEASE.2023-11-20T22-40-07Z) with native bucket notification to NATS (mc event add ... --event put), real uploads with mc,
real s3:ObjectCreated:Put events on s3.file.uploaded (raw payloads in s3-events-raw/), JetStream EventBus (nats:2.10.29), the WorkflowTemplate's
container executed per workflow with Argo parameter substitution (logs in runs/).
Simulated: cluster, Argo Events controllers (NATS EventSource + Sensor runtimes follow Argo's event data contract {subject, body, header}),
Argo Workflows controller (single-step template run directly).
Full mode: kind create cluster (add extraPortMappings for 30900 or use port-forward) ; kubectl apply -n argo-events -f https://raw.githubusercontent.com/argoproj/argo-events/v1.9.11/manifests/install.yaml ;
kubectl apply -f eventbus.yaml -f nats-deployment.yaml -f minio-deployment.yaml -f sensor-rbac.yaml -f nats-event-source.yaml -f s3-processing-workflow.yaml -f nats-sensor.yaml ;
kubectl -n argo-events port-forward svc/minio 9000:9000 & mc alias set local http://localhost:9000 minioadmin minioadmin123 ; mc mb local/event-bucket ;
mc event add local/event-bucket arn:minio:sqs::PRIMARY:nats --event put ; mc cp test-file.txt local/event-bucket/ ; kubectl -n argo-events wait --for=jsonpath='{.status.phase}'=Succeeded workflow --all --timeout=180s
