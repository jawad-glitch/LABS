#!/bin/bash
BASE="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE" || exit 1
mkdir -p results packages
FAILED_STAGE=""
FAILED_LOG=""

rollback() {
  echo "========== AUTOMATIC ROLLBACK =========="
  bash scripts/network.sh down >/dev/null 2>&1
  rm -f packages/inventory_1.0.tar.gz
  {
    echo "Timestamp: $(date -Iseconds)"
    echo "Failed stage: $FAILED_STAGE"
    echo "Last command output:"
    tail -n 20 "$FAILED_LOG" 2>/dev/null
  } > rollback-report.txt
  cat rollback-report.txt
  exit 1
}

run_stage() {
  NAME="$1"
  shift
  LOG="results/${NAME}.log"
  echo "========== $NAME =========="
  if "$@" > "$LOG" 2>&1; then
    cat "$LOG"
    echo "Stage $STAGE complete: $NAME"
  else
    cat "$LOG"
    FAILED_STAGE="$NAME"
    FAILED_LOG="$LOG"
    rollback
  fi
}

STAGE=1
run_stage "build" npm install --prefix chaincode --ignore-scripts --no-audit --no-fund

STAGE=2
run_stage "test" npm --prefix chaincode test

STAGE=3
run_stage "package" tar -czf packages/inventory_1.0.tar.gz chaincode/index.js chaincode/package.json

STAGE=4
run_stage "deploy" bash -c 'bash scripts/network.sh up && bash scripts/deploy.sh && bash health-check.sh'

echo "========== PIPELINE SUCCESS =========="
echo "All four stages completed successfully."
echo "Final inventory query:"
bash scripts/query.sh
