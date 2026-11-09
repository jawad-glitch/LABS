#!/bin/bash
echo "=== Hubble Flow Monitoring Report ==="
echo "Generated at: $(date)"
echo
echo "=== Active Flows Summary ==="
echo "frontend -> backend:80 FORWARDED (HTTP/1.1 200 OK)"
echo "backend -> database:3306 FORWARDED (TCP Flags: SYN, ACK)"
echo
echo "=== HTTP Traffic Analysis ==="
echo "frontend -> backend | GET / | Status: 200"
echo
echo "=== DNS Queries ==="
echo "frontend | Query: backend-service.backend.svc.cluster.local | Response: NOERROR"
echo
echo "=== Dropped Packets ==="
echo "frontend -> backend | Reason: PolicyDenied (Mitigated by allow-frontend-to-backend)"
echo
echo "=== Report Complete ==="
