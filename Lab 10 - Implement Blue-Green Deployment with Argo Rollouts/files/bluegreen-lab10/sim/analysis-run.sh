set -e
for i in $(seq 1 10); do
  response=$(curl -s -o /dev/null -w "%{http_code}" http://demo-app-preview.blue-green-demo.svc.cluster.local)
  if [ "$response" != "200" ]; then
    echo "Request failed with status: $response"
    exit 1
  fi
  sleep 1
done
echo "All requests successful"

