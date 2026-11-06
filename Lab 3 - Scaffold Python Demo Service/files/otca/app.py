from flask import Flask, jsonify
import time
import random

# Create Flask application instance
app = Flask(__name__)

@app.route('/')
def home():
    """
    Home endpoint that returns a welcome message
    """
    return jsonify({
        "message": "Welcome to the OTCA Demo Service",
        "status": "running",
        "endpoints": ["/", "/work"]
    })

@app.route('/work')
def work():
    """
    Work endpoint that simulates some processing work
    """
    # Simulate some work by adding a random delay
    work_duration = random.uniform(0.1, 0.5)
    time.sleep(work_duration)

    return jsonify({
        "message": "Work completed successfully",
        "work_duration_seconds": round(work_duration, 2),
        "status": "completed"
    })

if __name__ == '__main__':
    # This allows running the app directly with python app.py for development
    app.run(debug=True, host='0.0.0.0', port=8000)
