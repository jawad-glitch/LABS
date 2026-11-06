# otel-lab01-docker-tooling - completion proof
Completed (UTC): 2026-11-06 23:38:06 | EC2: i-0724ee9d273e7a4b7 | host: ip-172-31-10-166 | user: ubuntu

## Core checks
```
========== CORE CHECKS (otel-lab01-docker-tooling, 2026-11-06 23:38:04 UTC) ==========
PASS: Task 1: curl, git, python3, pip3 installed
PASS: Task 2: docker-ce installed from download.docker.com
PASS: Task 2: buildx + compose plugins installed
PASS: Task 2.5: docker service active and enabled
PASS: Task 3: ubuntu is in the docker group
PASS: Task 3.3: hello-world ran via docker group (no sudo)
PASS: Task 4: standalone docker-compose installed (ELF binary, executable)
PASS: Task 4.3: /usr/bin/docker-compose symlink
PASS: Task 5.1/5.2: docker server responds; docker-compose v2+ (standalone + plugin)
PASS: Task 5.3: alpine container printed message
PASS: Task 5.4: docker-compose test service printed message
CORE: 11/11 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                ID             DISK USAGE   CONTENT SIZE   EXTRA
alpine:latest        3f4d6b32e267         13MB         3.94MB        
hello-world:latest   c567b231f656       25.9kB         9.49kB        
```

## Files
```
./otel-lab01/docker-compose-version.txt
./otel-lab01/docker-version.txt
./otel-lab01/test-compose.yml
./otel-lab01/tool-versions.txt
```
