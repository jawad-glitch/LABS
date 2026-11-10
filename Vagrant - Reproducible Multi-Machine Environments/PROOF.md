# Vagrant - Reproducible Multi-Machine Environments - completion proof
Completed (UTC): 2026-11-10 06:32:33 | EC2: i-0cc153d9e433eee4a | host: ip-172-31-10-100 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Vagrant - Reproducible Multi-Machine Environments, 2026-11-10 06:31:44 UTC) ==========
FAIL: Official Check: 26/26 tests passed
PASS: Web Server: Forwarded port 8080 responding
PASS: Cluster: Load balancer active on port 8090
PASS: Cluster: App tier deployed with Ansible 2.0
PASS: Fleet: Tools on 1.1.0, Legacy on 1.0.0, Scratch not autostarted
PASS: Troubleshoot: Host port 8095 serving tshoot ok
FAIL: Timing: Lab completed in under 300s
CORE: 5/7 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE                             COMMAND                  CREATED         STATUS         PORTS                                            NAMES
59e0644cd57c   devops-lab/vagrant-ubuntu:1.1.0   "/usr/sbin/sshd -D -e"   2 minutes ago   Up 2 minutes   127.0.0.1:2205->22/tcp, 127.0.0.1:8095->80/tcp   tshoot
70353769502d   devops-lab/vagrant-ubuntu:1.0.0   "/usr/sbin/sshd -D -e"   2 minutes ago   Up 2 minutes   127.0.0.1:2204->22/tcp                           fleet-legacy
bdac7b58c54a   devops-lab/vagrant-ubuntu:1.1.0   "/usr/sbin/sshd -D -e"   2 minutes ago   Up 2 minutes   127.0.0.1:2203->22/tcp                           fleet-tools
4993751ac438   devops-lab/vagrant-ubuntu:1.0.0   "/usr/sbin/sshd -D -e"   2 minutes ago   Up 2 minutes   127.0.0.1:2202->22/tcp                           lab-app2
71a717b34296   devops-lab/vagrant-ubuntu:1.0.0   "/usr/sbin/sshd -D -e"   2 minutes ago   Up 2 minutes   127.0.0.1:2201->22/tcp, 127.0.0.1:8090->80/tcp   lab-lb
f503ec20b51e   devops-lab/vagrant-ubuntu:1.0.0   "/usr/sbin/sshd -D -e"   2 minutes ago   Up 2 minutes   127.0.0.1:2200->22/tcp                           lab-app1
5e761ded8837   devops-lab/vagrant-ubuntu:1.0.0   "/usr/sbin/sshd -D -e"   8 minutes ago   Up 8 minutes   127.0.0.1:2222->22/tcp, 127.0.0.1:8080->80/tcp   lab-web

IMAGE                             ID             DISK USAGE   CONTENT SIZE   EXTRA
devops-lab/vagrant-ubuntu:1.0.0   b007a66a1068        206MB         51.3MB   U    
devops-lab/vagrant-ubuntu:1.1.0   e8b4ec7606cb        207MB         51.7MB   U    
```

## Files
```
./vagrant-lab/boxes/build-1.0.0/Vagrantfile
./vagrant-lab/boxes/build-1.0.0/metadata.json
./vagrant-lab/boxes/build-1.0.0/vagrant_private_key
./vagrant-lab/boxes/build-1.1.0/Vagrantfile
./vagrant-lab/boxes/build-1.1.0/metadata.json
./vagrant-lab/boxes/build-1.1.0/vagrant_private_key
./vagrant-lab/boxes/catalog.json
./vagrant-lab/boxes/devops-ubuntu2404-docker-1.0.0.box
./vagrant-lab/boxes/devops-ubuntu2404-docker-1.1.0.box
./vagrant-lab/boxes/publish-box.sh
./vagrant-lab/check-lab.sh
./vagrant-lab/cluster/.vagrant/machines/app1/docker/action_provision
./vagrant-lab/cluster/.vagrant/machines/app1/docker/box_meta
./vagrant-lab/cluster/.vagrant/machines/app1/docker/creator_uid
./vagrant-lab/cluster/.vagrant/machines/app1/docker/id
./vagrant-lab/cluster/.vagrant/machines/app1/docker/index_uuid
./vagrant-lab/cluster/.vagrant/machines/app1/docker/synced_folders
./vagrant-lab/cluster/.vagrant/machines/app2/docker/action_provision
./vagrant-lab/cluster/.vagrant/machines/app2/docker/box_meta
./vagrant-lab/cluster/.vagrant/machines/app2/docker/creator_uid
./vagrant-lab/cluster/.vagrant/machines/app2/docker/id
./vagrant-lab/cluster/.vagrant/machines/app2/docker/index_uuid
./vagrant-lab/cluster/.vagrant/machines/app2/docker/synced_folders
./vagrant-lab/cluster/.vagrant/machines/lb/docker/action_provision
./vagrant-lab/cluster/.vagrant/machines/lb/docker/box_meta
./vagrant-lab/cluster/.vagrant/machines/lb/docker/creator_uid
./vagrant-lab/cluster/.vagrant/machines/lb/docker/id
./vagrant-lab/cluster/.vagrant/machines/lb/docker/index_uuid
./vagrant-lab/cluster/.vagrant/machines/lb/docker/synced_folders
./vagrant-lab/cluster/.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory
./vagrant-lab/cluster/.vagrant/rgloader/loader.rb
./vagrant-lab/cluster/Vagrantfile
./vagrant-lab/cluster/ansible/app.yml
./vagrant-lab/cluster/ansible/templates/app.env.j2
./vagrant-lab/cluster/app/app.py
./vagrant-lab/cluster/provision/app.sh
./vagrant-lab/cluster/provision/lb.sh
./vagrant-lab/first/.vagrant/rgloader/loader.rb
./vagrant-lab/first/Vagrantfile
./vagrant-lab/fleet/.vagrant/machines/legacy/docker/action_provision
./vagrant-lab/fleet/.vagrant/machines/legacy/docker/box_meta
./vagrant-lab/fleet/.vagrant/machines/legacy/docker/creator_uid
./vagrant-lab/fleet/.vagrant/machines/legacy/docker/id
./vagrant-lab/fleet/.vagrant/machines/legacy/docker/index_uuid
./vagrant-lab/fleet/.vagrant/machines/legacy/docker/synced_folders
./vagrant-lab/fleet/.vagrant/machines/legacy/docker/vagrant_cwd
./vagrant-lab/fleet/.vagrant/machines/tools/docker/action_provision
./vagrant-lab/fleet/.vagrant/machines/tools/docker/box_meta
./vagrant-lab/fleet/.vagrant/machines/tools/docker/creator_uid
./vagrant-lab/fleet/.vagrant/machines/tools/docker/id
./vagrant-lab/fleet/.vagrant/machines/tools/docker/index_uuid
./vagrant-lab/fleet/.vagrant/machines/tools/docker/synced_folders
./vagrant-lab/fleet/.vagrant/machines/tools/docker/vagrant_cwd
./vagrant-lab/fleet/.vagrant/rgloader/loader.rb
./vagrant-lab/fleet/Vagrantfile
./vagrant-lab/fleet/fleet-events.log
./vagrant-lab/fleet/machines.yaml
./vagrant-lab/image/.dockerignore
./vagrant-lab/image/Dockerfile
./vagrant-lab/image/vagrant_lab_key
./vagrant-lab/image/vagrant_lab_key.pub
./vagrant-lab/results/elapsed.txt
./vagrant-lab/results/validation.txt
./vagrant-lab/troubleshoot/.vagrant/machines/default/docker/action_provision
./vagrant-lab/troubleshoot/.vagrant/machines/default/docker/box_meta
./vagrant-lab/troubleshoot/.vagrant/machines/default/docker/creator_uid
./vagrant-lab/troubleshoot/.vagrant/machines/default/docker/id
./vagrant-lab/troubleshoot/.vagrant/machines/default/docker/index_uuid
./vagrant-lab/troubleshoot/.vagrant/machines/default/docker/synced_folders
./vagrant-lab/troubleshoot/.vagrant/rgloader/loader.rb
./vagrant-lab/troubleshoot/Vagrantfile
./vagrant-lab/troubleshoot/Vagrantfile.good
./vagrant-lab/troubleshoot/content/index.html
./vagrant-lab/troubleshoot/provision.sh
./vagrant-lab/web/.vagrant/machines/default/docker/action_provision
./vagrant-lab/web/.vagrant/machines/default/docker/box_meta
./vagrant-lab/web/.vagrant/machines/default/docker/creator_uid
./vagrant-lab/web/.vagrant/machines/default/docker/id
./vagrant-lab/web/.vagrant/machines/default/docker/index_uuid
./vagrant-lab/web/.vagrant/machines/default/docker/synced_folders
./vagrant-lab/web/.vagrant/rgloader/loader.rb
./vagrant-lab/web/Vagrantfile
./vagrant-lab/web/provision/bootstrap.sh
./vagrant-lab/web/provision/nginx-site.conf
./vagrant-lab/web/site/index.html
```
