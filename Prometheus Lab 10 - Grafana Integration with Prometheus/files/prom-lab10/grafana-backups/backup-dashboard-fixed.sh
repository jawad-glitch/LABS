#!/bin/bash
# Fixed: look the UID up by title, fail loudly on HTTP errors, keep only the dashboard model.
GRAFANA_URL="${GRAFANA_URL:-http://localhost:3000}"; AUTH="${GRAFANA_AUTH:-admin:admin123}"; BACKUP_DIR="${BACKUP_DIR:-/tmp/grafana-backups}"
TITLE="${1:-System Monitoring Dashboard}"; mkdir -p "$BACKUP_DIR"
UID_=$(curl -fsS -u "$AUTH" --get --data-urlencode "query=$TITLE" "$GRAFANA_URL/api/search" | jq -r --arg t "$TITLE" '.[] | select(.title == $t) | .uid' | head -1)
[ -n "$UID_" ] || { echo "dashboard '$TITLE' not found" >&2; exit 1; }
OUT="$BACKUP_DIR/dashboard-$UID_-$(date +%Y%m%d-%H%M%S).json"
curl -fsS -u "$AUTH" "$GRAFANA_URL/api/dashboards/uid/$UID_" | jq '.dashboard' > "$OUT" || { echo "export failed" >&2; exit 1; }
echo "Dashboard '$TITLE' ($UID_) backed up to $OUT ($(jq '.panels | length' "$OUT") panels)"
