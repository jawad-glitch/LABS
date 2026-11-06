#!/bin/bash
REPORT_FILE="results/final_lab_report_$(date +%Y%m%d_%H%M%S).md"
{
  echo "# Lab 19: Registry & Tag Enforcement in CI/CD - Final Report"; echo
  echo "## Policies Implemented"
  echo "- enforce-registry: images must come from docker.io, gcr.io or quay.io (Pod rules, autogen for controllers)"
  echo "- enforce-tags: explicit tag required, no 'latest', semantic version via regex_match()"
  echo "- PolicyException registry-exemption-legacy for legacy-app* Deployments"; echo
  echo "## Validation Test Results"; echo '```'
  ./scripts/test-suite.sh 2>&1 | sed 's/\x1b\[[0-9;]*m//g'
  echo '```'; echo
  echo "## Pipeline Run"; echo '```'
  ./scripts/pipeline-validator.sh 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | tail -n 4
  echo '```'; echo
  echo "---"; echo "*Report generated on: $(date)*"
} > "$REPORT_FILE"
echo "Final report generated: $REPORT_FILE"
