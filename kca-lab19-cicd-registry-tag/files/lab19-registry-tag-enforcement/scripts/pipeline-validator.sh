#!/bin/bash
# CI/CD Pipeline Validator: validates every manifest with Kyverno CLI before deployment.
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
POLICY_DIR="policies"; MANIFEST_DIR="manifests"; RESULTS_DIR="results"; EXC_DIR="exceptions"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S"); VALIDATION_REPORT="$RESULTS_DIR/validation_report_$TIMESTAMP.txt"
print_status() { echo -e "${1}[$(date '+%Y-%m-%d %H:%M:%S')] $2${NC}"; }
EXC_ARGS=""
FLAG=$(kyverno apply --help 2>&1 | grep -oE -- '--exceptions?\b' | head -n1)
if [ -n "$FLAG" ]; then for e in "$EXC_DIR"/*.yaml; do [ -f "$e" ] && EXC_ARGS="$EXC_ARGS $FLAG $e"; done; fi

validate_manifest() {
  local f=$1 name; name=$(basename "$f" .yaml)
  print_status $BLUE "Validating manifest: $name"
  local out rc; out=$(kyverno apply "$POLICY_DIR" --resource "$f" $EXC_ARGS 2>&1); rc=$?
  if [ $rc -eq 0 ] && echo "$out" | grep -qE 'fail: 0, warn: 0, error: 0'; then
    print_status $GREEN "✓ PASS: $name is compliant"; echo "PASS: $name" >> "$VALIDATION_REPORT"; return 0
  fi
  print_status $RED "✗ FAIL: $name has policy violations"
  { echo "FAIL: $name"; echo "Violations:"; echo "$out" | grep -E 'validation error|failed:' | sed 's/^/  /'; echo "---"; } >> "$VALIDATION_REPORT"
  echo "$out" | grep -E 'validation error' | sed 's/^/    /'
  return 1
}

run_pipeline() {
  print_status $YELLOW "Starting CI/CD Pipeline Validation"
  { echo "Kyverno Policy Validation Report"; echo "Generated: $(date)"; echo "========================================"; echo; } > "$VALIDATION_REPORT"
  local total=0 passed=0 failed=0
  for m in "$MANIFEST_DIR"/*.yaml; do
    [ -f "$m" ] || continue
    total=$((total+1))
    if validate_manifest "$m"; then passed=$((passed+1)); else failed=$((failed+1)); fi
    echo
  done
  { echo; echo "SUMMARY:"; echo "Total Manifests: $total"; echo "Passed: $passed"; echo "Failed: $failed"; } >> "$VALIDATION_REPORT"
  print_status $YELLOW "Pipeline Validation Summary: total=$total passed=$passed failed=$failed"
  if [ $failed -eq 0 ]; then print_status $GREEN "🎉 PIPELINE SUCCESS: All manifests are compliant!"; echo "PIPELINE RESULT: SUCCESS" >> "$VALIDATION_REPORT"; return 0
  else print_status $RED "❌ PIPELINE FAILED: $failed manifest(s) failed validation"; echo "PIPELINE RESULT: FAILED" >> "$VALIDATION_REPORT"; return 1; fi
}

mkdir -p "$RESULTS_DIR"
command -v kyverno >/dev/null || { print_status $RED "Kyverno CLI not found"; exit 1; }
if run_pipeline; then print_status $GREEN "Report saved to: $VALIDATION_REPORT"; exit 0
else print_status $RED "Pipeline failed. Report saved to: $VALIDATION_REPORT"; exit 1; fi
