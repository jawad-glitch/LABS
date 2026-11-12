# Lab 18 - Multi-Cluster Prometheus Setup - completion proof
Completed (UTC): 2026-11-12 08:50:14 | EC2: i-0e1034226eb5f85f9 | host: ip-172-31-10-253 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 18 - Multi-Cluster Prometheus Setup, 2026-11-12 08:50:09 UTC) ==========
PASS: Prometheus Binary installed
PASS: Cluster B Prom Config Valid
PASS: Cluster A Prom Config Valid
PASS: Cluster B Prometheus Healthy on port 9091
PASS: Cluster A Primary Prometheus Healthy on port 9090
PASS: Cluster B Federation Endpoint Active
PASS: Cluster A Query Federation Results
PASS: Cluster A Cross-Cluster App Metrics
CORE: 8/8 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./prometheus-multicluster/cluster-a/data/lock
./prometheus-multicluster/cluster-a/data/queries.active
./prometheus-multicluster/cluster-a/data/wal/00000000
./prometheus-multicluster/cluster-a/mock_app.pid
./prometheus-multicluster/cluster-a/node_exporter.pid
./prometheus-multicluster/cluster-a/prometheus.pid
./prometheus-multicluster/cluster-a/prometheus.yml
./prometheus-multicluster/cluster-b/data/lock
./prometheus-multicluster/cluster-b/data/queries.active
./prometheus-multicluster/cluster-b/data/wal/00000000
./prometheus-multicluster/cluster-b/mock_app.pid
./prometheus-multicluster/cluster-b/node_exporter.pid
./prometheus-multicluster/cluster-b/prometheus.pid
./prometheus-multicluster/cluster-b/prometheus.yml
./prometheus-multicluster/exporters/mock_app_cluster_a.py
./prometheus-multicluster/exporters/mock_app_cluster_b.py
./prometheus-multicluster/results/federate-b.txt
./prometheus-multicluster/results/health-a.txt
./prometheus-multicluster/results/health-b.txt
./prometheus-multicluster/results/prometheus-a.log
./prometheus-multicluster/results/prometheus-b.log
./prometheus-multicluster/results/promtool-a.txt
./prometheus-multicluster/results/promtool-b.txt
./prometheus-multicluster/results/query-requests.txt
./prometheus-multicluster/results/query-up.txt
```
