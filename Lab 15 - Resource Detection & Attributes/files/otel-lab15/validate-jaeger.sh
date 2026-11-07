#!/usr/bin/env bash
# File: ~/otel-lab15/validate-jaeger.sh

JAEGER_API="http://localhost:16686/api"
SERVICE="sample-app"

TRACES=$(curl -fsSL "${JAEGER_API}/traces?service=${SERVICE}&limit=5")

if [ -z "$TRACES" ] || [ "$(echo "$TRACES" | jq '.data | length')" -eq 0 ]; then
  echo "FAIL: No traces found for service ${SERVICE}"
  exit 1
fi

# extract_process_tags: key/value pairs on the process (resource) record of the most recent trace
extract_process_tags() {
  echo "$TRACES" | jq -r '.data[0].processes | to_entries[0].value.tags[] | "\(.key): \(.value)"'
}

echo "=== Process-level resource attributes on most recent trace ==="
extract_process_tags | sort

echo ""
echo "=== Asserting required attributes are present ==="

REQUIRED_KEYS=(
  "host.name"
  "os.type"
  "service.namespace"
  "service.instance.id"
  "lab.id"
  "cluster.name"
)

MISSING=0
for KEY in "${REQUIRED_KEYS[@]}"; do
  FOUND=$(echo "$TRACES" | jq -r --arg k "$KEY" '
    .data[0].processes | to_entries[0].value.tags[]
    | select(.key == $k) | .value
  ')
  if [ -z "$FOUND" ]; then
    echo "MISSING: $KEY"
    MISSING=$((MISSING + 1))
  else
    echo "OK:      $KEY = $FOUND"
  fi
done

[ "$MISSING" -eq 0 ] && echo "All required resource attributes present." \
  || echo "FAIL: $MISSING attribute(s) missing - review processor configuration."
