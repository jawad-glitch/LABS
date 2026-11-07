import logging
import time
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

# Configure logging with custom format
# force=True: the instrumentor already called basicConfig(); without force this call would be ignored
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - [trace_id=%(otelTraceID)s span_id=%(otelSpanID)s] - %(message)s',
    force=True
)
logger = logging.getLogger(__name__)

def process_user_request(user_id):
    """Simulate processing a user request with logging"""
    with tracer.start_as_current_span("process_user_request") as span:
        span.set_attribute("user.id", user_id)
        logger.info(f"Starting to process request for user {user_id}")

        # Simulate some processing time
        time.sleep(0.1)

        # Call another function that creates a child span
        validate_user_data(user_id)

        # More processing
        save_user_data(user_id)

        logger.info(f"Completed processing request for user {user_id}")

def validate_user_data(user_id):
    """Validate user data with its own span and logs"""
    with tracer.start_as_current_span("validate_user_data") as span:
        span.set_attribute("user.id", user_id)
        logger.info(f"Validating data for user {user_id}")

        # Simulate validation logic
        time.sleep(0.05)

        if user_id % 2 == 0:
            logger.warning(f"User {user_id} has incomplete profile data")
        else:
            logger.info(f"User {user_id} data validation successful")

def save_user_data(user_id):
    """Save user data with its own span and logs"""
    with tracer.start_as_current_span("save_user_data") as span:
        span.set_attribute("user.id", user_id)
        span.set_attribute("operation", "database_save")

        logger.info(f"Saving data for user {user_id} to database")

        # Simulate database operation
        time.sleep(0.08)

        try:
            # Simulate potential error for demonstration
            if user_id == 999:
                raise Exception("Database connection failed")

            logger.info(f"Successfully saved data for user {user_id}")
            span.set_attribute("save.status", "success")

        except Exception as e:
            logger.error(f"Failed to save data for user {user_id}: {str(e)}")
            span.set_attribute("save.status", "failed")
            span.record_exception(e)

def main():
    print("Starting Correlated Logging Demo")
    logger.info("Application started - beginning user processing")

    # Process multiple users to demonstrate correlation
    user_ids = [101, 102, 103, 999, 105]

    for user_id in user_ids:
        try:
            process_user_request(user_id)
        except Exception as e:
            logger.error(f"Unhandled error processing user {user_id}: {str(e)}")

    logger.info("Application completed - all users processed")
    print("Demo completed. Check the output above for correlated logs and traces.")

if __name__ == "__main__":
    main()
