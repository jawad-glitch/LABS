#!/bin/bash
set -u

if [ "$#" -ne 1 ] || [ ! -f "$1" ]; then
    echo "Usage: $0 <binary_path>" >&2
    exit 1
fi

BIN=$(realpath "$1")
NAME=$(basename "$BIN")
ROOT=$(cd "$(dirname "$0")" && pwd)
REPORT="$ROOT/profiles/$NAME.txt"
TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT

if ! command -v riscv64-linux-gnu-objdump >/dev/null 2>&1; then
    echo "ERROR: riscv64-linux-gnu-objdump not found" >&2
    exit 1
fi
if ! command -v qemu-riscv64-static >/dev/null 2>&1; then
    echo "ERROR: qemu-riscv64-static not found" >&2
    exit 1
fi

OBJDUMP=$(riscv64-linux-gnu-objdump -d "$BIN")
STATIC_COUNT=$(printf '%s\n' "$OBJDUMP" | awk '
/^[[:space:]]*[[:xdigit:]]+:/ {
    line=$0
    sub(/^[^:]*:[[:space:]]*/, "", line)
    n=split(line,a,/[[:space:]]+/)
    for(i=1;i<=n;i++) {
        if(a[i] ~ /^[[:xdigit:]]+$/ && (length(a[i])==4 || length(a[i])==8))
            continue
        if(a[i] ~ /^[[:alpha:]][[:alnum:].]*$/) {
            count++
            break
        }
    }
}
END { print count+0 }')

FREQ=$(printf '%s\n' "$OBJDUMP" | awk '
/^[[:space:]]*[[:xdigit:]]+:/ {
    line=$0
    sub(/^[^:]*:[[:space:]]*/, "", line)
    n=split(line,a,/[[:space:]]+/)
    for(i=1;i<=n;i++) {
        if(a[i] ~ /^[[:xdigit:]]+$/ && (length(a[i])==4 || length(a[i])==8))
            continue
        if(a[i] ~ /^[[:alpha:]][[:alnum:].]*$/) {
            count[a[i]]++
            break
        }
    }
}
END {
    for(m in count) print m, count[m]
}' | sort -k2,2nr -k1,1)

SIZE=$(stat -c %s "$BIN")
/usr/bin/time -v qemu-riscv64-static "$BIN" 2>"$TMP"
QEMU_STATUS=$?

WALL_RAW=$(awk -F': ' '/Elapsed \(wall clock\) time/ {print $2}' "$TMP")
USER_SEC=$(awk -F': ' '/User time \(seconds\)/ {print $2}' "$TMP")
WALL_SEC=$(awk -v t="$WALL_RAW" 'BEGIN {
    n=split(t,a,":")
    if(n==3) printf "%.6f", a[1]*3600+a[2]*60+a[3]
    else if(n==2) printf "%.6f", a[1]*60+a[2]
    else printf "%.6f", t+0
}')
USER_SEC=${USER_SEC:-0}

{
    echo "BINARY SIZE"
    echo "Binary: $BIN"
    echo "Size bytes: $SIZE"
    ls -l "$BIN"
    echo
    echo "STATIC INSTRUCTION COUNT"
    echo "Static instructions: $STATIC_COUNT"
    echo
    echo "INSTRUCTION FREQUENCY TABLE"
    echo "Mnemonic Count"
    printf '%s\n' "$FREQ"
    echo
    echo "EMULATED EXECUTION TIME"
    echo "Wall-clock seconds: $WALL_SEC"
    echo "User seconds: $USER_SEC"
    echo "QEMU exit status: $QEMU_STATUS"
} > "$REPORT"

cat "$REPORT"
if [ "$QEMU_STATUS" -ne 0 ]; then
    echo "WARNING: QEMU returned status $QEMU_STATUS" >&2
    exit "$QEMU_STATUS"
fi
