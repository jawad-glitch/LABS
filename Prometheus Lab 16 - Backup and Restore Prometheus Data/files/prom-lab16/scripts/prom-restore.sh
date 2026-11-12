#!/bin/bash
set -o pipefail
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
DATA_DIR="${DATA_DIR:-/opt/prometheus-data}"; BACKUP_DIR="${BACKUP_DIR:-/opt/prometheus-backups}"
LOG_FILE="${LOG_FILE:-/var/log/prom-restore.log}"; PROM_URL="${PROM_URL:-http://localhost:9090}"; TIMEOUT="${TIMEOUT:-30}"
VERIFY_BLOCKS="${VERIFY_BLOCKS:-1}"     # 0 = lab contract only (liveness); 1 = also require restored blocks to be loaded
ROLLBACK_DIR=""; EXPECTED_BLOCKS=0
log() { printf 'ts=%s level=%s component=prom-restore stage=%s msg="%s"\n' "$(date -u +%FT%TZ)" "$1" "$2" "$3" | tee -a "$LOG_FILE" >&2; }

list_backups() {
    ls -t "$BACKUP_DIR"/prom_snap_*.tar.gz >/dev/null 2>&1 || { echo "no backups in $BACKUP_DIR"; return 1; }
    ls -lt --time-style=+%FT%T "$BACKUP_DIR"/prom_snap_*.tar.gz | awk '{print $6, $5, $7}'
}

pre_restore_checks() {
    local a="$1"
    [ -f "$a" ] || { log error pre_restore_checks "archive not found: $a"; return 1; }
    tar -tzf "$a" > /dev/null 2>&1 || { log error pre_restore_checks "archive fails tar integrity check: $a"; return 1; }
    tar -tzf "$a" | grep -q '^backup_metadata.json$' || { log error pre_restore_checks "backup_metadata.json missing in $a"; return 1; }
    [ "$(systemctl show -p CanStop --value prometheus 2>/dev/null)" = yes ] || { log error pre_restore_checks "prometheus.service is not stoppable/loaded"; return 1; }
    EXPECTED_BLOCKS=$(tar -tzf "$a" | grep -cE '/[0-9A-HJKMNP-TV-Z]{26}/meta.json$')
    if [ "$VERIFY_BLOCKS" = 1 ] && [ "$EXPECTED_BLOCKS" -lt 1 ]; then log error pre_restore_checks "archive contains 0 TSDB blocks - restoring it would leave Prometheus empty"; return 1; fi
    log info pre_restore_checks "archive ok: $a (${EXPECTED_BLOCKS} blocks)"
}

stop_and_preserve() {
    local d="$1"
    systemctl stop prometheus || { log error stop_and_preserve "could not stop prometheus"; return 1; }
    ROLLBACK_DIR="${d}_pre_restore_$(date +%s)"
    mv "$d" "$ROLLBACK_DIR" && mkdir -p "$d" && chown prometheus:prometheus "$d" || { log error stop_and_preserve "could not preserve $d"; return 1; }
    log info stop_and_preserve "service stopped; rollback point ${ROLLBACK_DIR} ($(find "$ROLLBACK_DIR" -mindepth 1 -maxdepth 1 | wc -l) entries)"
}

extract_and_place() {
    local a="$1" d="$2" tmp n=0 b
    tmp=$(mktemp -d /tmp/prom-restore.XXXXXX)
    tar -xzf "$a" -C "$tmp" || { log error extract_and_place "extraction failed"; rm -rf "$tmp"; return 1; }
    for b in $(find "$tmp" -mindepth 2 -maxdepth 3 -type f -name meta.json -printf '%h\n'); do cp -a "$b" "$d/"; n=$((n+1)); done
    [ -d "$(find "$tmp" -maxdepth 2 -type d -name wal | head -1)" ] && cp -a "$(find "$tmp" -maxdepth 2 -type d -name wal | head -1)" "$d/"
    chown -R prometheus:prometheus "$d"; rm -rf "$tmp"
    log info extract_and_place "placed ${n} block(s) into $d"
}

rollback() {
    systemctl stop prometheus
    mv "$DATA_DIR" "${DATA_DIR}_failed_$(date +%s)" && mv "$ROLLBACK_DIR" "$DATA_DIR"
    systemctl start prometheus
    log error post_restore_verify "ROLLBACK_TRIGGERED: $1 - restored previous data dir from ${ROLLBACK_DIR}"
}

post_restore_verify() {
    local url="$1" to="$2" t=0 loaded
    systemctl start prometheus
    until curl -fsS -m 3 "$url/api/v1/status/config" > /dev/null 2>&1 && systemctl is-active -q prometheus; do
        sleep 5; t=$((t+5)); [ "$t" -ge "$to" ] && { rollback "Prometheus not serving after ${to}s"; return 1; }
    done
    sleep 2; systemctl is-active -q prometheus || { rollback "Prometheus exited after start"; return 1; }
    loaded=$(curl -fsS --get --data-urlencode 'query=prometheus_tsdb_blocks_loaded' "$url/api/v1/query" | jq -r '.data.result[0].value[1] // 0')
    if [ "$VERIFY_BLOCKS" = 1 ] && [ "$loaded" -lt "$EXPECTED_BLOCKS" ]; then rollback "only ${loaded}/${EXPECTED_BLOCKS} blocks loaded"; return 1; fi
    log info post_restore_verify "Prometheus serving; metric names=$(curl -fsS "$url/api/v1/label/__name__/values" | jq '.data | length'); blocks loaded=${loaded}/${EXPECTED_BLOCKS}"
}

main() {
    local a
    case "${1:-}" in
        --list) list_backups; exit $? ;;
        --latest) a=$(ls -t "$BACKUP_DIR"/prom_snap_*.tar.gz 2>/dev/null | head -1); [ -n "$a" ] || { log error main "no backups"; exit 1; } ;;
        /*) a="$1" ;;
        *) echo "usage: $0 --list | --latest | /absolute/path/to/archive.tar.gz"; exit 2 ;;
    esac
    log info main "restore start archive=$a verify_blocks=${VERIFY_BLOCKS}"
    pre_restore_checks "$a" || { log error main "restore aborted at pre-checks (nothing changed)"; exit 1; }
    stop_and_preserve "$DATA_DIR" || { systemctl start prometheus; exit 1; }
    extract_and_place "$a" "$DATA_DIR" || { rollback "extraction failed"; exit 1; }
    post_restore_verify "$PROM_URL" "$TIMEOUT" || { log error main "restore end status=rolled_back"; exit 1; }
    log info main "restore end status=success"; exit 0
}
[ "${BASH_SOURCE[0]}" = "$0" ] && main "$@"
