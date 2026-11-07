# Lab 4 - Set Up Logging and Data Directories - completion proof
Completed (UTC): 2026-11-07 14:39:35 | EC2: i-0aa5fe105bbfd8029 | host: ip-172-31-10-11 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 4 - Set Up Logging and Data Directories, 2026-11-07 14:35:21 UTC) ==========
PASS: Task 1.1/1.2: dirs mode 755
PASS: Task 2.1/2.2/2.3: config keys present
PASS: Task 2.3: enhanced preserved
PASS: Task 3: startup script executable
PASS: Task 4.1: --help captured
FAIL: Task 4.2: RPC answered
PASS: Task 5.1: data populated
PASS: Task 5.2: database/ files
PASS: Task 6.1/6.2: log >20 lines
PASS: Task 6.3: log has rpc
PASS: Task 7: analyze-logs ran
PASS: Task 8: verify OK
CORE: 11/12 PASS
```

## Files
```
./analyze-logs.sh
./config/config.toml
./config/run/config.toml
./config/run/runtime-config.toml
./results/config-basic.toml
./results/config-enhanced.toml
./results/task1-dirs.txt
./results/task1-perms.txt
./results/task3-script.txt
./results/task4-validate.txt
./results/task5-data-db.txt
./results/task5-data-top.txt
./results/task6-greps.txt
./results/task6-head50.txt
./results/task6-logdir.txt
./results/task7-analyze.txt
./results/task8-verify.txt
./start-besu-with-logging.sh
./verify-config.sh
```
