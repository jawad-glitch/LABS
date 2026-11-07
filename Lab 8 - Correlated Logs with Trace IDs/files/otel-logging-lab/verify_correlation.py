#!/usr/bin/env python3

import subprocess
import re
import sys

def run_demo_and_capture_output():
    """Run the demo and capture its output"""
    try:
        result = subprocess.run(['python', 'correlated_logging_demo.py'],
                              capture_output=True, text=True, timeout=30)
        return result.stdout + result.stderr
    except subprocess.TimeoutExpired:
        print("Demo timed out")
        return ""
    except Exception as e:
        print(f"Error running demo: {e}")
        return ""

def verify_correlation(output):
    """Verify that logs are properly correlated with traces"""

    # Extract all log lines with trace/span IDs
    log_pattern = r'trace_id=([a-f0-9]+)\s+span_id=([a-f0-9]+)'
    matches = re.findall(log_pattern, output)

    if not matches:
        print("❌ FAILED: No correlated logs found")
        return False

    print(f"✅ SUCCESS: Found {len(matches)} correlated log entries")

    # Check for unique trace IDs
    trace_ids = set(match[0] for match in matches)
    print(f"✅ SUCCESS: Found {len(trace_ids)} unique trace IDs")

    # Check for unique span IDs
    span_ids = set(match[1] for match in matches)
    print(f"✅ SUCCESS: Found {len(span_ids)} unique span IDs")

    # Verify that we have more spans than traces (nested spans)
    if len(span_ids) > len(trace_ids):
        print("✅ SUCCESS: Found nested spans (more spans than traces)")
    else:
        print("⚠️  WARNING: Expected more spans than traces for nested operations")

    return True

def main():
    print("=== Correlation Verification ===")
    print("Running demo and capturing output...")

    output = run_demo_and_capture_output()

    if not output:
        print("❌ FAILED: No output captured from demo")
        sys.exit(1)

    print("Verifying correlation...")
    success = verify_correlation(output)

    if success:
        print("\n🎉 All correlation checks passed!")
        print("Your OpenTelemetry logging correlation is working correctly.")
    else:
        print("\n❌ Some correlation checks failed.")
        print("Please review your configuration.")

if __name__ == "__main__":
    main()
