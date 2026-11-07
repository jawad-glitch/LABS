import logging
import time
import random
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import ConsoleSpanExporter, BatchSpanProcessor
from opentelemetry.instrumentation.logging import LoggingInstrumentor

# Set up OpenTelemetry tracing
trace.set_tracer_provider(TracerProvider())
tracer = trace.get_tracer(__name__)

# Configure span exporter
span_exporter = ConsoleSpanExporter()
span_processor = BatchSpanProcessor(span_exporter)
trace.get_tracer_provider().add_span_processor(span_processor)

# Instrument logging to include trace context
LoggingInstrumentor().instrument(set_logging_format=True)

# Configure logging with custom format (force=True so DEBUG level + format take effect)
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - [trace_id=%(otelTraceID)s span_id=%(otelSpanID)s] - %(message)s',
    force=True
)
logger = logging.getLogger(__name__)

def simulate_web_request(request_id, endpoint):
    """Simulate a web request with multiple service calls"""
    with tracer.start_as_current_span("web_request") as span:
        span.set_attribute("http.method", "POST")
        span.set_attribute("http.url", f"/api/{endpoint}")
        span.set_attribute("request.id", request_id)

        logger.info(f"Received {endpoint} request {request_id}")

        # Simulate authentication
        auth_result = authenticate_user(request_id)

        if auth_result:
            # Simulate business logic
            process_business_logic(request_id, endpoint)

            # Simulate database operations
            db_result = perform_database_operations(request_id)

            if db_result:
                logger.info(f"Request {request_id} completed successfully")
                span.set_attribute("request.status", "success")
            else:
                logger.error(f"Request {request_id} failed at database level")
                span.set_attribute("request.status", "db_error")
        else:
            logger.warning(f"Request {request_id} failed authentication")
            span.set_attribute("request.status", "auth_failed")

def authenticate_user(request_id):
    """Simulate user authentication"""
    with tracer.start_as_current_span("authenticate_user") as span:
        span.set_attribute("request.id", request_id)

        logger.debug(f"Starting authentication for request {request_id}")

        # Simulate auth processing time
        time.sleep(random.uniform(0.01, 0.05))

        # Simulate random auth success/failure
        success = random.choice([True, True, True, False])  # 75% success rate

        if success:
            logger.info(f"Authentication successful for request {request_id}")
            span.set_attribute("auth.status", "success")
        else:
            logger.warning(f"Authentication failed for request {request_id}")
            span.set_attribute("auth.status", "failed")

        return success

def process_business_logic(request_id, endpoint):
    """Simulate business logic processing"""
    with tracer.start_as_current_span("business_logic") as span:
        span.set_attribute("request.id", request_id)
        span.set_attribute("endpoint", endpoint)

        logger.info(f"Processing business logic for {endpoint} request {request_id}")

        # Simulate different processing based on endpoint
        if endpoint == "orders":
            process_order_logic(request_id)
        elif endpoint == "users":
            process_user_logic(request_id)
        else:
            logger.info(f"Generic processing for {endpoint}")

        time.sleep(random.uniform(0.02, 0.08))
        logger.debug(f"Business logic completed for request {request_id}")

def process_order_logic(request_id):
    """Simulate order-specific processing"""
    with tracer.start_as_current_span("process_order") as span:
        span.set_attribute("request.id", request_id)

        logger.info(f"Processing order for request {request_id}")

        # Simulate inventory check
        inventory_available = random.choice([True, True, False])  # 66% available

        if inventory_available:
            logger.info(f"Inventory check passed for request {request_id}")
            span.set_attribute("inventory.status", "available")
        else:
            logger.warning(f"Inventory check failed for request {request_id}")
            span.set_attribute("inventory.status", "unavailable")

def process_user_logic(request_id):
    """Simulate user-specific processing"""
    with tracer.start_as_current_span("process_user") as span:
        span.set_attribute("request.id", request_id)

        logger.info(f"Processing user data for request {request_id}")

        # Simulate profile validation
        profile_valid = random.choice([True, True, True, False])  # 75% valid

        if profile_valid:
            logger.info(f"User profile validation passed for request {request_id}")
            span.set_attribute("profile.status", "valid")
        else:
            logger.error(f"User profile validation failed for request {request_id}")
            span.set_attribute("profile.status", "invalid")

def perform_database_operations(request_id):
    """Simulate database operations"""
    with tracer.start_as_current_span("database_operations") as span:
        span.set_attribute("request.id", request_id)
        span.set_attribute("db.operation", "read_write")

        logger.debug(f"Starting database operations for request {request_id}")

        # Simulate database read
        read_success = database_read(request_id)

        if read_success:
            # Simulate database write
            write_success = database_write(request_id)
            return write_success

        return False

def database_read(request_id):
    """Simulate database read operation"""
    with tracer.start_as_current_span("db_read") as span:
        span.set_attribute("request.id", request_id)
        span.set_attribute("db.operation.type", "SELECT")

        logger.debug(f"Reading from database for request {request_id}")
        time.sleep(random.uniform(0.01, 0.03))

        success = random.choice([True, True, True, True, False])  # 80% success

        if success:
            logger.debug(f"Database read successful for request {request_id}")
            span.set_attribute("db.read.status", "success")
        else:
            logger.error(f"Database read failed for request {request_id}")
            span.set_attribute("db.read.status", "failed")

        return success

def database_write(request_id):
    """Simulate database write operation"""
    with tracer.start_as_current_span("db_write") as span:
        span.set_attribute("request.id", request_id)
        span.set_attribute("db.operation.type", "INSERT")

        logger.debug(f"Writing to database for request {request_id}")
        time.sleep(random.uniform(0.02, 0.05))

        success = random.choice([True, True, True, False])  # 75% success

        if success:
            logger.info(f"Database write successful for request {request_id}")
            span.set_attribute("db.write.status", "success")
        else:
            logger.error(f"Database write failed for request {request_id}")
            span.set_attribute("db.write.status", "failed")

        return success

def main():
    print("=== Enhanced Correlated Logging Demo ===")
    logger.info("Starting enhanced logging demonstration")

    # Simulate different types of requests
    requests = [
        (1001, "orders"),
        (1002, "users"),
        (1003, "orders"),
        (1004, "products"),
        (1005, "users")
    ]

    for request_id, endpoint in requests:
        logger.info(f"--- Processing new request {request_id} for {endpoint} ---")
        simulate_web_request(request_id, endpoint)
        time.sleep(0.1)  # Small delay between requests

    logger.info("Enhanced logging demonstration completed")
    print("\n=== Demo Analysis ===")
    print("1. Each request created a separate trace with a unique trace_id")
    print("2. Within each trace, multiple spans were created for different operations")
    print("3. All log entries within a trace share the same trace_id")
    print("4. Each span has its own span_id, but logs within that span share the span_id")
    print("5. This correlation helps in debugging distributed systems")

if __name__ == "__main__":
    main()
