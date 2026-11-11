#!/bin/bash
# Fixed: average duration of the ROOT span (no references), not .spans[0] (Jaeger does not order spans)
J=${1:-http://localhost:16686}; S=${2:-productpage.bookinfo}
curl -s "$J/api/traces?service=$S&limit=20" | jq '[.data[] | [.spans[] | select((.references // []) | length == 0)] | max_by(.duration).duration / 1000] | if length > 0 then (add / length | floor) else 0 end' | xargs -I{} echo "Average root-span duration: {}ms"
