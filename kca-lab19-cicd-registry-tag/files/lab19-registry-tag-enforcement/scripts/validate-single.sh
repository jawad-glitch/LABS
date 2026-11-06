#!/bin/bash
# Usage: ./validate-single.sh <manifest-file>
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
p() { echo -e "${1}$2${NC}"; }
[ $# -eq 0 ] && { p $RED "Usage: $0 <manifest-file>"; exit 1; }
[ -f "$1" ] || { p $RED "Error: Manifest file '$1' not found"; exit 1; }
p $BLUE "Validating manifest: $(basename "$1") (policies/)"
kyverno apply policies --resource "$1" --detailed-results 2>&1 | grep -vE '^\s*$'
p $YELLOW "Validation completed for $(basename "$1")"
