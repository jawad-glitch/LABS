# Lab 9: Collector Pipelines & Processors - Summary Report

## Pipeline Components Implemented
- **OTLP Receiver**: ports 4317 (gRPC) and 4318 (HTTP)
- **Memory Limiter**: 256 MiB limit, 64 MiB spike limit (first processor)
- **Attributes Processor**: service.environment=dev, lab.name, lab.number=9, processed.timestamp, pipeline.version=v1.0
- **Batch Processor**: 512 batch size / 2s timeout after Task 6 (last processor)
- **Debug Exporter** (replaces removed 'logging' exporter) + **File Exporter** (./data/otel-data.json)
- **health_check** extension on 13133; collector self-metrics on 8888/metrics

## Pipeline Flow
1. OTLP receiver -> 2. memory_limiter -> 3. attributes -> 4. batch -> 5. debug + file exporters

## Key Learnings
1. Processors run in the listed order; memory_limiter first, batch last is the recommended order
2. Attributes processor enriches spans, metric data points and log records
3. Multiple exporters can receive the same pipeline output
4. OTLP/JSON trace ids are 32 hex chars and span ids 16 hex chars - shorter ids are rejected (HTTP 400)
