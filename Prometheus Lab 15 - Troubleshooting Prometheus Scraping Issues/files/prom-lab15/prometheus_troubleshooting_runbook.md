# Prometheus Scraping Troubleshooting Runbook (verified on Prometheus 2.47)
## First look: /api/v1/targets -> health + lastError (scrape failures are NOT logged at info level)
curl -s localhost:9090/api/v1/targets | jq -r '.data.activeTargets[] | "\(.labels.job) \(.health) \(.lastError)"'
## Error text -> cause
- "connect: connection refused"            -> nothing listens on that port (wrong port / service down)
- "server returned HTTP status 404"        -> wrong metrics_path
- "dial tcp: lookup <host> ... no such host" -> DNS name does not resolve
- "context deadline exceeded"              -> scrape_timeout shorter than the endpoint's response time
## Reload
systemctl reload prometheus needs ExecReload=/bin/kill -HUP $MAINPID in the unit; or curl -X POST localhost:9090/-/reload (--web.enable-lifecycle)
## Metrics that exist
up, scrape_duration_seconds, scrape_samples_scraped, scrape_series_added, prometheus_target_scrapes_exceeded_sample_limit_total
