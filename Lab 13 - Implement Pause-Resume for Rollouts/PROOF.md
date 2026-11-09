# Lab 13 - Implement Pause-Resume for Rollouts - completion proof
Completed (UTC): 2026-11-09 13:02:49 | EC2: i-043893d038fba0ebb | host: ip-172-31-10-24 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 13 - Implement Pause-Resume for Rollouts, 2026-11-09 13:02:44 UTC) - FAST MODE ==========
PASS: Lab bug: kubectl argo rollouts resume does not exist in CLI v1.10.2 (fix: promote, which supports --full)
PASS: All manifests (3 Rollouts + Services + fixed AnalysisTemplate) valid (strict); monitor/troubleshoot scripts parse
PASS: Task 2.3 [SIMULATED controller, real pods]: initial rollout Healthy, 5 pods, 100% traffic on 1.24
PASS: Task 3.1/3.2: set image -> Paused at pause{} (20%: 4 stable/1 canary, both versions serve); manual pause adds spec.paused
PASS: Task 3.4: promote (lab resume) continues 40/60/80 timed pauses -> Healthy, 100% on 1.25
PASS: Task 3.5: timed pause does NOT progress while manually paused; promote resumes -> Healthy 1.26
PASS: Task 4: analysis step ran the fixed job script against auto-pause-app-service (passed) -> rollout continued to Healthy 1.25
PASS: Lab bug evidence: original analysis script probes sample-app-service (wrong app); fixed template uses args.service-name
PASS: Task 5.2: manual gates - exactly 3 promotes needed (16/33/66), 1/6 canary at gate 1, Healthy 1.25 at end
PASS: Task 5.3: abort at gate -> Degraded, canary 0, 100% traffic on stable 1.25; undo -> Healthy
PASS: Task 6.2: set/pause/promote cycle with monitoring -> Healthy 1.27
PASS: Time: fast-mode run finished in 105s (<= 300s)
CORE: 12/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE                    ID             DISK USAGE   CONTENT SIZE   EXTRA
curlimages/curl:7.85.0   9fab1b73f45e       24.9MB         8.57MB        
nginx:1.24-alpine        77e5d4a6ad90       64.4MB         18.1MB        
nginx:1.25-alpine        516475cc129d       75.4MB         21.7MB        
nginx:1.26-alpine        1eadbb078203         73MB         21.5MB        
nginx:1.27-alpine        65645c7bb6a0       74.5MB         21.9MB        
```

## Files
```
./pause-resume-lab13/auto-pause-rollout.yaml
./pause-resume-lab13/lab-original-simple-analysis-check.sh
./pause-resume-lab13/manual-gate-rollout.yaml
./pause-resume-lab13/monitor-rollouts.sh
./pause-resume-lab13/namespace.yaml
./pause-resume-lab13/results/SIMULATED.md
./pause-resume-lab13/results/analysis-auto-pause-app.txt
./pause-resume-lab13/results/bug1-lab-resume-command.txt
./pause-resume-lab13/results/elapsed.txt
./pause-resume-lab13/results/events.txt
./pause-resume-lab13/results/fix1-promote-help.txt
./pause-resume-lab13/results/image-pull.log
./pause-resume-lab13/results/install-kubeconform.log
./pause-resume-lab13/results/install-rollouts-cli.log
./pause-resume-lab13/results/task-kubeconform.txt
./pause-resume-lab13/results/task1.3-cli-version.txt
./pause-resume-lab13/results/task3.2-pause-help.txt
./pause-resume-lab13/results/task5.3-abort-help.txt
./pause-resume-lab13/results/task5.3-undo-help.txt
./pause-resume-lab13/results/versions.txt
./pause-resume-lab13/rollout-best-practices.md
./pause-resume-lab13/sample-app.yaml
./pause-resume-lab13/simple-analysis-template.yaml
./pause-resume-lab13/troubleshoot-rollouts.sh
```
