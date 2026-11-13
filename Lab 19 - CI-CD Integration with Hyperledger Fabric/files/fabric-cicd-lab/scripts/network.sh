#!/bin/bash
BASE="$(cd "$(dirname "$0")/.." && pwd)"
STATE="$BASE/network-state"
case "${1:-}" in
 up)
  mkdir -p "$STATE"
  printf 'peer0 Up\npeer1 Up\norderer Up\nca_org1 Up\nca_org2 Up\n' > "$STATE/containers.txt"
  echo "Local Fabric network simulation started."
  ;;
 down)
  rm -rf "$STATE"
  mkdir -p "$STATE"
  echo "Local Fabric network simulation stopped."
  ;;
 *)
  echo "Usage: network.sh up|down"
  exit 1
  ;;
esac
