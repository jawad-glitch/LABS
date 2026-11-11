#!/bin/bash
final_line=$(tail -1 loadbalancing-results.csv); IFS=',' read -ra values <<< "$final_line"; counts=("${values[@]:1}")
total=0; for count in "${counts[@]}"; do total=$((total + count)); done
average=$((total / ${#counts[@]})); echo "Total requests: $total"
for i in "${!counts[@]}"; do percentage=$(( (counts[i] * 100) / total )); echo "Pod $((i+1)): ${counts[i]} requests (${percentage}%)"; done
max_count=$(printf '%s\n' "${counts[@]}" | sort -n | tail -1); min_count=$(printf '%s\n' "${counts[@]}" | sort -n | head -1)
variance=$(( (max_count - min_count) * 100 / average )); echo "variance: ${variance}%"
