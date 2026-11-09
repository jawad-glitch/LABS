#!/bin/bash
TEMPLATE_FILE=$1
if [ -z "$TEMPLATE_FILE" ]; then echo "Usage: $0 <template-file>"; exit 1; fi
yget() { python3 - "$TEMPLATE_FILE" "$1" <<'PY'
import sys, yaml
v = yaml.safe_load(open(sys.argv[1]))
for k in sys.argv[2].split("."):
    v = v.get(k) if isinstance(v, dict) else None
print(v)
PY
}
FAILS=0
echo "=== Validating Workflow Template ==="; echo "File: $TEMPLATE_FILE"; echo ""
echo "1. Checking YAML syntax..."
if python3 -c 'import sys,yaml; yaml.safe_load(open(sys.argv[1]))' "$TEMPLATE_FILE" 2>/dev/null; then echo "   ✓ YAML syntax is valid"; else echo "   ✗ YAML syntax error"; exit 1; fi
echo "2. Checking required fields..."
if [ "$(yget kind)" = "WorkflowTemplate" ]; then echo "   ✓ Kind is WorkflowTemplate"; else echo "   ✗ Kind should be WorkflowTemplate"; FAILS=$((FAILS+1)); fi
EP=$(yget spec.entrypoint)
if [ -n "$EP" ] && [ "$EP" != "None" ]; then echo "   ✓ Entrypoint is defined ($EP)"; else echo "   ✗ Entrypoint is missing"; FAILS=$((FAILS+1)); fi
echo "3. Server-side dry run (API server)..."
if kubectl apply -f "$TEMPLATE_FILE" --dry-run=server > /dev/null 2>&1; then echo "   ✓ Accepted by API server"; else echo "   ✗ Rejected by API server"; FAILS=$((FAILS+1)); fi
echo "4. argo lint (Argo's own validation)..."
if argo lint "$TEMPLATE_FILE" > /dev/null 2>&1; then echo "   ✓ argo lint passed"; else echo "   ✗ argo lint failed"; FAILS=$((FAILS+1)); fi
echo ""; echo "Validation complete! ($FAILS problem(s))"
[ $FAILS -eq 0 ]
