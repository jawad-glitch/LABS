# Lab 18 - Multi-Pipeline Export (Jaeger + Zipkin) - completion proof
Completed (UTC): 2026-11-07 01:36:43 | EC2: i-05e9da12f632f50f0 | host: ip-172-31-10-125 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 18 - Multi-Pipeline Export (Jaeger + Zipkin), 2026-11-07 01:36:39 UTC) ==========
PASS: Task 1: Zipkin running (API + UI reachable)
PASS: Task 2: Jaeger running (health :14269 + UI :16686)
PASS: Task 3: lab's original config rejected (removed jaeger/logging exporters); fixed configs validate
PASS: Task 3.3: collector exports to otlp/jaeger + zipkin + debug in one traces pipeline
PASS: Task 4: generator produced 3 traces
PASS: Task 5.4: verify_traces.sh finds traces in BOTH backends
PASS: Task 5.3: the same 3 trace IDs exist in Jaeger and Zipkin
PASS: Task 5.3: identical 5-span structure and attributes in both backends
PASS: Task 6: advanced collector (probabilistic_sampler 100%) running and exporting
PASS: Task 7.3: health_check.sh - all backends healthy
PASS: Task 8: after load test, all 21 traces present in both backends
PASS: Task 8.2: collector sent the same span count to Jaeger and Zipkin, 0 failures
CORE: 12/12 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE                                 COMMAND                  CREATED              STATUS                        PORTS                                                                                                                                                                                                NAMES
719fbe3af123   otel/opentelemetry-collector:latest   "/otelcol --config=/…"   39 seconds ago       Up 38 seconds                 0.0.0.0:4317-4318->4317-4318/tcp, [::]:4317-4318->4317-4318/tcp, 0.0.0.0:8888->8888/tcp, [::]:8888->8888/tcp, 55679/tcp                                                                              otel-collector-advanced
379dbf9fc885   jaegertracing/all-in-one:latest       "/go/bin/all-in-one-…"   About a minute ago   Up About a minute             4317-4318/tcp, 0.0.0.0:14250->14250/tcp, [::]:14250->14250/tcp, 0.0.0.0:14268-14269->14268-14269/tcp, [::]:14268-14269->14268-14269/tcp, 9411/tcp, 0.0.0.0:16686->16686/tcp, [::]:16686->16686/tcp   jaeger
eeced04b0d16   openzipkin/zipkin:latest              "start-zipkin"           About a minute ago   Up About a minute (healthy)   9410/tcp, 0.0.0.0:9411->9411/tcp, [::]:9411->9411/tcp                                                                                                                                                zipkin

IMAGE                                         ID             DISK USAGE   CONTENT SIZE   EXTRA
jaegertracing/all-in-one:latest               ab6f1a1f0fb4        123MB         37.4MB   U    
openzipkin/zipkin:latest                      d17e856dcbba        393MB          155MB   U    
otel/opentelemetry-collector-contrib:latest   340c9ca6a366        537MB          116MB        
otel/opentelemetry-collector:latest           28b6d41ac51b        232MB         48.3MB   U    
```

## Files
```
./otel-multi-export/original-lab-config.yaml
./otel-multi-export/otel-collector-advanced.yaml
./otel-multi-export/otel-collector-config.yaml
./otel-multi-export/results/collector-advanced.log
./otel-multi-export/results/collector-basic.log
./otel-multi-export/results/compare-final.txt
./otel-multi-export/results/compare-run1.txt
./otel-multi-export/results/export-stats.txt
./otel-multi-export/results/health.txt
./otel-multi-export/results/loadtest.txt
./otel-multi-export/results/run1.txt
./otel-multi-export/results/run2.txt
./otel-multi-export/results/validate-original-lab-config.yaml.txt
./otel-multi-export/results/validate-otel-collector-advanced.yaml.txt
./otel-multi-export/results/validate-otel-collector-config.yaml.txt
./otel-multi-export/results/verify-final.txt
./otel-multi-export/results/verify-run1.txt
./otel-multi-export/results/zipkin-services-before.json
./trace-app/compare_backends.py
./trace-app/health_check.sh
./trace-app/load_test.py
./trace-app/requirements.txt
./trace-app/trace_generator.py
./trace-app/verify_traces.sh
```
