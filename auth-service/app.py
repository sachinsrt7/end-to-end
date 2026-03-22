# auth service
from flask import Flask, jsonify
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
import time
import random

app = Flask(__name__)

# metrics
REQUEST_COUNT = Counter(
    'auth_requests_total',
    'Total requests to auth service',
    ['method', 'endpoint', 'status']
)

REQUEST_LATENCY = Histogram(
    'auth_request_duration_seconds',
    'Request latency for auth service',
    ['endpoint'],
    buckets=[0.01, 0.05, 0.1, 0.25, 0.5, 1.0, 2.5, 5.0]
)

@app.route('/health')
def health():
    return jsonify({"status": "healthy", "service": "auth-service"}), 200

@app.route('/auth')
def auth():
    start = time.time()
    # simulate normal processing time 10-50ms
    time.sleep(random.uniform(0.01, 0.05))
    duration = time.time() - start
    REQUEST_COUNT.labels('GET', '/auth', '200').inc()
    REQUEST_LATENCY.labels('/auth').observe(duration)
    return jsonify({"status": "auth ok", "service": "auth-service"}), 200

@app.route('/verify')
def verify():
    start = time.time()
    time.sleep(random.uniform(0.01, 0.05))
    duration = time.time() - start
    REQUEST_COUNT.labels('GET', '/verify', '200').inc()
    REQUEST_LATENCY.labels('/verify').observe(duration)
    return jsonify({"status": "token valid", "service": "auth-service"}), 200

@app.route('/fail')
def fail():
    start = time.time()
    duration = time.time() - start
    REQUEST_COUNT.labels('GET', '/fail', '401').inc()
    REQUEST_LATENCY.labels('/fail').observe(duration)
    return jsonify({"status": "unauthorized", "service": "auth-service"}), 401

@app.route('/slow')
def slow():
    start = time.time()
    # simulate slow auth check 2-5 seconds
    time.sleep(random.uniform(2, 5))
    duration = time.time() - start
    REQUEST_COUNT.labels('GET', '/slow', '200').inc()
    REQUEST_LATENCY.labels('/slow').observe(duration)
    return jsonify({"status": "slow auth ok", "service": "auth-service"}), 200

@app.route('/metrics')
def metrics():
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)