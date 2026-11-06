# Lab 3 - Scaffold Python Demo Service - completion proof
Completed (UTC): 2026-11-06 23:47:14 | EC2: i-0cbdcf8864b0b4512 | host: ip-172-31-10-249 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 3 - Scaffold Python Demo Service, 2026-11-06 23:47:11 UTC) ==========
PASS: Task 1: project directory ~/otca
PASS: Task 2: app.py defines / and /work routes and compiles
PASS: Task 3: Flask + Gunicorn installed (venv)
PASS: Task 4: gunicorn listened on 0.0.0.0:8000 with 2 workers
PASS: Task 5.2: / returns welcome JSON with endpoints [/, /work]
PASS: Task 5.3: /work completes with duration 0.1-0.5 s
PASS: Task 5.4: repeated /work calls all completed
PASS: Task 6: master + 2 workers were running; port 8000 listening; health 200
PASS: Task 7: 10 concurrent requests all HTTP 200
PASS: Task 8: graceful shutdown -> connection refused
CORE: 10/10 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./otca/app.py
./otca/gunicorn-access.log
./otca/gunicorn-error.log
./otca/otel03-after-stop.txt
./otca/otel03-concurrent.txt
./otca/otel03-home.json
./otca/otel03-pkgs.txt
./otca/otel03-port.txt
./otca/otel03-ps.txt
./otca/otel03-system-pip.txt
./otca/otel03-time.txt
./otca/otel03-work-multi.txt
./otca/otel03-work.json
./otca/requirements.txt
```
