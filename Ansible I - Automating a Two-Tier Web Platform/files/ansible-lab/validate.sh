#!/usr/bin/env bash
cd ~/ansible-lab/project || { echo "project dir missing"; exit 1; }
source ~/ansible-lab/venv/bin/activate
PASS=0; FAIL=0
check() {
  if bash -c "$2" >/dev/null 2>&1; then echo "[PASS] $1"; PASS=$((PASS+1));
  else echo "[FAIL] $1"; FAIL=$((FAIL+1)); fi
}
echo "Running full site.yml for the idempotency check (takes a minute)..."
ansible-playbook site.yml > /tmp/lab-idempotency.log 2>&1
check "Setup: ansible-core 2.15 in venv (2.16 if 2.15 cannot run on this Python)" 'ansible --version | head -1 | grep -qE "core 2\.1[56]"'
check "Setup: web1, web2, db1 running"               '[ "$(for c in web1 web2 db1; do sudo docker inspect -f "{{.State.Running}}" $c 2>/dev/null; done | grep -c true)" -eq 3 ]'
check "T1: project ansible.cfg is active"            'ansible --version | grep -q "config file = $HOME/ansible-lab/project/ansible.cfg"'
check "T1: inventory groups web and db"              'ansible-inventory --graph web | grep -q web2 && ansible-inventory --graph db | grep -q db1'
check "T2: all hosts answer ping"                    '[ "$(ansible all -m ansible.builtin.ping -o | grep -c SUCCESS)" -ge 3 ]'
check "T3: alice is in devops on all hosts"          '[ "$(ansible all -m ansible.builtin.command -a "id -nG alice" -o | grep -c devops)" -ge 3 ]'
check "T3: sudoers drop-in is valid"                 '[ "$(ansible all -b -m ansible.builtin.command -a "visudo -cf /etc/sudoers.d/devops" -o | grep -c "parsed OK")" -ge 3 ]'
check "T4: host_vars override (web2 lightgreen)"     'ansible-inventory --host web2 | grep -q lightgreen'
check "T5: web1 health endpoint"                     'curl -s http://127.0.0.1:8081/health | grep -q "ok web1"'
check "T5: web2 health endpoint"                     'curl -s http://127.0.0.1:8082/health | grep -q "ok web2"'
check "T6: roles common, webserver, redis exist"     'test -f roles/common/tasks/main.yml && test -f roles/webserver/handlers/main.yml && test -f roles/redis/tasks/main.yml'
check "T7: vault file is encrypted"                  'head -1 inventory/group_vars/all/vault.yml | grep -q "^\$ANSIBLE_VAULT;1.1;AES256"'
check "T7: web nodes authenticate to Redis"          '[ "$(ansible web -b -m ansible.builtin.shell -a ". /etc/lab-app.env && redis-cli -h \$REDIS_HOST -a \$REDIS_PASSWORD --no-auth-warning ping" -o | grep -c PONG)" -eq 2 ]'
check "T7: Redis rejects unauthenticated clients"    'ansible web1 -m ansible.builtin.command -a "redis-cli -h db1 ping" 2>&1 | grep -q NOAUTH'
check "T7: env file not world-readable"              'ansible web1 -m ansible.builtin.command -a "cat /etc/lab-app.env" 2>&1 | grep -q "Permission denied"'
check "T8: release 1.1.0 on both web nodes"          'curl -s http://127.0.0.1:8081/ | grep -q "Release: 1.1.0" && curl -s http://127.0.0.1:8082/ | grep -q "Release: 1.1.0"'
check "T8: web play is rolling (serial)"             'grep -q "serial: 1" site.yml'
check "T8: site.yml idempotent (no changed/failed)"  'grep -q "PLAY RECAP" /tmp/lab-idempotency.log && ! grep -Eq "(changed|failed|unreachable)=[1-9]" /tmp/lab-idempotency.log'
echo "----------------------------------------"
echo "Passed: $PASS   Failed: $FAIL"
[ "$FAIL" -eq 0 ]
