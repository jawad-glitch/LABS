# Prometheus Lab 13 - Advanced Alerting Rules - completion proof
Completed (UTC): 2026-11-12 08:23:42 | EC2: i-0d11239ea78c07aa2 | host: ip-172-31-10-41 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Prometheus Lab 13 - Advanced Alerting Rules, 2026-11-12 08:23:35 UTC) - ALL REAL ==========
PASS: Step 1.1: lab 'wget -fsSL' invalid; curl + sha256 for Prometheus 2.51.2 and Alertmanager 0.27.0; versions print
PASS: Step 2.1: simulator serves # HELP lines for requests, duration histogram, app errors; 404 elsewhere
PASS: Step 2.2: promtool SUCCESS (config + both rule files); API lists 3 RECORDING + 6 ALERTING
PASS: All 9 rules health ok
PASS: Lab bug: '--config.file=~/...' is not tilde-expanded - Prometheus gets the literal ~ path and fails
PASS: Step 3.1: amtool SUCCESS (routing tree + 2 inhibit rules); cluster status ready; webhook receiver answers 200
PASS: Step 3.2: >= 2 alerts firing in Prometheus, including CriticalHTTPErrorRate and HighHTTPErrorRate
PASS: Silence: create returns an ID, list shows it active; HighHTTPErrorRate silencedBy=[that ID]
PASS: Delete: no active silences; HighHTTPErrorRate silencedBy=[] but inhibitedBy non-empty (CriticalHTTPErrorRate firing); bad subcommand exits 1
PASS: Webhooks: critical-webhook received CriticalHTTPErrorRate; backend-webhook received an alert; HighHTTPErrorRate never delivered
PASS: Webhooks: database-webhook received DatabaseErrorCorrelation (team=database route)
PASS: Time: finished in 183s (<= 300s)
CORE: 12/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./alerting-lab/alertmanager/alertmanager.pid
./alerting-lab/alertmanager/alertmanager.yml
./alerting-lab/app/simulator.pid
./alerting-lab/app/simulator.py
./alerting-lab/app/webhook.pid
./alerting-lab/app/webhook_receiver.py
./alerting-lab/logs/alertmanager.log
./alerting-lab/logs/prometheus.log
./alerting-lab/logs/simulator.log
./alerting-lab/logs/webhook.log
./alerting-lab/prometheus/data/lock
./alerting-lab/prometheus/data/queries.active
./alerting-lab/prometheus/data/wal/00000000
./alerting-lab/prometheus/prometheus.pid
./alerting-lab/prometheus/prometheus.yml
./alerting-lab/prometheus/rules/application_alerts.yml
./alerting-lab/prometheus/rules/recording.yml
./alerting-lab/results/bug-tilde-argument.txt
./alerting-lab/results/elapsed.txt
./alerting-lab/results/task1-install.txt
./alerting-lab/results/task2.1-simulator.txt
./alerting-lab/results/task2.2-promtool.txt
./alerting-lab/results/task2.2-rules-loaded.txt
./alerting-lab/results/task3.1-amtool.txt
./alerting-lab/results/task3.1-status.txt
./alerting-lab/results/task3.2-am-after-delete.txt
./alerting-lab/results/task3.2-am-silenced.txt
./alerting-lab/results/task3.2-before-silence.txt
./alerting-lab/results/task3.2-firing.txt
./alerting-lab/results/task3.2-silence-create-list.txt
./alerting-lab/results/task3.2-silence-delete.txt
./alerting-lab/results/task3.2-usage.txt
./alerting-lab/results/task3.2-webhook-deliveries.txt
./alerting-lab/scripts/silence_manager.py
```
