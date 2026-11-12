# Prometheus Lab 12 - Integrate Prometheus with Alertmanager - completion proof
Completed (UTC): 2026-11-12 08:17:16 | EC2: i-057fd8a01ffbfc413 | host: ip-172-31-10-211 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Prometheus Lab 12 - Integrate Prometheus with Alertmanager, 2026-11-12 08:17:10 UTC) - CLUSTER/OPERATOR SIMULATED, CHART RENDER + ALERTMANAGER + PROMETHEUS REAL ==========
PASS: Task 1: helm (sha256) + kubeconform; images pulled; kind config maps 30090/30093
PASS: Lab claim wrong: kube-prometheus-stack installs Alertmanager by default (Alertmanager CR rendered)
PASS: Lab bug: chart Prometheus only selects rules labelled release=kps - the lab's rule labels are never loaded
PASS: Fixed values: ruleSelector {} (all rules), alerting -> monitoring/alertmanager:web, chart Alertmanager disabled
PASS: Lab bug: $SLACK_WEBHOOK_URL / $SMTP_PASSWORD are not interpolated - amtool rejects the config
PASS: Lab bug: email_configs has no subject/body fields - amtool rejects them
PASS: Task 2: fixed config (routes, inhibit_rules, *_file secrets) SUCCESS; all manifests schema-valid; /-/healthy OK on :30093
FAIL: Task 3.1: 7 rules loaded health ok; Prometheus lists the Alertmanager; SyntheticAlwaysFiring firing
PASS: Task 3.2: /api/v2/alerts has SyntheticAlwaysFiring active (warning-notify)
PASS: Inhibition: warning SyntheticInhibitionTest suppressed (inhibitedBy set), critical one active; no 'inhibited' field in v2
PASS: Routing: Slack payloads for warning (color warning) and critical (color danger); the suppressed warning was never sent
PASS: Logs: no 'Sending notification' line exists; 'Notify success' at debug; explicit email delivery error with placeholder creds
PASS: Time: finished in 56s (<= 300s)
CORE: 12/13 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE                       COMMAND                  CREATED          STATUS          PORTS                                           NAMES
bafc882b2e20   prom/prometheus:latest      "/bin/prometheus --c…"   30 seconds ago   Up 29 seconds   0.0.0.0:30090->9090/tcp, [::]:30090->9090/tcp   l12-prometheus
ef1829243f3e   prom/alertmanager:v0.27.0   "/bin/alertmanager -…"   30 seconds ago   Up 30 seconds   0.0.0.0:30093->9093/tcp, [::]:30093->9093/tcp   l12-alertmanager
30b133ced7ad   prom/node-exporter:latest   "/bin/node_exporter …"   31 seconds ago   Up 30 seconds                                                   l12-node-exporter

IMAGE                       ID             DISK USAGE   CONTENT SIZE   EXTRA
prom/alertmanager:v0.27.0   e13b6ed5cb92        106MB         32.4MB   U    
prom/node-exporter:latest   1b4e4438faca         41MB         13.4MB   U    
prom/prometheus:latest      e04987641b57        389MB          116MB   U    
```

## Files
```
./prom-lab12/am/alertmanager.yml
./prom-lab12/am/secrets/slack-webhook-url
./prom-lab12/am/secrets/smtp-password
./prom-lab12/k8s/alertmanager-configmap.yaml
./prom-lab12/k8s/alertmanager-deployment.yaml
./prom-lab12/k8s/alertmanager-secrets.yaml
./prom-lab12/k8s/alertmanager-service.yaml
./prom-lab12/k8s/kind-cluster-config.yaml
./prom-lab12/k8s/kps-values.yaml
./prom-lab12/k8s/prometheusrule-infrastructure-alerts.yaml
./prom-lab12/k8s/prometheusrule-inhibition-test-alerts.yaml
./prom-lab12/k8s/prometheusrule-synthetic-alerts.yaml
./prom-lab12/l12-slack-mock.py
./prom-lab12/lab-original/alertmanager-email-subject-body.yml
./prom-lab12/lab-original/alertmanager-env-interpolation.yml
./prom-lab12/prom/prometheus.yml
./prom-lab12/prom/rules/infrastructure-alerts.yml
./prom-lab12/prom/rules/inhibition-test-alerts.yml
./prom-lab12/prom/rules/synthetic-alerts.yml
./prom-lab12/results/SIMULATED.md
./prom-lab12/results/alertmanager.log
./prom-lab12/results/elapsed.txt
./prom-lab12/results/kps-rendered-default.yaml
./prom-lab12/results/prometheus.log
./prom-lab12/results/slack-mock-received.jsonl
./prom-lab12/results/task1.1-docker.txt
./prom-lab12/results/task1.1-tools.txt
./prom-lab12/results/task1.2-chart-analysis.txt
./prom-lab12/results/task2-kubeconform.txt
./prom-lab12/results/task2.1-amtool.txt
./prom-lab12/results/task2.2-running.txt
./prom-lab12/results/task3.1-alertmanagers.json
./prom-lab12/results/task3.1-prom-alerts.json
./prom-lab12/results/task3.1-prometheus.txt
./prom-lab12/results/task3.1-promtool.txt
./prom-lab12/results/task3.1-rules.json
./prom-lab12/results/task3.2-alertmanager.txt
./prom-lab12/results/task3.2-am-alerts.json
./prom-lab12/results/task3.2-logs.txt
./prom-lab12/results/task3.2-slack-deliveries.txt
./prom-lab12/slack-mock.pid
```
