#!/usr/bin/env bash

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
echo "======================================"
echo "       PROJECT GOVERNANCE DASHBOARD"
echo "======================================"
echo "Project: $(basename "$ROOT")"
echo "Governance: Hybrid"
echo "RFC status:"
for state in pending accepted rejected; do
    case "$state" in
        pending) dir="$ROOT/rfcs" ;;
        accepted) dir="$ROOT/rfcs/accepted" ;;
        rejected) dir="$ROOT/rfcs/rejected" ;;
    esac
    count=0
    if [ -d "$dir" ]; then
        while IFS= read -r file; do
            [ -n "$file" ] && count=$((count + 1))
        done < <(find "$dir" -maxdepth 1 -type f -name '*.md' ! -name '0000-template.md')
    fi
    printf '  %-10s %s\n' "$state" "$count"
done
echo "Documentation:"
for file in README.md LICENSE CONTRIBUTING.md governance/GOVERNANCE.md; do
    if [ -f "$ROOT/$file" ]; then
        echo "  [OK] $file"
    else
        echo "  [MISSING] $file"
    fi
done
echo "======================================"
