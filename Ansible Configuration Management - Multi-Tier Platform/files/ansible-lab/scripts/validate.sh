#!/usr/bin/env bash
cd "$HOME/ansible-lab" || exit 1
. "$HOME/ansible-venv/bin/activate"
PASS=0; FAIL=0
check() { local desc="$1"; shift; if "$@" >/dev/null 2>&1; then printf 'PASS  %s\n' "$desc"; PASS=$((PASS+1)); else printf 'FAIL  %s\n' "$desc"; FAIL=$((FAIL+1)); fi; }
t1_nodes()   { [ "$(sudo docker inspect -f '{{.State.Running}}' web1 web2 db1 | grep -c true)" -eq 3 ]; }
t1_ping()    { ansible all -m ansible.builtin.ping; }
t1_groups()  { ansible-inventory --graph | grep -q '@webservers' && ansible-inventory --graph | grep -q '@dbservers'; }
t2_users()   { [ "$(ansible all -m ansible.builtin.command -a 'id -nG alice' | grep -c devops)" -eq 3 ]; }
t2_sshd()    { [ "$(ansible all -b -m ansible.builtin.shell -a 'sshd -T | grep -i ^permitrootlogin' | grep -ci 'permitrootlogin no')" -eq 3 ]; }
t3_facts()   { [ "$(ansible all -m ansible.builtin.setup -a 'filter=ansible_local' | grep -c '"team": "platform"')" -eq 3 ]; }
t3_prec()    { ansible-inventory --host web2 | grep -q '"app_env": "canary"'; }
t4_page()    { curl -fs http://127.0.0.1:8081/ | grep -q 'Acme Shop' && curl -fs http://127.0.0.1:8082/ | grep -q 'canary'; }
t4_health()  { curl -fs http://127.0.0.1:8082/healthz | grep -q ok; }
t5_vault()   { head -1 inventory/group_vars/dbservers/vault.yml | grep -q 'ANSIBLE_VAULT;1.1;AES256'; }
t5_db()      { ansible web1 -m ansible.builtin.command -a "mysql -h db1 -u appuser -p{{ hostvars['db1']['db_password'] }} -e 'SHOW DATABASES;'" | grep -q appdb; }
t6_status()  { curl -fs http://127.0.0.1:8081/status/ | grep -q 'status=ok' && ansible-lint -q playbooks/broken.yml; }
t7_version() { curl -fs http://127.0.0.1:8081/ | grep -q 'Version: 1.1.0' && curl -fs http://127.0.0.1:8082/ | grep -q 'Version: 1.1.0'; }
t7_rescue()  { grep -q 'rescue:' playbooks/deploy.yml && grep -q 'previous_version' playbooks/deploy.yml; }
t8_idem()    { [ "$(ansible-playbook site.yml | grep -cE 'changed=0 +unreachable=0 +failed=0')" -eq 3 ]; }
t8_lint()    { ansible-lint -q; }
t8_report()  { grep -q '^| web1 |' reports/inventory.md && grep -q '^| db1 |' reports/inventory.md; }
check "T1 three managed nodes are running"           t1_nodes
check "T1 all nodes answer ansible ping"              t1_ping
check "T1 inventory has webservers and dbservers"     t1_groups
check "T2 alice is in devops on every node"           t2_users
check "T2 root SSH login disabled everywhere"         t2_sshd
check "T3 custom fact present on every node"          t3_facts
check "T3 web2 overrides app_env via host_vars"       t3_prec
check "T4 web tier serves the Acme Shop page"         t4_page
check "T4 health endpoint answers ok"                 t4_health
check "T5 database password file is vault-encrypted"  t5_vault
check "T5 appuser reaches appdb from web1"            t5_db
check "T6 status page deployed and playbook lint-clean" t6_status
check "T7 both web nodes serve version 1.1.0"         t7_version
check "T7 deploy playbook has rescue/rollback"        t7_rescue
check "T8 site.yml is idempotent (changed=0 x3)"      t8_idem
check "T8 whole project passes ansible-lint"          t8_lint
check "T8 inventory report generated"                 t8_report
echo "----------------------------------------"
echo "Passed: $PASS   Failed: $FAIL"
[ "$FAIL" -eq 0 ]
