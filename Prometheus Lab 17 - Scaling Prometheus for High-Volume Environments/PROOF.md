# Prometheus Lab 17 - Scaling Prometheus for High-Volume Environments - completion proof
Completed (UTC): 2026-11-12 08:43:23 | EC2: i-08efbec215f931133 | host: ip-172-31-10-7 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Prometheus Lab 17 - Scaling Prometheus for High-Volume Environments, 2026-11-12 08:43:16 UTC) - ALL REAL ==========
PASS: Setup: lab images pulled (prometheus v2.45.0, thanos v0.32.0, node-exporter v1.6.0); docker compose available
PASS: Lab bug: compose up before config/prometheus.yml exists -> Docker creates a directory; Prometheus cannot start
PASS: Lab bug: node-exporter appended after the top-level networks: block - docker compose config rejects the file
PASS: Lab bug: ./data/prometheus (755, your user) is not writable by the image user nobody - Prometheus fails
PASS: Fixed stack: 6 containers running; all 5 scrape targets up; external labels cluster/replica set
PASS: Lab bug: raw [5m] in the test-queries URL fails; fixed range query returns series; Thanos sees the same metric names
PASS: Lab bug: performance-test.sh raw URLs - at most 1/5 succeed; fixed 5/5
PASS: Thanos Query federates both stores (sidecar + store gateway); 15-minute range via Thanos returns series
PASS: Within the lab's time frame: sidecar uploaded 0 blocks and the store gateway has 0 loaded (2h blocks)
PASS: Lab bug: --query.replica-label dedups away 'replica' (null in the lab script); dedup=false brings it back
FAIL: Health: Prometheus, sidecar, store and query /-/healthy answer
PASS: Time: finished in 108s (<= 300s)
CORE: 11/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE                       COMMAND                  CREATED              STATUS              PORTS                                                                                              NAMES
b439d830e5e6   thanosio/thanos:v0.32.0     "/bin/thanos query -…"   About a minute ago   Up About a minute   0.0.0.0:19090->9090/tcp, [::]:19090->9090/tcp                                                      thanos-query
b4c62655aaa3   thanosio/thanos:v0.32.0     "/bin/thanos sidecar…"   About a minute ago   Up About a minute   0.0.0.0:10901-10902->10901-10902/tcp, [::]:10901-10902->10901-10902/tcp                            thanos-sidecar
d28d80a4337f   prom/prometheus:v2.45.0     "/bin/prometheus --c…"   About a minute ago   Up About a minute   0.0.0.0:9090->9090/tcp, [::]:9090->9090/tcp                                                        prometheus
1ab4173ef629   thanosio/thanos:v0.32.0     "/bin/thanos compact…"   About a minute ago   Up About a minute                                                                                                      thanos-compactor
5df2f8da8f83   prom/node-exporter:v1.6.0   "/bin/node_exporter …"   About a minute ago   Up About a minute   0.0.0.0:9100->9100/tcp, [::]:9100->9100/tcp                                                        node-exporter
318cd01a6a02   thanosio/thanos:v0.32.0     "/bin/thanos store -…"   About a minute ago   Up About a minute   0.0.0.0:10903->10901/tcp, [::]:10903->10901/tcp, 0.0.0.0:10904->10902/tcp, [::]:10904->10902/tcp   thanos-store

IMAGE                       ID             DISK USAGE   CONTENT SIZE   EXTRA
prom/node-exporter:v1.6.0   d2e48098c364       36.9MB         11.7MB   U    
prom/prometheus:v2.45.0     9309deb7c981        334MB         93.7MB   U    
thanosio/thanos:v0.32.0     f725f038fab9        260MB           80MB   U    
```

## Files
```
./config/bucket.yml
./config/prometheus.yml
./docker-compose.fixed.yml
./docker-compose.yml
./federation-test.sh
./performance-test-fixed.sh
./performance-test.sh
./results/bucket.yml
./results/bug-data-dir-permissions.txt
./results/bug-task1.4-config-missing.txt
./results/bug-task2.2-append.txt
./results/docker-compose.fixed.yml
./results/docker-compose.lab-after-append.yml
./results/docker-compose.lab-task1.3.yml
./results/elapsed.txt
./results/health.txt
./results/log-node-exporter.txt
./results/log-prometheus.txt
./results/log-thanos-compactor.txt
./results/log-thanos-query.txt
./results/log-thanos-sidecar.txt
./results/log-thanos-store.txt
./results/prometheus.yml
./results/setup-compose.txt
./results/setup-pull.txt
./results/task1.1-dirs.txt
./results/task2-stack.txt
./results/task3.3-summary.txt
./results/task3.3-test-queries-lab.txt
./results/task3.4-performance-fixed.txt
./results/task3.4-performance-lab.txt
./results/task3.4-summary.txt
./results/task3.5-store.txt
./results/task3.6-federation-lab.txt
./results/task3.6-summary.txt
./test-queries.sh
```
