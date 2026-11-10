# Vagrant - Reproducible Multi-Machine Environments - completion proof
Completed (UTC): 2026-11-10 06:16:42 | EC2: i-0cc153d9e433eee4a | host: ip-172-31-10-100 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Vagrant - Reproducible Multi-Machine Environments, 2026-11-10 06:16:38 UTC) ==========
FAIL: Official Check: 26/26 tests passed
FAIL: Web Server: Forwarded port 8080 responding
FAIL: Cluster: Load balancer active on port 8090
FAIL: Cluster: App tier deployed with Ansible 2.0
FAIL: Fleet: Tools on 1.1.0, Legacy on 1.0.0, Scratch not autostarted
FAIL: Troubleshoot: Host port 8095 serving tshoot ok
PASS: Timing: Lab completed in under 300s
CORE: 1/7 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./vagrant-lab/boxes/publish-box.sh
./vagrant-lab/check-lab.sh
./vagrant-lab/cluster/.vagrant/rgloader/loader.rb
./vagrant-lab/cluster/Vagrantfile
./vagrant-lab/cluster/ansible/app.yml
./vagrant-lab/cluster/ansible/templates/app.env.j2
./vagrant-lab/cluster/app/app.py
./vagrant-lab/cluster/provision/app.sh
./vagrant-lab/cluster/provision/lb.sh
./vagrant-lab/first/.vagrant/rgloader/loader.rb
./vagrant-lab/first/Vagrantfile
./vagrant-lab/fleet/.vagrant/rgloader/loader.rb
./vagrant-lab/fleet/Vagrantfile
./vagrant-lab/fleet/machines.yaml
./vagrant-lab/image/.dockerignore
./vagrant-lab/image/Dockerfile
./vagrant-lab/image/vagrant_lab_key
./vagrant-lab/image/vagrant_lab_key.pub
./vagrant-lab/results/elapsed.txt
./vagrant-lab/results/validation.txt
./vagrant-lab/troubleshoot/.vagrant/rgloader/loader.rb
./vagrant-lab/troubleshoot/Vagrantfile
./vagrant-lab/troubleshoot/Vagrantfile.good
./vagrant-lab/troubleshoot/content/index.html
./vagrant-lab/troubleshoot/provision.sh
./vagrant-lab/web/.vagrant/rgloader/loader.rb
./vagrant-lab/web/Vagrantfile
./vagrant-lab/web/provision/bootstrap.sh
./vagrant-lab/web/provision/nginx-site.conf
./vagrant-lab/web/site/index.html
```
