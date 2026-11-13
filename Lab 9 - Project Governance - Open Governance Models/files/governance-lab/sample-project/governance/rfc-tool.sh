#!/usr/bin/env bash

set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PENDING="$ROOT/rfcs"
ACCEPTED="$ROOT/rfcs/accepted"
REJECTED="$ROOT/rfcs/rejected"

mkdir -p "$PENDING" "$ACCEPTED" "$REJECTED"

next_number() {
    local max=0 file base num
    for file in "$PENDING"/*.md "$ACCEPTED"/*.md "$REJECTED"/*.md; do
        [ -f "$file" ] || continue
        base="${file##*/}"
        num="${base%%-*}"
        if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -gt "$max" ]; then
            max="$num"
        fi
    done
    printf '%04d' "$((max + 1))"
}

case "${1:-}" in
    new)
        title="${2:-}"
        if [ -z "$title" ]; then
            echo "Usage: rfc-tool.sh new \"RFC title\""
            exit 1
        fi
        number="$(next_number)"
        slug="$(printf '%s' "$title" | tr '[:upper:] ' '[:lower:]-' | tr -cd 'a-z0-9-')"
        [ -n "$slug" ] || slug="proposal"
        file="$PENDING/$number-$slug.md"
        printf '# RFC: %s\n\n- **Status:** Pending\n- **Created:** %s\n\n## Summary\nDescribe the proposal.\n\n## Motivation\nExplain the problem.\n\n## Proposed solution\nDescribe the solution.\n\n## Alternatives\nList alternatives.\n\n## Impact\nDescribe impacts.\n\n## Decision\nPending review.\n' "$title" "$(date +%F)" > "$file"
        echo "Created: $file"
        ;;
    accept|reject)
        number="${2:-}"
        if [[ ! "$number" =~ ^[0-9]{1,4}$ ]]; then
            echo "Usage: rfc-tool.sh $1 RFC_NUMBER"
            exit 1
        fi
        number="$(printf '%04d' "$((10#$number))")"
        matches=( "$PENDING/$number"-*.md )
        if [ ! -f "${matches[0]}" ]; then
            echo "Pending RFC $number not found."
            exit 1
        fi
        if [ "$1" = "accept" ]; then
            destination="$ACCEPTED"
            status="Accepted"
        else
            destination="$REJECTED"
            status="Rejected"
        fi
        sed -i "s/\\*\\*Status:\\*\\* Pending/**Status:** $status/" "${matches[0]}"
        mv "${matches[0]}" "$destination/"
        echo "RFC $number $status."
        ;;
    list)
        echo "Pending RFCs:"
        find "$PENDING" -maxdepth 1 -type f -name '*.md' -printf '%f\n' | sort
        echo "Accepted RFCs:"
        find "$ACCEPTED" -maxdepth 1 -type f -name '*.md' -printf '%f\n' | sort
        echo "Rejected RFCs:"
        find "$REJECTED" -maxdepth 1 -type f -name '*.md' -printf '%f\n' | sort
        ;;
    *)
        echo "Usage: rfc-tool.sh {new|accept|reject|list} [argument]"
        exit 1
        ;;
esac
