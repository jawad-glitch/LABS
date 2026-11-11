#!/bin/bash
# Emulates 'kubectl apply' of a VirtualService (+ DestinationRule): regenerate the gateway config, hot-restart the gateway, wait until ready.
VSF=${1:?vs file}; DRF=${2:-$(cat /home/ubuntu/istio-lab19/envoy/current-dr 2>/dev/null || echo /home/ubuntu/istio-lab19/k8s/dr-plain.yaml)}; echo "$DRF" > /home/ubuntu/istio-lab19/envoy/current-dr; echo "$VSF" > /home/ubuntu/istio-lab19/envoy/current-vs
python3 /home/ubuntu/istio-lab19/envoy/gen.py "$VSF" "$DRF" 172.18.0.2,172.18.0.4,172.18.0.6 172.18.0.3,172.18.0.5,172.18.0.7 > /home/ubuntu/istio-lab19/envoy/gateway.yaml || exit 1
sudo docker restart -t 0 istio-ingressgateway >/dev/null
for i in $(seq 1 40); do [ "$(curl -s -m 1 http://127.0.0.1:15019/ready)" = LIVE ] && exit 0; sleep 0.25; done; exit 1
