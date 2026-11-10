#!/usr/bin/env bash
set -euo pipefail
NODE="$1"
install -d /opt/app
install -m 0755 /vagrant/app/app.py /opt/app/app.py
pkill -f /opt/app/app.py || true
APP_NODE="$NODE" APP_VERSION="2.0" setsid nohup python3 /opt/app/app.py > /var/log/app.log 2>&1 < /dev/null &
