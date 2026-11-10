# Simulated steps - Lab 16 - Configuring Cilium with Service Meshes
Runtime (cluster, Cilium agents, Istio control plane, Bookinfo pods, traffic, mTLS, metrics) NOT executed: ~2.5 GB of images and ~3 GB RAM
(3-node kind + Cilium + istiod + ingress gateway + Bookinfo incl. Java reviews + Prometheus) exceed this 3.8 GB VM and the 5-minute budget.
Real in this run: tool installs (sha256), current Cilium chart rejecting the lab flags and rendering the fixed values, Istio 1.32.0 control plane rendered
offline (labels/names/images), official Bookinfo from the Istio 1.32.0 release, strict CRD-schema validation, istioctl analyze --use-kube=false.

## Full-mode commands (in order)
kind create cluster --config fixed/kind-config.yaml
helm install cilium cilium/cilium --version 1.20.4 -n kube-system -f fixed/cilium-values.yaml && cilium status --wait
istioctl install --set profile=default -y && kubectl -n istio-system rollout status deploy/istiod deploy/istio-ingressgateway --timeout=300s
kubectl label namespace default istio-injection=enabled --overwrite
kubectl apply -f fixed/bookinfo-app.yaml && kubectl wait --for=condition=available deploy --all --timeout=600s
kubectl apply -f fixed/bookinfo-gateway.yaml -f fixed/destination-rules.yaml -f fixed/reviews-virtualservice.yaml
kubectl run test-pod --image=curlimages/curl:8.11.1 --rm -i --restart=Never -- curl -s http://productpage:9080/productpage   (no -it)
nohup kubectl -n istio-system port-forward svc/istio-ingressgateway 8080:80 >pf.log 2>&1 &   (bounded wait, then curl /productpage)
kubectl apply -f fixed/cilium-network-policy.yaml -f fixed/peer-authentication.yaml -f fixed/authorization-policy.yaml
kubectl apply -f istio-1.32.0/samples/addons/prometheus.yaml && kubectl -n istio-system rollout status deploy/prometheus --timeout=300s
cilium hubble port-forward & ; hubble observe --pod default/productpage --last 50   (NOT 'cilium hubble observe')
istioctl analyze ; istioctl proxy-config cluster deploy/productpage-v1
