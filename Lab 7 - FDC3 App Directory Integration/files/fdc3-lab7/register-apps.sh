#!/usr/bin/env bash
cd "$HOME/fdc3-lab7" || exit 1
failed=0
count=0
response_file=$(mktemp)

for file in sample-apps/*.json; do
  [ -f "$file" ] || continue
  count=$((count + 1))
  status=$(curl -sS -o "$response_file" -w '%{http_code}' \
    -H 'Content-Type: application/json' \
    --data-binary @"$file" \
    http://127.0.0.1:3001/v2/apps)
  app_id=$(jq -r '.appId // "unknown"' "$response_file" 2>/dev/null)
  printf 'HTTP %s | %s\n' "$status" "$app_id"
  if [ "$status" != "201" ]; then
    cat "$response_file"
    failed=1
  fi
done

rm -f "$response_file"
if [ "$count" -ne 3 ]; then
  echo "Expected 3 metadata files; found $count."
  failed=1
fi

if [ "$failed" -ne 0 ]; then
  echo "Registration failed."
  exit 1
fi
echo "SUCCESS: All three applications registered."
