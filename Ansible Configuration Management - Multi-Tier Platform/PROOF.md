# Ansible Configuration Management - Multi-Tier Platform - completion proof
Completed (UTC): 2026-11-10 06:56:49 | EC2: i-0b124ac51c2f68d3f | host: ip-172-31-10-236 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Ansible Configuration Management - Multi-Tier Platform, 2026-11-10 06:56:43 UTC) ==========
PASS: Task 1: web1/web2/db1 systemd nodes running, ansible ping OK, inventory groups present
PASS: Task 2: alice in devops on all 3 nodes; PermitRootLogin no everywhere
PASS: Task 3: custom fact team=platform on all nodes; web2 app_env=canary (host_vars wins)
PASS: Task 4: webserver role - Acme Shop on 8081/8082, /healthz ok
PASS: Task 5: vault-encrypted secret; appuser reaches appdb on db1 from web1
PASS: Task 6: repaired playbook deploys status page and is lint-clean
PASS: Task 7: rolling deploy (serial 1, rescue rollback) - both nodes serve 1.1.0
PASS: Task 8: site.yml idempotent (changed=0 on 3 hosts)
PASS: Task 8: whole project passes ansible-lint
PASS: Task 8: inventory report rendered with web1 and db1 rows
PASS: Validation: 17/17 checklist items PASS
FAIL: Timing: completed in 1005s (<= 300s)
CORE: 11/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE                COMMAND        CREATED          STATUS          PORTS                                            NAMES
76fa49b81980   ansible-node:22.04   "/sbin/init"   12 minutes ago   Up 12 minutes   127.0.0.1:2223->22/tcp                           db1
4b4312f36a82   ansible-node:22.04   "/sbin/init"   12 minutes ago   Up 12 minutes   127.0.0.1:2222->22/tcp, 127.0.0.1:8082->80/tcp   web2
e3110ff51447   ansible-node:22.04   "/sbin/init"   12 minutes ago   Up 12 minutes   127.0.0.1:2221->22/tcp, 127.0.0.1:8081->80/tcp   web1

IMAGE                ID             DISK USAGE   CONTENT SIZE   EXTRA
ansible-node:22.04   6fa41a2761ad        343MB          107MB   U    
```

## Files
```
./ansible-lab/.ansible-lint
./ansible-lab/ansible.cfg
./ansible-lab/docker/Dockerfile
./ansible-lab/docker/authorized_keys
./ansible-lab/inventory/group_vars/all.yml
./ansible-lab/inventory/group_vars/dbservers/vars.yml
./ansible-lab/inventory/group_vars/dbservers/vault.yml
./ansible-lab/inventory/group_vars/webservers.yml
./ansible-lab/inventory/host_vars/web2.yml
./ansible-lab/inventory/hosts.yml
./ansible-lab/playbooks/baseline.yml
./ansible-lab/playbooks/broken.yml
./ansible-lab/playbooks/database.yml
./ansible-lab/playbooks/deploy.yml
./ansible-lab/playbooks/facts.yml
./ansible-lab/playbooks/precedence.yml
./ansible-lab/playbooks/report.yml
./ansible-lab/playbooks/templates/motd.j2
./ansible-lab/playbooks/templates/report.md.j2
./ansible-lab/playbooks/webservers.yml
./ansible-lab/reports/inventory.md
./ansible-lab/results/apt-host.log
./ansible-lab/results/docker-build.log
./ansible-lab/results/elapsed.txt
./ansible-lab/results/start-nodes.log
./ansible-lab/results/task1-inventory-graph.txt
./ansible-lab/results/task1-ping.log
./ansible-lab/results/task2-baseline.log
./ansible-lab/results/task3-facts.log
./ansible-lab/results/task3-precedence.log
./ansible-lab/results/task4-webservers.log
./ansible-lab/results/task5-database.log
./ansible-lab/results/task5-mariadb-client.log
./ansible-lab/results/task5-vault-encrypt.log
./ansible-lab/results/task6-broken-fixed.log
./ansible-lab/results/task7-deploy-1.1.0.log
./ansible-lab/results/task8-ansible-lint.log
./ansible-lab/results/task8-report.log
./ansible-lab/results/task8-site-idempotency.log
./ansible-lab/results/validation.txt
./ansible-lab/results/venv.log
./ansible-lab/results/versions.txt
./ansible-lab/roles/database/defaults/main.yml
./ansible-lab/roles/database/handlers/main.yml
./ansible-lab/roles/database/meta/main.yml
./ansible-lab/roles/database/tasks/main.yml
./ansible-lab/roles/webserver/defaults/main.yml
./ansible-lab/roles/webserver/handlers/main.yml
./ansible-lab/roles/webserver/meta/main.yml
./ansible-lab/roles/webserver/tasks/main.yml
./ansible-lab/roles/webserver/templates/app.conf.j2
./ansible-lab/roles/webserver/templates/index.html.j2
./ansible-lab/scripts/start-nodes.sh
./ansible-lab/scripts/validate.sh
./ansible-lab/site.yml
```
