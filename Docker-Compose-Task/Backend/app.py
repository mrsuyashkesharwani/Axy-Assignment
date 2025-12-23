from flask import Flask, jsonify
import psycopg2
import os

app = Flask(__name__)

def get_db_connection():
    return psycopg2.connect(
        host=os.environ["DB_HOST"],
        port=os.environ.get("DB_PORT", 5432),
        database=os.environ["DB_NAME"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"]
    )

@app.route("/api/health")
def health():
    try:
        conn = get_db_connection()
        conn.close()
        return jsonify(status="UP", database="connected")
    except Exception as e:
        return jsonify(status="DOWN", error=str(e)), 500

@app.route("/api/message")
def message():
    return jsonify(message="Hello World from Backend API")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
