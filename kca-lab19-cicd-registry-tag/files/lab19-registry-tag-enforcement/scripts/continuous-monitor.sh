#!/bin/bash
# Watches manifests/ and validates new/changed YAML (runs until Ctrl+C).
WATCH_DIR="manifests"; POLICY_DIR="policies"; PROCESSED_DIR="processed"; mkdir -p "$PROCESSED_DIR"
command -v inotifywait >/dev/null || { sudo apt-get install -y inotify-tools < /dev/null; }
trap 'echo "Monitoring stopped"; exit 0' INT
inotifywait -m -e close_write -e moved_to --format '%w%f' "$WATCH_DIR" | while read -r f; do
  [[ "$f" == *.yaml ]] || continue
  if kyverno apply "$POLICY_DIR" --resource "$f" 2>&1 | grep -qE 'fail: 0, warn: 0, error: 0'; then
    echo "✓ $(basename "$f") passed"; cp "$f" "$PROCESSED_DIR/"
  else echo "✗ $(basename "$f") rejected"; fi
done
