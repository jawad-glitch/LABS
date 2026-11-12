#!/bin/bash
# Snapshot-based Prometheus TSDB backup: create_snapshot -> archive_snapshot -> rotate_backups
set -o pipefail
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin   # cron runs with a minimal PATH
PROM_URL="${PROM_URL:-http://localhost:9090}"; DATA_DIR="${DATA_DIR:-/opt/prometheus-data}"
BACKUP_DIR="${BACKUP_DIR:-/opt/prometheus-backups}"; LOG_FILE="${LOG_FILE:-/var/log/prom-backup.log}"
SNAP_QUERY="${SNAP_QUERY:-}"     # e.g. "?skip_head=true"
log() { printf 'ts=%s level=%s component=prom-backup stage=%s msg="%s"\n' "$(date -u +%FT%TZ)" "$1" "$2" "$3" >> "$LOG_FILE"; }

create_snapshot() {
    local resp name
    resp=$(curl -fsS -X POST "${PROM_URL}/api/v1/admin/tsdb/snapshot${SNAP_QUERY}" 2>&1) || { log error create_snapshot "snapshot API call failed: ${resp}"; return 1; }
    name=$(printf '%s' "$resp" | jq -r '.data.name // empty')
    [ -n "$name" ] && [ -d "${DATA_DIR}/snapshots/${name}" ] || { log error create_snapshot "no snapshot name/dir in response: ${resp}"; return 1; }
    log info create_snapshot "created ${name}"; printf '%s\n' "$name"
}

archive_snapshot() {
    local name="$1" ts archive stage version blocks
    ts=$(date -u +%Y%m%dT%H%M%SZ); archive="${BACKUP_DIR}/prom_snap_${ts}.tar.gz"; stage=$(mktemp -d)
    version=$(curl -fsS "${PROM_URL}/api/v1/status/buildinfo" | jq -r '.data.version // "unknown"')
    blocks=$(find "${DATA_DIR}/snapshots/${name}" -mindepth 2 -maxdepth 2 -name meta.json | wc -l)
    jq -n --arg n "$name" --arg a "$archive" --arg v "$version" --argjson c "$(date +%s)" --argjson b "$blocks" \
       '{snapshot_name: $n, archive_path: $a, created_at: $c, prometheus_version: $v, block_count: $b}' > "${stage}/backup_metadata.json"
    tar -czf "$archive" -C "${DATA_DIR}/snapshots" "$name" -C "$stage" backup_metadata.json || { log error archive_snapshot "tar failed for ${name}"; rm -rf "$stage"; return 1; }
    rm -rf "$stage"
    tar -tzf "$archive" > /dev/null 2>&1 || { log error archive_snapshot "integrity check failed: ${archive}"; return 1; }
    rm -rf "${DATA_DIR}/snapshots/${name}"
    log info archive_snapshot "archived ${name} -> ${archive} ($(du -h "$archive" | cut -f1), ${blocks} blocks)"
}

rotate_backups() {
    local days="${1:-7}" n
    n=$(find "$BACKUP_DIR" -maxdepth 1 -name 'prom_snap_*.tar.gz' -mtime +"$days" -print -delete | wc -l)
    log info rotate_backups "deleted ${n} archive(s) older than ${days} days"; return 0
}

main() {
    local days="${1:-7}" name
    log info main "backup start (retention_days=${days})"
    name=$(create_snapshot) || { log error main "backup failed at create_snapshot"; exit 1; }
    archive_snapshot "$name" || { log error main "backup failed at archive_snapshot"; exit 1; }
    rotate_backups "$days"
    log info main "backup end status=success"; exit 0
}
[ "${BASH_SOURCE[0]}" = "$0" ] && main "$@"
