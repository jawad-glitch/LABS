from flask import Flask, jsonify
import requests
import time
import random

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({
        "message": "Welcome to OpenTelemetry Auto-Instrumentation Lab",
        "status": "running"
    })

@app.route('/api/data')
def get_data():
    # Simulate some processing time
    time.sleep(random.uniform(0.1, 0.5))

    return jsonify({
        "data": [1, 2, 3, 4, 5],
        "timestamp": time.time(),
        "processed": True
    })

@app.route('/api/external')
def call_external():
    try:
        # Make an external HTTP request (this will be auto-instrumented)
        response = requests.get('https://httpbin.org/json', timeout=5)
        return jsonify({
            "external_data": response.json(),
            "status_code": response.status_code
        })
    except Exception as e:
        return jsonify({
            "error": str(e),
            "status": "failed"
        }), 500

@app.route('/health')
def health_check():
    return jsonify({"status": "healthy"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)
