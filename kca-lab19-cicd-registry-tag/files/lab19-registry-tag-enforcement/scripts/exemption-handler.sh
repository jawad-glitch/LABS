#!/bin/bash
GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'
FLAG=$(kyverno apply --help 2>&1 | grep -oE -- '--exceptions?\b' | head -n1)
OUT=$(kyverno apply policies --resource manifests/legacy-app-deployment.yaml $FLAG exceptions/policy-exemption.yaml 2>&1)
echo "$OUT" | tail -n 3
if echo "$OUT" | grep -qE 'fail: 0, warn: 0, error: 0'; then echo -e "${GREEN}✓ Legacy app passed validation with exemption${NC}"; exit 0
else echo -e "${RED}✗ Legacy app failed validation despite exemption${NC}"; exit 1; fi
