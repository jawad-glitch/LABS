# Prometheus Lab 5 - Install Blackbox Exporter - completion proof
Completed (UTC): 2026-11-11 20:54:28 | EC2: i-02efc835425a80c59 | host: ip-172-31-10-79 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Prometheus Lab 5 - Install Blackbox Exporter, 2026-11-11 20:54:22 UTC) - ALL REAL (live internet probes) ==========
PASS: Task 1: blackbox_exporter 0.24.0 sha256-verified, --version 0.24.0, config.check OK
PASS: Task 1.5/1.6: service enabled+active as blackbox_exporter, :9115 listening, build_info exposed
PASS: Lab bug: http_2xx hard-codes 'Host: example.com' - lab module fails where the fixed module succeeds
PASS: Lab bug: dns_udp can never pass (contradictory answer regexes) - 0; fixed dns_udp_fixed - 1
FAIL: TCP probes: google.com:80, google.com:443, 8.8.8.8:53 all probe_success 1
PASS: ICMP with CAP_NET_RAW (systemd AmbientCapabilities): 8.8.8.8 and google.com succeed
PASS: Task 2.3: promtool SUCCESS on lab config; lab's 'SUCCESS: 5 rule files found' does not appear
PASS: Lab confusion: all scrape targets 'up' while probes fail (example.com:8080 and Host-header probes = 0)
PASS: Fixed config: blackbox_http prometheus.io (http+https) and google.com = 1; DNS 8.8.8.8 + 1.1.1.1 = 1
PASS: Task 3.5 production sites probed (jsonplaceholder = 1 with the fixed module); TLS expiry metric available
PASS: Lab verification script's 'Prometheus integration' check passes while probes fail (too weak)
PASS: Time: finished in 83s (<= 300s)
CORE: 11/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./prometheus-lab5/etc/blackbox.yml
./prometheus-lab5/etc/blackbox_exporter.icmp.conf
./prometheus-lab5/etc/blackbox_exporter.service.lab
./prometheus-lab5/etc/prometheus.yml.fixed
./prometheus-lab5/etc/prometheus.yml.lab
./prometheus-lab5/results/elapsed.txt
./prometheus-lab5/results/fixed-cert-expiry.json
./prometheus-lab5/results/fixed-config.txt
./prometheus-lab5/results/fixed-durations.json
./prometheus-lab5/results/fixed-probe-success.json
./prometheus-lab5/results/fixed-promtool.txt
./prometheus-lab5/results/fixed-status-codes.json
./prometheus-lab5/results/prereq-download.txt
./prometheus-lab5/results/prereq.txt
./prometheus-lab5/results/task-icmp.txt
./prometheus-lab5/results/task1-install.txt
./prometheus-lab5/results/task1.2-ls.txt
./prometheus-lab5/results/task1.4-config-check.txt
./prometheus-lab5/results/task1.6-verify.txt
./prometheus-lab5/results/task2.3-promtool.txt
./prometheus-lab5/results/task3-lab-config.txt
./prometheus-lab5/results/task3.1-manual-probes.txt
./prometheus-lab5/results/task3.2-targets-lab.json
./prometheus-lab5/results/task3.4-probe-success-lab.json
./prometheus-lab5/results/task3.4-status-codes-lab.json
./prometheus-lab5/results/verification.txt
```
