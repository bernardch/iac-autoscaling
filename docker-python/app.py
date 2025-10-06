from flask import Flask
import math, time

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello from Flask inside Docker!"

@app.route("/health")
def health():
    return "Healthy", 200

@app.route("/burn")
def burn_cpu():
    app.logger.info("Starting burn!")
    x = 0
    start = time.time()
    duration = 5*60
    app.logger.info("burning for " + str(duration) + " seconds!")
    app.logger.info("burning from " + str(start) + " to " + str(start+duration))
    while time.time() - start < duration:
        for i in range(10**6):
            x += math.sqrt(i)
    return f"Done burning cpu! result is {x}"

if __name__ == "__main__":
    # listen on all interfaces (needed for Docker)
    app.run(host="0.0.0.0", port=5000, debug=True)