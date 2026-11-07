# Lab 8 - Correlated Logs with Trace IDs - completion proof
Completed (UTC): 2026-11-07 00:21:30 | EC2: i-03db89731ed56c8a3 | host: ip-172-31-10-74 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 8 - Correlated Logs with Trace IDs, 2026-11-07 00:21:27 UTC) ==========
PASS: Task 1: opentelemetry-api, -sdk, -instrumentation-logging installed in venv
PASS: Task 2: custom format applied ('- LEVEL - [trace_id=... span_id=...] - message')
PASS: Task 3.2: demo ran; in-span logs carry 32-hex trace_id + 16-hex span_id
PASS: Task 3.3: logs outside spans show trace_id=0 (no active span)
PASS: Task 3.3: every in-span log's trace_id+span_id matches an exported span
PASS: Task 3.3: logs land in the correct span (Validating->validate_user_data, Saving->save_user_data)
PASS: Task 3.3: user 999 error log correlated with span that recorded the exception
PASS: Task 3.4: analyze_logs.py finds 5 traces with nested spans
PASS: Task 3.6: enhanced demo ran; DEBUG logs emitted (level honoured) and all correlated
PASS: Task 3.7: verify_correlation.py passed (nested spans found)
CORE: 10/10 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./otel-logging-lab/analysis.txt
./otel-logging-lab/analyze_logs.py
./otel-logging-lab/check_log_span_match.py
./otel-logging-lab/correlated_logging_demo.py
./otel-logging-lab/demo-output.txt
./otel-logging-lab/enhanced-output.txt
./otel-logging-lab/enhanced_logging_demo.py
./otel-logging-lab/match-demo.txt
./otel-logging-lab/match-enhanced.txt
./otel-logging-lab/otel08-console-pkg.txt
./otel-logging-lab/otel08-pkgs.txt
./otel-logging-lab/verify-output.txt
./otel-logging-lab/verify_correlation.py
```
