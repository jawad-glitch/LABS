import re
import sys
from collections import defaultdict

def analyze_log_correlation(log_content):
    """Analyze log correlation by extracting trace and span IDs"""

    # Pattern to extract trace_id, span_id, and log message
    pattern = r'trace_id=([a-f0-9]+)\s+span_id=([a-f0-9]+)\]\s+-\s+(.+)'

    traces = defaultdict(list)
    spans = defaultdict(list)
    outside = 0

    for line in log_content.split('\n'):
        match = re.search(pattern, line)
        if match:
            trace_id, span_id, message = match.groups()
            if set(trace_id) == {"0"}:      # logged outside any span
                outside += 1
                continue
            traces[trace_id].append({'span_id': span_id, 'message': message, 'full_line': line})
            spans[span_id].append({'trace_id': trace_id, 'message': message, 'full_line': line})

    print("=== LOG CORRELATION ANALYSIS ===\n")
    print(f"Total unique traces found: {len(traces)}")
    print(f"Total unique spans found: {len(spans)}")
    print(f"Log lines outside any span (trace_id=0): {outside}\n")

    for trace_id, logs in traces.items():
        print(f"TRACE ID: {trace_id}")
        print(f"  Number of log entries: {len(logs)}")
        unique_spans = set(log['span_id'] for log in logs)
        print(f"  Unique spans in this trace: {len(unique_spans)}")
        for log in logs:
            print(f"    [{log['span_id'][:8]}...] {log['message']}")
        print()

if __name__ == "__main__":
    if len(sys.argv) > 1:
        analyze_log_correlation(open(sys.argv[1]).read())
    else:
        print("Usage: python analyze_logs.py <captured-output-file>")
        print("This script helps you understand the correlation between logs and traces.")
