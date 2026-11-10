# Ansible I - Automating a Two-Tier Web Platform - completion proof
Completed (UTC): 2026-11-10 07:15:23 | EC2: i-0fe0135b5fbb21b61 | host: ip-172-31-10-110 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Ansible I - Automating a Two-Tier Web Platform, 2026-11-10 07:15:19 UTC) ==========
PASS: Setup: venv ansible-core 2.15; image without Python; 3 nodes on 127.0.0.1; raw SSH + passwordless sudo on all 3
PASS: Task 1: project ansible.cfg active; inventory lab > web(web1,web2), db(db1); web2 port 2222 + http 8082
FAIL: Task 2: pre-bootstrap modules fail (python3 not found); raw bootstrap changed then idempotent; host-down + wrong-user UNREACHABLE diagnosed
FAIL: Task 3: baseline applied then changed=0; validate blocked broken sudoers (never written); alice in devops x3; sudoers parsed OK x3
PASS: Task 4: precedence all<group<host (lightgrey/lightblue/lightgreen), -e red wins everywhere, assert Platform supported x3
PASS: Task 5: chained handlers validate then reload; re-run changed=0; web1 Release 1.0.0; web2 health ok; nginx -t ok x2
PASS: Task 6: roles scaffolded by ansible-galaxy; refactor run changed=0; inventory lightgreen beats role default white
PASS: Task 7: vault-encrypted secret (not in plaintext); redis bind 0.0.0.0/port 6379; web nodes PONG with password; NOAUTH without; env file denied to unprivileged user
PASS: Task 8.2: drift found by --check --diff (page untouched), corrected by apply
PASS: Task 8.3: rolling release 1.1.0 with serial 1 - web play ran twice (web1 then web2); both serve 1.1.0
FAIL: Task 8.4: bad port contained - web1 failed in validate handler, web2 untouched (listen 80), both still healthy; recovered and converged
FAIL: Challenge: lb1 upstream generated from inventory round-robins web1/web2; site.yml idempotent
FAIL: Validation checklist: 18/18 PASS
FAIL: Time: lab finished in 840s (<= 300s)
CORE: 8/14 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE                    COMMAND                  CREATED          STATUS          PORTS                                            NAMES
01ebbb9cc349   ansible-lab-node:22.04   "/usr/sbin/sshd -D -e"   4 minutes ago    Up 4 minutes    127.0.0.1:2224->22/tcp, 127.0.0.1:8080->80/tcp   lb1
44a2c24dea42   ansible-lab-node:22.04   "/usr/sbin/sshd -D -e"   12 minutes ago   Up 11 minutes   80/tcp, 127.0.0.1:2223->22/tcp                   db1
37d02d65d2c9   ansible-lab-node:22.04   "/usr/sbin/sshd -D -e"   12 minutes ago   Up 12 minutes   127.0.0.1:2222->22/tcp, 127.0.0.1:8082->80/tcp   web2
fd77c4cacf0b   ansible-lab-node:22.04   "/usr/sbin/sshd -D -e"   12 minutes ago   Up 12 minutes   127.0.0.1:2221->22/tcp, 127.0.0.1:8081->80/tcp   web1

IMAGE                    ID             DISK USAGE   CONTENT SIZE   EXTRA
ansible-lab-node:22.04   dea2fbff9e77        134MB         33.8MB   U    
```

## Files
```
./ansible-lab/nodes/Dockerfile
./ansible-lab/nodes/ansible_lab.pub
./ansible-lab/project/ansible.cfg
./ansible-lab/project/inventory/group_vars/all/main.yml
./ansible-lab/project/inventory/group_vars/all/vault.yml
./ansible-lab/project/inventory/group_vars/web.yml
./ansible-lab/project/inventory/host_vars/web2.yml
./ansible-lab/project/inventory/hosts.yml
./ansible-lab/project/playbooks/baseline.yml
./ansible-lab/project/playbooks/bootstrap.yml
./ansible-lab/project/playbooks/templates/index.html.j2
./ansible-lab/project/playbooks/templates/motd.j2
./ansible-lab/project/playbooks/templates/site.conf.j2
./ansible-lab/project/playbooks/vars_demo.yml
./ansible-lab/project/playbooks/web.yml
./ansible-lab/project/roles/common/README.md
./ansible-lab/project/roles/common/defaults/main.yml
./ansible-lab/project/roles/common/handlers/main.yml
./ansible-lab/project/roles/common/meta/main.yml
./ansible-lab/project/roles/common/tasks/main.yml
./ansible-lab/project/roles/common/templates/motd.j2
./ansible-lab/project/roles/common/tests/inventory
./ansible-lab/project/roles/common/tests/test.yml
./ansible-lab/project/roles/common/vars/main.yml
./ansible-lab/project/roles/loadbalancer/handlers/main.yml
./ansible-lab/project/roles/loadbalancer/tasks/main.yml
./ansible-lab/project/roles/loadbalancer/templates/lb.conf.j2
./ansible-lab/project/roles/redis/README.md
./ansible-lab/project/roles/redis/defaults/main.yml
./ansible-lab/project/roles/redis/handlers/main.yml
./ansible-lab/project/roles/redis/meta/main.yml
./ansible-lab/project/roles/redis/tasks/main.yml
./ansible-lab/project/roles/redis/tests/inventory
./ansible-lab/project/roles/redis/tests/test.yml
./ansible-lab/project/roles/redis/vars/main.yml
./ansible-lab/project/roles/webserver/README.md
./ansible-lab/project/roles/webserver/defaults/main.yml
./ansible-lab/project/roles/webserver/handlers/main.yml
./ansible-lab/project/roles/webserver/meta/main.yml
./ansible-lab/project/roles/webserver/tasks/main.yml
./ansible-lab/project/roles/webserver/templates/index.html.j2
./ansible-lab/project/roles/webserver/templates/lab-app.env.j2
./ansible-lab/project/roles/webserver/templates/site.conf.j2
./ansible-lab/project/roles/webserver/tests/inventory
./ansible-lab/project/roles/webserver/tests/test.yml
./ansible-lab/project/roles/webserver/vars/main.yml
./ansible-lab/project/site.yml
./ansible-lab/results/challenge-idempotent.log
./ansible-lab/results/challenge-lb-health.txt
./ansible-lab/results/challenge-site-with-lb.log
./ansible-lab/results/challenge-verify.txt
./ansible-lab/results/elapsed.txt
./ansible-lab/results/setup-docker-build.log
./ansible-lab/results/setup-docker-ps.txt
./ansible-lab/results/setup-raw-ssh.txt
./ansible-lab/results/setup-venv.log
./ansible-lab/results/setup-versions.txt
./ansible-lab/results/task1-verify.txt
./ansible-lab/results/task2-verify.txt
./ansible-lab/results/task2.1-ping-before-bootstrap.txt
./ansible-lab/results/task2.2-bootstrap-run1.log
./ansible-lab/results/task2.2-bootstrap-run2.log
./ansible-lab/results/task2.3-adhoc.txt
./ansible-lab/results/task2.4-failure-A-host-down.txt
./ansible-lab/results/task2.4-failure-B-wrong-user.txt
./ansible-lab/results/task2.4-vvv-ssh-command.txt
./ansible-lab/results/task3-verify.txt
./ansible-lab/results/task3.3-baseline-run1.log
./ansible-lab/results/task3.3-baseline-run2.log
./ansible-lab/results/task3.3-check-diff-converged-web1.log
./ansible-lab/results/task3.3-check-diff-fresh-web1.log
./ansible-lab/results/task3.3-syntax.txt
./ansible-lab/results/task3.4-broken-stat.txt
./ansible-lab/results/task3.4-broken-sudoers.txt
./ansible-lab/results/task4-verify-precedence.txt
./ansible-lab/results/task4.3-vars-demo-extra-red.log
./ansible-lab/results/task4.3-vars-demo.log
./ansible-lab/results/task5-verify.txt
./ansible-lab/results/task5.3-web-run1.log
./ansible-lab/results/task5.3-web-run2.log
./ansible-lab/results/task6-verify.txt
./ansible-lab/results/task6.1-galaxy-init.txt
./ansible-lab/results/task6.1-webserver-tree.txt
./ansible-lab/results/task6.4-list-tasks.txt
./ansible-lab/results/task6.4-site-refactor.log
./ansible-lab/results/task7-verify.txt
./ansible-lab/results/task7.2-redis-host.txt
./ansible-lab/results/task7.2-vault-encrypt.txt
./ansible-lab/results/task7.2-vault.txt
./ansible-lab/results/task7.5-no-log-evidence.txt
./ansible-lab/results/task7.5-site-with-cache.log
./ansible-lab/results/task8-verify.txt
./ansible-lab/results/task8.1-list-tags.txt
./ansible-lab/results/task8.1-site-final.log
./ansible-lab/results/task8.2-after-check.txt
./ansible-lab/results/task8.2-after-fix.txt
./ansible-lab/results/task8.2-defaced-before.txt
./ansible-lab/results/task8.2-drift-check.log
./ansible-lab/results/task8.2-drift-fix.log
./ansible-lab/results/task8.3-rolling-1.1.0.log
./ansible-lab/results/task8.3-rolling-order.txt
./ansible-lab/results/task8.4-analysis.txt
./ansible-lab/results/task8.4-bad-change.log
./ansible-lab/results/task8.4-converged.log
./ansible-lab/results/task8.4-recover.log
./ansible-lab/results/validation-idempotency.log
./ansible-lab/results/validation.txt
./ansible-lab/validate.sh
```
