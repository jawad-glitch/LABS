#!/bin/bash
GRAFANA_URL="http://localhost:3000"
ADMIN_USER="admin"
ADMIN_PASS="admin123"
BACKUP_DIR="/tmp/grafana-backups"
mkdir -p $BACKUP_DIR
DASHBOARD_UID="your-dashboard-uid"
curl -u $ADMIN_USER:$ADMIN_PASS \
  "$GRAFANA_URL/api/dashboards/uid/$DASHBOARD_UID" \
  -o "$BACKUP_DIR/dashboard-$(date +%Y%m%d-%H%M%S).json"
echo "Dashboard backed up to $BACKUP_DIR"
