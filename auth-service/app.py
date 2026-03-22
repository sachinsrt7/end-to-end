# auth service app
from flask import Flask, jsonify
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
import time

app = Flask(__name__)

REQUEST_COUNT = Counter(
    'http_requests_total',
    'Total HTTP requests',
    ['method', 'endpoint', 'status']
)
REQUEST_LATENCY = Histogram(
    'http_request_duration_seconds',
    'HTTP request latency',
    ['endpoint']
)

@app.route('/health')
def health():
    REQUEST_COUNT.labels('GET', '/health', '200').inc()
    return jsonify({"status": "healthy", "service": "auth-service"}), 200

@app.route('/auth')
def auth():
    start = time.time()
    REQUEST_COUNT.labels('GET', '/auth', '200').inc()
    REQUEST_LATENCY.labels('/auth').observe(time.time() - start)
    return jsonify({"status": "auth ok", "service": "auth-service"}), 200

@app.route('/verify')
def verify():
    start = time.time()
    REQUEST_COUNT.labels('GET', '/verify', '200').inc()
    REQUEST_LATENCY.labels('/verify').observe(time.time() - start)
    return jsonify({"status": "auth ok", "service": "auth-service"}), 200

@app.route('/metrics')
def metrics():
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)