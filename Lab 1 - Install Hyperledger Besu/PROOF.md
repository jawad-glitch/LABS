# Lab 1 - Install Hyperledger Besu - completion proof
Completed (UTC): 2026-11-07 13:16:09 | EC2: i-00093d98aac89ca22 | host: ip-172-31-10-247 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 1 - Install Hyperledger Besu, 2026-11-07 13:16:06 UTC) ==========
(lab URL served Besu 1.5.5: no | installed: besu-1.5.5)
PASS: Task 1: ~/besu-installation created; Besu archive downloaded
PASS: Task 1.4: downloaded file is a real gzip archive (not an HTML error page)
PASS: Task 2: archive extracted without errors
PASS: Task 2.3: install has bin/, lib/ and LICENSE
PASS: Task 3.1: bin/besu is executable
PASS: Task 3.4: matching Java runtime installed (Java 11)
PASS: Task 3.2: ./bin/besu --version prints besu/v1.5.5
PASS: Task 3.3: ./bin/besu --help works
PASS: Task 4: PATH line in ~/.bashrc (once) and 'besu --version' works from ~ and in a new shell
CORE: 9/9 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./results/archive-type.txt
./results/besu-bin.txt
./results/besu-dir.txt
./results/besu-help.txt
./results/besu-version-global.txt
./results/besu-version-new-shell.txt
./results/besu-version.txt
./results/download-attempts.txt
./results/java-version.txt
./results/tar-extract.txt
```
