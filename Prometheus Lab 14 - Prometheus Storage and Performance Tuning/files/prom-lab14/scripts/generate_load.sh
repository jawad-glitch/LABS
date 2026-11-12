#!/bin/bash
echo "Generating load for Prometheus performance testing..."
make_queries() {
    for i in {1..10}; do
        curl -s "http://localhost:9090/api/v1/query?query=up" > /dev/null &
        curl -s "http://localhost:9090/api/v1/query_range?query=rate(node_cpu_seconds_total[5m])&start=$(date -d '1 hour ago' +%s)&end=$(date +%s)&step=60" > /dev/null &
        curl -s "http://localhost:9090/api/v1/query?query=node_memory_MemAvailable_bytes" > /dev/null &
    done
    wait
}
echo "Starting load generation..."
for round in {1..6}; do
    echo "Round $round/6"
    make_queries
    sleep 5
done
echo "Load generation completed."
