#!/bin/bash

# CI-Style OpenTelemetry Validation Script
# This script validates OpenTelemetry infrastructure health
# Exit codes: 0 = success, 1 = failure

COLLECTOR_HEALTH_URL="http://localhost:13133"
COLLECTOR_OTLP_URL="http://localhost:4318"
PROMETHEUS_URL="http://localhost:9090"
LOG_FILE="/tmp/otel_check.log"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

print_status() {
    local status=$1
    local message=$2
    if [ "$status" = "PASS" ]; then
        echo -e "${GREEN}[PASS]${NC} $message"
    elif [ "$status" = "FAIL" ]; then
        echo -e "${RED}[FAIL]${NC} $message"
    elif [ "$status" = "INFO" ]; then
        echo -e "${YELLOW}[INFO]${NC} $message"
    fi
}

check_collector_health() {
    print_status "INFO" "Checking OpenTelemetry Collector health..."

    local http_code
    http_code=$(curl -s -o /tmp/health_response.json -w "%{http_code}" "$COLLECTOR_HEALTH_URL")

    if [ "$http_code" = "200" ]; then
        print_status "PASS" "Collector health check successful (HTTP $http_code)"
        log "Collector health check passed"
        return 0
    else
        print_status "FAIL" "Collector health check failed (HTTP $http_code)"
        log "Collector health check failed with HTTP code: $http_code"
        return 1
    fi
}

send_test_span() {
    print_status "INFO" "Sending test span to OpenTelemetry Collector..."

    cat > /tmp/send_test_span.py << 'PYTHON_EOF'
import time
import requests
from datetime import datetime

def send_test_span():
    url = "http://localhost:4318/v1/traces"

    now_ns = int(time.time() * 1_000_000_000)

    trace_data = {
        "resourceSpans": [
            {
                "resource": {
                    "attributes": [
                        {"key": "service.name", "value": {"stringValue": "ci-validation-test"}},
                        {"key": "service.version", "value": {"stringValue": "1.0.0"}}
                    ]
                },
                "scopeSpans": [
                    {
                        "scope": {"name": "ci-validation-scope", "version": "1.0.0"},
                        "spans": [
                            {
                                "traceId": "12345678901234567890123456789012",
                                "spanId": "1234567890123456",
                                "name": "ci-validation-test-span",
                                "kind": 1,
                                "startTimeUnixNano": str(now_ns),
                                "endTimeUnixNano": str(now_ns + 1_000_000),
                                "attributes": [
                                    {"key": "test.type", "value": {"stringValue": "ci-validation"}},
                                    {"key": "test.timestamp", "value": {"stringValue": datetime.now().isoformat()}}
                                ],
                                "status": {"code": 1}
                            }
                        ]
                    }
                ]
            }
        ]
    }

    headers = {"Content-Type": "application/json"}

    try:
        response = requests.post(url, json=trace_data, headers=headers, timeout=10)
        if response.status_code == 200:
            print(f"SUCCESS: Test span sent successfully (HTTP {response.status_code})")
            return True
        else:
            print(f"ERROR: Failed to send test span (HTTP {response.status_code})")
            print(f"Response: {response.text}")
            return False
    except Exception as e:
        print(f"ERROR: Exception while sending test span: {e}")
        return False

if __name__ == "__main__":
    success = send_test_span()
    exit(0 if success else 1)
PYTHON_EOF

    if python3 /tmp/send_test_span.py; then
        print_status "PASS" "Test span sent successfully"
        log "Test span sent successfully"
        return 0
    else
        print_status "FAIL" "Failed to send test span"
        log "Failed to send test span"
        return 1
    fi
}

send_test_metrics() {
    print_status "INFO" "Sending test metrics to OpenTelemetry Collector..."

    cat > /tmp/send_test_metrics.py << 'PYTHON_EOF'
import time
import requests

def send_test_metrics():
    url = "http://localhost:4318/v1/metrics"

    metrics_data = {
        "resourceMetrics": [
            {
                "resource": {
                    "attributes": [
                        {"key": "service.name", "value": {"stringValue": "ci-validation-test"}}
                    ]
                },
                "scopeMetrics": [
                    {
                        "scope": {"name": "ci-validation-metrics", "version": "1.0.0"},
                        "metrics": [
                            {
                                "name": "ci_validation_test_counter",
                                "description": "Test counter for CI validation",
                                "unit": "1",
                                "sum": {
                                    "dataPoints": [
                                        {
                                            "attributes": [
                                                {"key": "test.type", "value": {"stringValue": "ci-validation"}}
                                            ],
                                            "timeUnixNano": str(int(time.time() * 1_000_000_000)),
                                            "asInt": 42
                                        }
                                    ],
                                    "aggregationTemporality": 2,
                                    "isMonotonic": True
                                }
                            }
                        ]
                    }
                ]
            }
        ]
    }

    headers = {"Content-Type": "application/json"}

    try:
        response = requests.post(url, json=metrics_data, headers=headers, timeout=10)
        if response.status_code == 200:
            print(f"SUCCESS: Test metrics sent successfully (HTTP {response.status_code})")
            return True
        else:
            print(f"ERROR: Failed to send test metrics (HTTP {response.status_code})")
            print(f"Response: {response.text}")
            return False
    except Exception as e:
        print(f"ERROR: Exception while sending test metrics: {e}")
        return False

if __name__ == "__main__":
    success = send_test_metrics()
    exit(0 if success else 1)
PYTHON_EOF

    if python3 /tmp/send_test_metrics.py; then
        print_status "PASS" "Test metrics sent successfully"
        log "Test metrics sent successfully"
        return 0
    else
        print_status "FAIL" "Failed to send test metrics"
        log "Failed to send test metrics"
        return 1
    fi
}

check_prometheus_scrape() {
    print_status "INFO" "Checking Prometheus scraping status..."

    sleep 5

    local http_code
    # -G + --data-urlencode: a raw up{job="..."} in the URL is treated by curl as a glob and never sent
    http_code=$(curl -s -G -o /tmp/prometheus_response.json -w "%{http_code}" \
        "${PROMETHEUS_URL}/api/v1/query" --data-urlencode 'query=up{job="otel-collector"}')

    if [ "$http_code" = "200" ]; then
        local up_value
        up_value=$(python3 -c "
import json
with open('/tmp/prometheus_response.json', 'r') as f:
    data = json.load(f)
    if data['status'] == 'success' and len(data['data']['result']) > 0:
        print(data['data']['result'][0]['value'][1])
    else:
        print('0')
")

        if [ "$up_value" = "1" ]; then
            print_status "PASS" "Prometheus scraping is working (target is up)"
            log "Prometheus scraping check passed"
            return 0
        else
            print_status "FAIL" "Prometheus target is down (up=$up_value)"
            log "Prometheus scraping check failed - target down"
            return 1
        fi
    else
        print_status "FAIL" "Failed to query Prometheus (HTTP $http_code)"
        log "Prometheus query failed with HTTP code: $http_code"
        return 1
    fi
}

main() {
    local exit_code=0

    print_status "INFO" "Starting CI-Style OpenTelemetry Validation"
    print_status "INFO" "Log file: $LOG_FILE"

    log "Starting OpenTelemetry validation checks"

    check_collector_health || exit_code=1
    send_test_span || exit_code=1
    send_test_metrics || exit_code=1
    check_prometheus_scrape || exit_code=1

    if [ $exit_code -eq 0 ]; then
        print_status "PASS" "All OpenTelemetry validation checks passed!"
        log "All validation checks passed successfully"
    else
        print_status "FAIL" "One or more validation checks failed!"
        log "Validation failed - check individual test results above"
    fi

    return $exit_code
}

main "$@"
