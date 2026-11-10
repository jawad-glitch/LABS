# Lab 20 - Advanced Cilium Troubleshooting - completion proof
Completed (UTC): 2026-11-10 08:14:10 | EC2: i-0609c03893810d7b0 | host: ip-172-31-10-158 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 20 - Advanced Cilium Troubleshooting, 2026-11-10 08:14:05 UTC) ==========
FAIL: Step 1.1: Cilium 1.20.4 as sole CNI; cilium status OK incl. Hubble Relay OK and Hubble UI OK
PASS: Step 1.1: hubble CLI v1.20.4 via Relay - status healthy with non-zero flows/s
PASS: Step 1.2: Prometheus scrapes agent :9962 and Hubble :9965 (both up); cilium_endpoint = 11 (> 0)
PASS: Step 1.2: test-apps frontend/backend/database Running with tier labels; baseline 200 + db reachable
PASS: Step 2.1 A: cilium monitor drop log references backend IP 10.244.0.210 (24 lines, Policy denied)
PASS: Step 2.1 A: Hubble DROPPED flows with destination tier=backend (50)
FAIL: Step 2.1 B: dns-isolated cannot resolve svc names; Hubble port-53 flows show DNS errors (0)
PASS: Step 2.1: Prometheus Policy-denied drop rate during failure = 0.217391 (> 0)
PASS: Step 2.2: frontend curl to backend = 200; backend->database OK; dns-isolated removed
PASS: Step 2.2: zero DROPPED test-apps flows since remediation; drop rate back to 0 (< 0.05/s)
FAIL: Lab bugs evidenced: --verdict DENIED invalid in hubble CLI; in-pod cilium monitor renamed (cilium-dbg)
PASS: incident-report.txt: 4 sections with failure (0.217391) and post-remediation (0) rates
FAIL: Time: lab finished in 1013s (<= 300s)
CORE: 9/13 PASS
```

## Cluster snapshot
```
error: the server doesn't have a resource type "clusterpolicy"

NAMESPACE            NAME                                               READY   STATUS    RESTARTS   AGE
kube-system          cilium-envoy-s7gp9                                 1/1     Running   0          14m
kube-system          cilium-operator-77b647479f-8pt5s                   1/1     Running   0          14m
kube-system          cilium-p895h                                       1/1     Running   0          14m
kube-system          coredns-559f6c778d-c8bx4                           1/1     Running   0          15m
kube-system          coredns-559f6c778d-nfjg2                           1/1     Running   0          15m
kube-system          etcd-cilium-lab-control-plane                      1/1     Running   0          15m
kube-system          hubble-relay-59bb8bbb55-bpf2m                      1/1     Running   0          14m
kube-system          hubble-ui-647df7f64c-br4ql                         2/2     Running   0          14m
kube-system          kube-apiserver-cilium-lab-control-plane            1/1     Running   0          15m
kube-system          kube-controller-manager-cilium-lab-control-plane   1/1     Running   0          15m
kube-system          kube-proxy-ksvgh                                   1/1     Running   0          15m
kube-system          kube-scheduler-cilium-lab-control-plane            1/1     Running   0          15m
local-path-storage   local-path-provisioner-75f7fc7dc5-fg28q            1/1     Running   0          15m
test-apps            backend-6d869d7bd5-qwv6j                           1/1     Running   0          12m
test-apps            database-7d87b6ffd5-fns78                          1/1     Running   0          12m
test-apps            frontend-c864bc8b9-lxspf                           1/1     Running   0          12m

NAME  	NAMESPACE  	REVISION	UPDATED                               	STATUS  	CHART        	APP VERSION
cilium	kube-system	1       	2026-11-10 07:59:59.41022977 +0000 UTC	deployed	cilium-1.20.4	1.20.4     
```

## Docker snapshot
```
CONTAINER ID   IMAGE                     COMMAND                  CREATED          STATUS          PORTS                       NAMES
1e6354099cfe   prom/prometheus:v3.16.0   "/bin/prometheus --c…"   12 minutes ago   Up 12 minutes   127.0.0.1:9090->9090/tcp    l20-prom
2cab200e326e   kindest/node:v1.37.0      "/usr/local/bin/entr…"   16 minutes ago   Up 16 minutes   127.0.0.1:36969->6443/tcp   cilium-lab-control-plane

IMAGE                                                                                     ID             DISK USAGE   CONTENT SIZE   EXTRA
busybox:1.36                                                                              73aaf090f3d8       6.76MB         2.21MB        
kindest/node@sha256:a1ed56cfb0e7b93589bdf97c8cd566405a265939e3620fc4f5de89adff580ae5      a1ed56cfb0e7       1.34GB          388MB   U    
nginx:1.27-alpine                                                                         65645c7bb6a0       74.5MB         21.9MB        
prom/prometheus:v3.16.0                                                                   e04987641b57        389MB          116MB   U    
quay.io/cilium/cilium-envoy:v1.39.5-1792733054-8c73b2816bc8239e27f1fd53b271884688137459   547ab45f6092        290MB         78.3MB        
quay.io/cilium/cilium:v1.20.4                                                             20fe92e4c866        999MB          256MB        
quay.io/cilium/hubble-relay:v1.20.4                                                       cb2340820969        109MB         24.4MB        
quay.io/cilium/hubble-ui-backend:v0.13.6                                                  83b3fc763f3d       99.1MB         22.2MB        
quay.io/cilium/hubble-ui:v0.13.6                                                          049a80a03585       48.2MB         11.5MB        
quay.io/cilium/operator-generic:v1.20.4                                                   7a7a3489dc66        165MB         36.9MB        
redis:7-alpine                                                                            7b1753b4c5ad       58.5MB         16.9MB        
```

## Files
```
./cilium-troubleshoot-lab20/cilium-monitor-drops.log
./cilium-troubleshoot-lab20/hubble-dns-port53.log
./cilium-troubleshoot-lab20/hubble-dropped.log
./cilium-troubleshoot-lab20/kind-config.yaml
./cilium-troubleshoot-lab20/manifests/cilium-values.yaml
./cilium-troubleshoot-lab20/manifests/misconfig-a-blackhole.yaml
./cilium-troubleshoot-lab20/manifests/misconfig-b-dns-isolated.yaml
./cilium-troubleshoot-lab20/manifests/test-apps.yaml
./cilium-troubleshoot-lab20/prom/prometheus.yml
./cilium-troubleshoot-lab20/results/bug-lab-cilium-monitor-renamed.txt
./cilium-troubleshoot-lab20/results/bug-lab-verdict-DENIED.txt
./cilium-troubleshoot-lab20/results/cilium-monitor-drops.log
./cilium-troubleshoot-lab20/results/elapsed.txt
./cilium-troubleshoot-lab20/results/hubble-dns-port53.log
./cilium-troubleshoot-lab20/results/hubble-dropped.log
./cilium-troubleshoot-lab20/results/hubble-follow-test-apps.json
./cilium-troubleshoot-lab20/results/hubble-port-forward.log
./cilium-troubleshoot-lab20/results/image-pull.log
./cilium-troubleshoot-lab20/results/incident-report.txt
./cilium-troubleshoot-lab20/results/install-cilium-cli.log
./cilium-troubleshoot-lab20/results/install-helm.log
./cilium-troubleshoot-lab20/results/install-hubble-cli.log
./cilium-troubleshoot-lab20/results/install-kind.log
./cilium-troubleshoot-lab20/results/install-kubectl.log
./cilium-troubleshoot-lab20/results/kind-create.txt
./cilium-troubleshoot-lab20/results/kind-load.txt
./cilium-troubleshoot-lab20/results/step1.1-cilium-status-wait.txt
./cilium-troubleshoot-lab20/results/step1.1-cilium-status.txt
./cilium-troubleshoot-lab20/results/step1.1-helm-install.txt
./cilium-troubleshoot-lab20/results/step1.1-hubble-status.txt
./cilium-troubleshoot-lab20/results/step1.2-apply-apps.txt
./cilium-troubleshoot-lab20/results/step1.2-baseline.txt
./cilium-troubleshoot-lab20/results/step1.2-endpoint-metric.txt
./cilium-troubleshoot-lab20/results/step1.2-prom-targets.txt
./cilium-troubleshoot-lab20/results/step1.2-test-apps-pods.txt
./cilium-troubleshoot-lab20/results/step2.1-apply-misconfigs.txt
./cilium-troubleshoot-lab20/results/step2.1-hubble-analysis.txt
./cilium-troubleshoot-lab20/results/step2.1-symptom-dns-isolated.txt
./cilium-troubleshoot-lab20/results/step2.1-symptom-frontend-to-backend.txt
./cilium-troubleshoot-lab20/results/step2.2-dns-pod-gone.txt
./cilium-troubleshoot-lab20/results/step2.2-post-dropped.txt
./cilium-troubleshoot-lab20/results/step2.2-post-frontend-to-backend.txt
./cilium-troubleshoot-lab20/results/step2.2-remediate.txt
./cilium-troubleshoot-lab20/results/step2.2-verify.txt
./cilium-troubleshoot-lab20/results/versions.txt
```
