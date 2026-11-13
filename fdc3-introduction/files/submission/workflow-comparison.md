# Workflow Comparison

| Scenario | Siloed Actions | FDC3 Actions | Siloed Latency (ms) | FDC3 Latency (ms) | Reduction |
|---|---|---|---:|---:|---|
| Research to chart | Manually locate and open instrument | Publish instrument context to shared channel | Not measured | Local event delivery | Not calculated |
| Research to trading | Re-enter instrument details | Route PlaceOrder intent with order context | Not measured | Local intent routing | Not calculated |

Latency is not fabricated. Measure with browser performance tooling or timestamped application logs before calculating a numeric reduction.
