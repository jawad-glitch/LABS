# Prometheus Lab 16 - Backup and Restore Prometheus Data - completion proof
Completed (UTC): 2026-11-12 08:37:48 | EC2: i-039f428c2f10fac9d | host: ip-172-31-10-57 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Prometheus Lab 16 - Backup and Restore Prometheus Data, 2026-11-12 08:37:42 UTC) - ALL REAL ==========
PASS: Task 1.1: lab 'wget -fsSL' invalid; Prometheus 2.51.2 sha256 OK; service active with the lab unit
PASS: Task 1.2: config API success, admin snapshot 200, WAL segments, promtool OK; lab's '1 rule files found' line absent
PASS: Task 2.1: prom-backup.sh exit 0; archive passes tar -tzf; contains backup_metadata.json + block dirs; start/end log, no errors
PASS: Task 2.2: cron active with both entries; verify exits 0 with OK, and 1 with ALERT on an empty backup dir
PASS: Task 3.1: restore --list lists archives newest first
FAIL: Task 3.2 drill: restore --latest exit 0, Prometheus serving, no baseline metric name missing
FAIL: Task 3.2 drill: query_range has > 1 'up' value and samples from before the data loss; no rollback in the drill
PASS: Lab gap: the drill empties the data dir first, so the rollback point stop_and_preserve creates is empty
PASS: Lab gap: liveness-only post_restore_verify reports success for a 0-block archive (history gone); fixed pre-check refuses it
FAIL: Auto-rollback: corrupted block passes pre-checks, Prometheus fails, ROLLBACK_TRIGGERED, service active with the previous data
PASS: Final: verify exits 0; prometheus active
PASS: Time: finished in 72s (<= 300s)
CORE: 9/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./prom-lab16/etc/prometheus.service
./prom-lab16/etc/prometheus.yml
./prom-lab16/results/crontab.txt
./prom-lab16/results/drill-baseline-names.txt
./prom-lab16/results/drill-baseline.txt
./prom-lab16/results/drill-recovered-names.txt
./prom-lab16/results/drill-restore.txt
./prom-lab16/results/drillA-empty-archive.txt
./prom-lab16/results/drillB-rollback.txt
./prom-lab16/results/elapsed.txt
./prom-lab16/results/prom-backup-verify.log
./prom-lab16/results/prom-backup.log
./prom-lab16/results/prom-restore.log
./prom-lab16/results/task1.1-install.txt
./prom-lab16/results/task1.2-promtool.txt
./prom-lab16/results/task1.2-verify.txt
./prom-lab16/results/task2.1-backup.txt
./prom-lab16/results/task2.2-verify-cron.txt
./prom-lab16/results/task3.1-list.txt
./prom-lab16/scripts/prom-backup-verify.sh
./prom-lab16/scripts/prom-backup.sh
./prom-lab16/scripts/prom-restore.sh
```
