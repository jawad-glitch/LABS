// ---- OpenTelemetry MUST start before express/http are required, or nothing gets instrumented ----
const { NodeSDK } = require('@opentelemetry/sdk-node');
const { HttpInstrumentation } = require('@opentelemetry/instrumentation-http');
const { ExpressInstrumentation } = require('@opentelemetry/instrumentation-express');
const { OTLPTraceExporter } = require('@opentelemetry/exporter-trace-otlp-http');
const { PrometheusExporter } = require('@opentelemetry/exporter-prometheus');

const sdk = new NodeSDK({
  serviceName: 'incident-drill-app',
  instrumentations: [new HttpInstrumentation(), new ExpressInstrumentation()],
  // Jaeger ingests OTLP directly (the Jaeger Thrift exporter is deprecated)
  traceExporter: new OTLPTraceExporter({ url: 'http://localhost:4318/v1/traces' }),
  // NodeSDK takes a metricReader (PrometheusExporter is a pull reader), not 'metricExporter'
  metricReader: new PrometheusExporter({ port: 9090 }),
});
sdk.start();

const express = require('express');
const winston = require('winston');
const { trace, metrics } = require('@opentelemetry/api');

// Configure logger with trace correlation
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(winston.format.timestamp(), winston.format.json()),
  transports: [
    new winston.transports.File({ filename: '../logs/app.log' }),
    new winston.transports.Console()
  ]
});

// The metrics the dashboard queries (http_requests_total, http_request_duration_seconds) - second-scale buckets
const meter = metrics.getMeter('incident-drill-app');
const requestsTotal = meter.createCounter('http_requests_total', { description: 'HTTP requests' });
const requestDuration = meter.createHistogram('http_request_duration_seconds', {
  description: 'HTTP request duration', unit: 's',
  advice: { explicitBucketBoundaries: [0.025, 0.05, 0.075, 0.1, 0.25, 0.5, 1, 2, 2.5, 3, 5] }
});

const app = express();
const port = 3000;

// Global variables for injecting issues
let injectLatency = false;
let injectErrors = false;
let latencyAmount = 0;

// Middleware: trace ID for logs + request metrics
app.use((req, res, next) => {
  const span = trace.getActiveSpan();
  if (span) {
    req.traceId = span.spanContext().traceId;
  }
  const start = process.hrtime.bigint();
  res.on('finish', () => {
    const attrs = { method: req.method, route: req.path, status_code: String(res.statusCode) };
    requestsTotal.add(1, attrs);
    requestDuration.record(Number(process.hrtime.bigint() - start) / 1e9, attrs);
  });
  next();
});

// Health check endpoint
app.get('/health', (req, res) => {
  logger.info('Health check requested', { traceId: req.traceId });
  res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

// Main work endpoint - this is where we'll inject issues
app.get('/work', async (req, res) => {
  const startTime = Date.now();

  logger.info('Work request started', { traceId: req.traceId, timestamp: new Date().toISOString() });

  try {
    // Simulate some work
    await simulateWork();

    // Inject latency if enabled
    if (injectLatency) {
      logger.warn('Injecting artificial latency', { traceId: req.traceId, latencyMs: latencyAmount });
      await new Promise(resolve => setTimeout(resolve, latencyAmount));
    }

    // Inject errors if enabled
    if (injectErrors && Math.random() < 0.3) {
      logger.error('Injected error occurred', { traceId: req.traceId });
      throw new Error('Simulated error for testing');
    }

    const duration = Date.now() - startTime;
    logger.info('Work request completed', { traceId: req.traceId, duration: duration, timestamp: new Date().toISOString() });

    res.json({ message: 'Work completed successfully', duration: duration, traceId: req.traceId });

  } catch (error) {
    const duration = Date.now() - startTime;
    const span = trace.getActiveSpan();
    if (span) { span.recordException(error); span.setStatus({ code: 2, message: error.message }); }
    logger.error('Work request failed', { traceId: req.traceId, error: error.message, duration: duration });
    res.status(500).json({ error: 'Internal server error', traceId: req.traceId });
  }
});

// Control endpoints for injecting issues
app.post('/inject/latency/:ms', (req, res) => {
  latencyAmount = parseInt(req.params.ms);
  injectLatency = true;
  logger.warn('Latency injection enabled', { traceId: req.traceId, latencyMs: latencyAmount });
  res.json({ message: `Latency injection enabled: ${latencyAmount}ms` });
});

app.post('/inject/errors', (req, res) => {
  injectErrors = true;
  logger.warn('Error injection enabled', { traceId: req.traceId });
  res.json({ message: 'Error injection enabled' });
});

app.post('/inject/disable', (req, res) => {
  injectLatency = false;
  injectErrors = false;
  logger.info('All injections disabled', { traceId: req.traceId });
  res.json({ message: 'All injections disabled' });
});

// Simulate some CPU work
async function simulateWork() {
  return new Promise(resolve => {
    const start = Date.now();
    while (Date.now() - start < 50) {
      // Busy wait for 50ms
    }
    resolve();
  });
}

app.listen(port, () => {
  logger.info(`Application started on port ${port}`);
  console.log(`Server running at http://localhost:${port}`);
});
