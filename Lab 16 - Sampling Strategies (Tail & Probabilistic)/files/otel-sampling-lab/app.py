#!/usr/bin/env python3
"""Lab 16 Flask app: SDK-level probabilistic sampling (20%) + attributes for tail-sampling policies."""
import os
import random
import threading
import time

from flask import Flask, jsonify, request
from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.instrumentation.flask import FlaskInstrumentor
from opentelemetry.sdk.resources import Resource
from opentelemetry.sdk.trace import SpanProcessor, TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.sdk.trace.sampling import ParentBased, TraceIdRatioBased
from opentelemetry.trace import Status, StatusCode

SAMPLE_RATIO = 0.20
_lock = threading.Lock()
STATS = {"requests": 0, "sampled_traces": 0}


class SampledTraceCounter(SpanProcessor):
    """Counts root spans that the sampler kept (unsampled spans never reach on_end)."""
    def on_end(self, span):
        if span.parent is None and span.context.trace_flags.sampled:
            with _lock:
                STATS["sampled_traces"] += 1
                n = STATS["sampled_traces"]
            print(f"[sdk] sampled trace #{n}: {span.context.trace_id:032x} {span.name}", flush=True)


provider = TracerProvider(
    resource=Resource.create({"service.name": "sampling-demo", "service.version": "1.0.0"}),
    sampler=ParentBased(TraceIdRatioBased(SAMPLE_RATIO)),
)
provider.add_span_processor(SampledTraceCounter())
provider.add_span_processor(BatchSpanProcessor(
    OTLPSpanExporter(endpoint=os.getenv("OTLP_ENDPOINT", "localhost:4317"), insecure=True, timeout=2)))
trace.set_tracer_provider(provider)
tracer = trace.get_tracer("sampling-demo", "1.0.0")

app = Flask(__name__)
FlaskInstrumentor().instrument_app(app, excluded_urls="stats")


@app.before_request
def _count_request():
    if not request.path.startswith("/stats"):
        with _lock:
            STATS["requests"] += 1


@app.route("/work")
def work():
    """Variable latency 50-3000 ms."""
    span = trace.get_current_span()
    ms = random.randint(50, 3000)
    with tracer.start_as_current_span("simulated_work") as child:
        child.set_attribute("sim.duration_ms", ms)
        time.sleep(ms / 1000)
    span.set_attribute("sim.duration_ms", ms)
    span.set_attribute("outcome", "ok")
    span.set_attribute("latency.class", "slow" if ms > 1500 else "normal")
    return jsonify(route="/work", duration_ms=ms)


@app.route("/fast")
def fast():
    """Always 200, no sleep."""
    span = trace.get_current_span()
    span.set_attribute("sim.duration_ms", 0)
    span.set_attribute("outcome", "ok")
    return jsonify(route="/fast")


@app.route("/flaky")
def flaky():
    """HTTP 500 ~15% of the time."""
    span = trace.get_current_span()
    ms = random.randint(10, 100)
    time.sleep(ms / 1000)
    span.set_attribute("sim.duration_ms", ms)
    if random.random() < 0.15:
        span.set_attribute("outcome", "error")
        span.set_status(Status(StatusCode.ERROR, "simulated failure"))
        return jsonify(route="/flaky", error="simulated failure"), 500
    span.set_attribute("outcome", "ok")
    return jsonify(route="/flaky")


@app.route("/checkout")
def checkout():
    """Business-critical route: ~20% of checkouts carry priority=high (tail policy keep_critical_attribute)."""
    span = trace.get_current_span()
    ms = random.randint(20, 200)
    time.sleep(ms / 1000)
    priority = "high" if random.random() < 0.20 else "normal"
    span.set_attribute("sim.duration_ms", ms)
    span.set_attribute("outcome", "ok")
    span.set_attribute("priority", priority)
    return jsonify(route="/checkout", priority=priority)


@app.route("/stats")
def stats():
    with _lock:
        return jsonify(dict(STATS, sample_ratio=SAMPLE_RATIO))


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, threaded=True)
