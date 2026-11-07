import json
import logging
import time
import random
from datetime import datetime
from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.instrumentation.requests import RequestsInstrumentor

# Configure OpenTelemetry (service.name from OTEL_SERVICE_NAME / OTEL_RESOURCE_ATTRIBUTES)
trace.set_tracer_provider(TracerProvider())
tracer = trace.get_tracer(__name__)

# Export spans via OTLP to the collector (endpoint from OTEL_EXPORTER_OTLP_ENDPOINT).
# The lab's JaegerExporter(agent_host_name="localhost", agent_port=14268) pointed at the app's own
# container and at Jaeger's HTTP collector port, so no span ever arrived.
otlp_exporter = OTLPSpanExporter()

span_processor = BatchSpanProcessor(otlp_exporter)
trace.get_tracer_provider().add_span_processor(span_processor)

# Configure JSON logging
class JSONFormatter(logging.Formatter):
    def format(self, record):
        # Get current span context
        current_span = trace.get_current_span()
        trace_id = None
        span_id = None

        if current_span and current_span.get_span_context().is_valid:
            span_context = current_span.get_span_context()
            trace_id = format(span_context.trace_id, '032x')
            span_id = format(span_context.span_id, '016x')

        log_entry = {
            'timestamp': datetime.utcnow().isoformat() + 'Z',
            'level': record.levelname,
            'message': record.getMessage(),
            'logger': record.name,
            'trace_id': trace_id,
            'span_id': span_id,
            'service': 'sample-app'
        }

        return json.dumps(log_entry)

# Setup logger
logger = logging.getLogger('sample-app')
logger.setLevel(logging.INFO)

# File handler for JSON logs
file_handler = logging.FileHandler('/app/logs/app.log')
file_handler.setFormatter(JSONFormatter())
logger.addHandler(file_handler)

# Console handler for debugging
console_handler = logging.StreamHandler()
console_handler.setFormatter(logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s'))
logger.addHandler(console_handler)

def simulate_user_request():
    """Simulate a user request with tracing and logging"""
    with tracer.start_as_current_span("user_request") as span:
        user_id = random.randint(1000, 9999)
        span.set_attribute("user.id", user_id)

        logger.info(f"Processing request for user {user_id}")

        # Simulate some processing time
        processing_time = random.uniform(0.1, 0.5)
        time.sleep(processing_time)

        with tracer.start_as_current_span("database_query") as db_span:
            db_span.set_attribute("db.operation", "SELECT")
            db_span.set_attribute("db.table", "users")

            logger.info(f"Querying database for user {user_id}")
            time.sleep(random.uniform(0.05, 0.2))

            if random.random() > 0.8:  # 20% chance of error
                logger.error(f"Database query failed for user {user_id}")
                span.set_attribute("error", True)
                return False

        with tracer.start_as_current_span("response_generation") as resp_span:
            resp_span.set_attribute("response.type", "json")
            logger.info(f"Generating response for user {user_id}")
            time.sleep(random.uniform(0.02, 0.1))

        logger.info(f"Request completed successfully for user {user_id}")
        return True

def main():
    logger.info("Application starting up")

    try:
        for i in range(50):  # Generate 50 requests
            success = simulate_user_request()
            if success:
                logger.info(f"Request {i+1} completed successfully")
            else:
                logger.warning(f"Request {i+1} failed")

            # Wait between requests
            time.sleep(random.uniform(1, 3))

    except KeyboardInterrupt:
        logger.info("Application shutting down")
    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}")

if __name__ == "__main__":
    main()
