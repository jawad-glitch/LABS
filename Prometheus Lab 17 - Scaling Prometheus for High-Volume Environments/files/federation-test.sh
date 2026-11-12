#!/bin/bash
echo "=== Query Federation Testing ==="
echo "1. Available Store Endpoints:"
curl -s "http://localhost:19090/api/v1/stores" | jq '.data[] | {name: .name, lastCheck: .lastCheck, labelSets: .labelSets}'
echo "2. Query with Store Information:"
curl -s "http://localhost:19090/api/v1/query?query=thanos_store_nodes_grpc_connections" | jq '.data.result[] | {store: .metric.instance, value: .value[1]}'
echo "3. External Labels Verification:"
curl -s "http://localhost:19090/api/v1/query?query=up" | jq '.data.result[] | {job: .metric.job, cluster: .metric.cluster, replica: .metric.replica}'
echo "4. Cross-Store Metrics Query:"
curl -s "http://localhost:19090/api/v1/query?query=count by (cluster, replica) (up)" | jq '.data.result[]'
