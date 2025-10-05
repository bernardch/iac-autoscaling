from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello from Flask inside Docker!", 200

@app.route("/health")
def health():
    return "Healthy", 200

if __name__ == "__main__":
    # listen on all interfaces (needed for Docker)
    app.run(host="0.0.0.0", port=5000, debug=True)