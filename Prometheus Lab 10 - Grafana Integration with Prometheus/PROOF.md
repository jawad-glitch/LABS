# Prometheus Lab 10 - Grafana Integration with Prometheus - completion proof
Completed (UTC): 2026-11-12 08:06:32 | EC2: i-033e68b41775f60ac | host: ip-172-31-10-222 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Prometheus Lab 10 - Grafana Integration with Prometheus, 2026-11-12 08:06:25 UTC) - ALL REAL (Grafana 13.3.1) ==========
PASS: Setup: prometheus, node-exporter, grafana images pulled; ports free
PASS: Lab bug: mounting /tmp/prometheus.yml before it exists makes Docker create a directory; Prometheus does not run
PASS: Lab bug: inside the Prometheus container localhost:9100 is the container itself -> node-exporter target DOWN
PASS: Task 2: Grafana healthy (database ok), /login 200, admin/admin123 authenticates
PASS: Lab bug: data source http://localhost:9090 fails Save & Test from the Grafana container
PASS: Fixed: shared network + host-networked node-exporter - both targets up, data source http://prometheus:9090 OK
PASS: Bridge node-exporter saw only container interfaces; host-networked one sees the VM interfaces
PASS: Tasks 4-7: dashboard saved with 6 panels, tags monitoring/system/prometheus, refresh 5s, last 15 minutes
```

## Docker snapshot
```
CONTAINER ID   IMAGE                       COMMAND                  CREATED              STATUS              PORTS                                         NAMES
ce081847896b   prom/prometheus:latest      "/bin/prometheus --c…"   About a minute ago   Up About a minute   0.0.0.0:9090->9090/tcp, [::]:9090->9090/tcp   prometheus
e9327213a1ba   prom/node-exporter:latest   "/bin/node_exporter …"   About a minute ago   Up About a minute                                                 node-exporter
6f770f55ea80   grafana/grafana:latest      "/run.sh"                About a minute ago   Up About a minute   0.0.0.0:3000->3000/tcp, [::]:3000->3000/tcp   grafana

IMAGE                       ID             DISK USAGE   CONTENT SIZE   EXTRA
grafana/grafana:latest      0615ec4fbd40       2.02GB          506MB   U    
prom/node-exporter:latest   1b4e4438faca         41MB         13.4MB   U    
prom/prometheus:latest      e04987641b57        389MB          116MB   U    
```

## Files
```
./prom-lab10/grafana-backups/backup-dashboard-fixed.sh
./prom-lab10/grafana-backups/backup-dashboard.sh
./prom-lab10/grafana-backups/dashboard-20261112-080624.json
./prom-lab10/grafana-backups/dashboard-system-monitoring-20261112-080624.json
./prom-lab10/grafana-backups/system-monitoring-dashboard.json
./prom-lab10/prometheus.yml.fixed
./prom-lab10/prometheus.yml.lab
./prom-lab10/results/bug-task1.1-mount-before-file.txt
./prom-lab10/results/elapsed.txt
./prom-lab10/results/final-verification.txt
./prom-lab10/results/grafana.log
./prom-lab10/results/prometheus.log
./prom-lab10/results/setup-docker-access.txt
./prom-lab10/results/setup-pull.txt
./prom-lab10/results/task1-lab-topology.txt
./prom-lab10/results/task2-grafana.txt
./prom-lab10/results/task3-ds-create-lab.json
./prom-lab10/results/task3-ds-health-fixed.json
./prom-lab10/results/task3-ds-health-lab.json
./prom-lab10/results/task3-ds-lab.txt
./prom-lab10/results/task3-ds-update-fixed.json
./prom-lab10/results/task3-fixed.txt
./prom-lab10/results/task6-dashboard-save.json
./prom-lab10/results/task6-dashboard.txt
./prom-lab10/results/task8.1-load.txt
./prom-lab10/results/task8.2-panels.txt
./prom-lab10/results/task9-backup.txt
./prom-lab10/results/troubleshooting-docker-update.txt
./prom-lab10/system-monitoring-dashboard.export.json
./prom-lab10/system-monitoring-dashboard.request.json
```
