# Histogram vs Summary: Observed Differences

## 1. Aggregation across label dimensions
`http_request_duration_seconds_bucket` series are counters per `le`, so `sum by (le) (rate(...))` over two instances and then `histogram_quantile(0.99, ...)` gave 1.4090384615384748s against a true combined p99 of 1.1030s, which falls in the same bucket. The summary series `rpc_call_duration_seconds{quantile="0.99"}` are already-finished quantiles per instance (localhost:8004=0.169 localhost:8014=0.629); `avg()` of them gave 0.3994403208685188s against a true combined p99 of 0.5558s, because averaging quantiles is not a quantile of the combined data.

## 2. Where the quantile computation happens
The Summary computed its quantiles inside the Python process (summary_app.py keeps a 60 s sliding window and exposes `quantile="0.5|0.9|0.99"` series), so Prometheus only stores the results. The Histogram only exposes bucket counts, and the quantile was computed at query time by `histogram_quantile()` over `rate(http_request_duration_seconds_bucket[2m])`. Note: the official Python client's `Summary` exposes only `_count` and `_sum` (no quantiles), so a custom collector was needed here.

## 3. When you would choose each type in production
Choose a Histogram for request latency of a horizontally scaled service (e.g. `http_request_duration_seconds` behind a load balancer), because you need fleet-wide p99 and SLO burn rates, which require summing buckets across pods. Choose a Summary for a single process where you need an accurate quantile without knowing the distribution in advance and never need to combine instances, e.g. a batch job's own `rpc_call_duration_seconds` p99 reported from one long-running worker.
