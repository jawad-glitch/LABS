# Lab 6 - Context Propagation Across Two Services - completion proof
Completed (UTC): 2026-11-07 00:07:51 | EC2: i-0cc9d80b27e53a8f8 | host: ip-172-31-10-89 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 6 - Context Propagation Across Two Services, 2026-11-07 00:07:48 UTC) ==========
FAIL: Task 1: OTel API/SDK + Flask/Requests instrumentation installed
FAIL: Task 4: both services listened on 8000 and 9000; health OK
PASS: Task 4.4: /process completed with worker_response (42 items)
PASS: Task 6: test script made 3 successful requests
FAIL: Task 5: same trace_id across services; worker SERVER span parented by main CLIENT span
PASS: Task 6.3: multiple requests -> separate trace trees (>=5 distinct trace_ids)
FAIL: Task 7: worker logs W3C traceparent (00-<trace>-<parent>-<flags>)
FAIL: Task 7: traceparent trace_id + parent_id match the main service's CLIENT span
PASS: Cleanup: both services stopped
CORE: 4/9 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./lab6-context-propagation/app.py
./lab6-context-propagation/main.log
./lab6-context-propagation/otel06-analysis.txt
./lab6-context-propagation/otel06-main-health.json
./lab6-context-propagation/otel06-pkgs.txt
./lab6-context-propagation/otel06-ports.txt
./lab6-context-propagation/otel06-process-1.json
./lab6-context-propagation/otel06-process-2.json
./lab6-context-propagation/otel06-process-3.json
./lab6-context-propagation/otel06-test.txt
./lab6-context-propagation/otel06-traceparent.txt
./lab6-context-propagation/otel06-worker-health.json
./lab6-context-propagation/test_propagation.py
./lab6-context-propagation/worker-all.log
./lab6-context-propagation/worker-run1.log
./lab6-context-propagation/worker.log
./lab6-context-propagation/worker.py
```
