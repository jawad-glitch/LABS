#!/bin/bash
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
p() { echo -e "${1}[TEST] $2${NC}"; }
FLAG=$(kyverno apply --help 2>&1 | grep -oE -- '--exceptions?\b' | head -n1)
EXC=""; for e in exceptions/*.yaml; do [ -f "$e" ] && EXC="$EXC $FLAG $e"; done
run_test() {
  local name=$1 file=$2 expected=$3 actual
  kyverno apply policies --resource "$file" $EXC 2>&1 | grep -qE 'fail: 0, warn: 0, error: 0' && actual=pass || actual=fail
  if [ "$actual" = "$expected" ]; then p $GREEN "✓ PASS: $name (expected: $expected, got: $actual)"; return 0
  else p $RED "✗ FAIL: $name (expected: $expected, got: $actual)"; return 1; fi
}
total=0; passed=0
for t in "Compliant Deployment|manifests/compliant-deployment.yaml|pass" \
         "Bad Registry Deployment|manifests/bad-registry-deployment.yaml|fail" \
         "Latest Tag Deployment|manifests/latest-tag-deployment.yaml|fail" \
         "No Tag Deployment|manifests/no-tag-deployment.yaml|fail" \
         "Legacy App with Exemption|manifests/legacy-app-deployment.yaml|pass"; do
  IFS='|' read -r n f e <<< "$t"; [ -f "$f" ] || continue
  total=$((total+1)); run_test "$n" "$f" "$e" && passed=$((passed+1))
done
echo; p $YELLOW "Test Suite Summary: Total Tests: $total | Passed: $passed | Failed: $((total-passed))"
[ $passed -eq $total ] && { p $GREEN "🎉 All tests passed!"; exit 0; } || { p $RED "❌ Some tests failed"; exit 1; }
