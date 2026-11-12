# Prometheus Lab 9 - Visualization with Prometheus Expression Browser - completion proof
Completed (UTC): 2026-11-12 07:59:13 | EC2: i-090a3b016287fadc3 | host: ip-172-31-10-103 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Prometheus Lab 9 - Visualization with Prometheus Expression Browser, 2026-11-12 07:59:05 UTC) - ALL REAL ==========
PASS: Task 1: prometheus + node_exporter started with the lab commands; both targets up
PASS: Task 2: metric list, metadata (counter) and instant queries for CPU/memory/filesystem return data
PASS: Lab bug: Subtask 2.1 'curl | grep prometheus' gets the 302 redirect and finds nothing
PASS: Lab bug: all 8 raw-URL query_range curls fail (curl exit 3: glob [..] / spaces) -> nothing to parse
PASS: Lab bug: Subtask 4.5 'echo "...")' is a bash syntax error
PASS: Fixed 3.1/3.2: --data-urlencode range queries return data; CPU rose under the yes load
FAIL: Lab bug: lab's bytearray(100 MiB) is barely resident (< 50 MiB RSS); the written buffer is >= 95 MiB
PASS: Fixed 3.3/3.4: memory % and used-GiB range queries return data
PASS: Task 4.1-4.6 fixed: high/low resolution, by-mode and disk-read queries return data
PASS: Subtask 4.3/4.4: lab scripts run; 15 s step yields more points than 60 s; 4 analyses
PASS: Subtask 4.7: verify script all OK; its 'Last scrape' (~0 s) is query time, real scrape age shown from targets
PASS: Lab bug: lab_summary prints 'Successfully completed' unconditionally; its disk % is result[0] of several mounts
PASS: Time: finished in 96s (<= 300s)
CORE: 12/13 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./prom-lab9/cpu_load.pid
./prom-lab9/cpu_load_generator.sh
./prom-lab9/lab_summary.py
./prom-lab9/mem_fixed.pid
./prom-lab9/memory_load_generator.sh
./prom-lab9/node_exporter.pid
./prom-lab9/prometheus.pid
./prom-lab9/resolution_comparison.py
./prom-lab9/results/bug-lab-query-range-urls.txt
./prom-lab9/results/bug-subtask4.5-syntax.txt
./prom-lab9/results/cleanup-pkill-scope.txt
./prom-lab9/results/elapsed.txt
./prom-lab9/results/final-lab-summary.txt
./prom-lab9/results/node_exporter.log
./prom-lab9/results/prometheus.log
./prom-lab9/results/prometheus.yml
./prom-lab9/results/setup.txt
./prom-lab9/results/task1.1-install.txt
./prom-lab9/results/task1.1-versions.txt
./prom-lab9/results/task1.3-verify.txt
./prom-lab9/results/task2.txt
./prom-lab9/results/task3.1-3.2.txt
./prom-lab9/results/task3.1-cpu-rate.json
./prom-lab9/results/task3.2-cpu-util.json
./prom-lab9/results/task3.3-3.4.txt
./prom-lab9/results/task3.3-mem-util.json
./prom-lab9/results/task3.4-mem-used.json
./prom-lab9/results/task4.1-4.6.txt
./prom-lab9/results/task4.1-highres.json
./prom-lab9/results/task4.2-lowres.json
./prom-lab9/results/task4.3-4.4-summary.txt
./prom-lab9/results/task4.3-resolution.txt
./prom-lab9/results/task4.4-windows.txt
./prom-lab9/results/task4.5-by-mode.json
./prom-lab9/results/task4.6-disk.json
./prom-lab9/results/task4.7-verify.txt
./prom-lab9/time_window_analysis.py
./prom-lab9/verify_metrics.sh
```
