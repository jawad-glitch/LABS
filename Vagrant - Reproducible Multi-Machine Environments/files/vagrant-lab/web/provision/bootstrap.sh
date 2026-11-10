#!/usr/bin/env bash
set -euo pipefail
HOST_LABEL="${1:-unknown}"
export DEBIAN_FRONTEND=noninteractive
command -v nginx >/dev/null 2>&1 || { apt-get update -qq && apt-get install -y -qq nginx >/dev/null; }
install -m 0644 /tmp/nginx-site.conf /etc/nginx/sites-available/lab-site
ln -sf /etc/nginx/sites-available/lab-site /etc/nginx/sites-enabled/lab-site
rm -f /etc/nginx/sites-enabled/default
mkdir -p /var/www/meta
cat > /var/www/meta/info.txt <<INFO
host=${HOST_LABEL}
owner=${SITE_OWNER:-unset}
box=$(cat /etc/box-release)
provisioned=$(date -u +%Y-%m-%dT%H:%M:%SZ)
INFO
nginx -t
