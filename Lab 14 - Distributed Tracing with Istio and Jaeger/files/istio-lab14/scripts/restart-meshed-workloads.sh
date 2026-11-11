#!/bin/bash
# Lab's loop deletes EVERY pod outside kube-system/istio-system/jaeger (incl. bare Pods that never come back).
# Only meshed workloads need a restart to pick up new proxy config:
for ns in $(kubectl get ns -l istio-injection=enabled -o name | cut -d/ -f2); do kubectl -n $ns rollout restart deploy; kubectl -n $ns rollout status deploy --timeout=180s; done
