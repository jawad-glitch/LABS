#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
BACKUP_DIR="${BACKUP_DIR:-/opt/prometheus-backups}"; LOG_FILE="${LOG_FILE:-/var/log/prom-backup-verify.log}"
log() { printf '%s %s\n' "$(date -u +%FT%TZ)" "$1" >> "$LOG_FILE"; }
check_recent_backup() { [ -n "$(find "$BACKUP_DIR" -maxdepth 1 -name 'prom_snap_*.tar.gz' -mmin -$(( ${1:-7} * 60 )) 2>/dev/null | head -1)" ]; }
verify_archive_integrity() { tar -tzf "$1" > /dev/null 2>&1 && tar -tzf "$1" | grep -q 'backup_metadata.json$'; }
main() {
    if ! check_recent_backup 7; then log "ALERT: no recent backup found"; exit 1; fi
    local newest; newest=$(ls -t "$BACKUP_DIR"/prom_snap_*.tar.gz | head -1)
    if verify_archive_integrity "$newest"; then log "OK: recent backup ${newest} passes integrity check"; exit 0
    else log "ALERT: newest backup ${newest} failed integrity check"; exit 1; fi
}
[ "${BASH_SOURCE[0]}" = "$0" ] && main "$@"
