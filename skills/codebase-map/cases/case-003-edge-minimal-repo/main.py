from flask import Flask, request, jsonify
import json

app = Flask(__name__)

users = {}
next_id = 1


@app.route("/health")
def health():
    return jsonify({"status": "ok"})


@app.route("/users", methods=["GET"])
def get_users():
    return jsonify(list(users.values()))


@app.route("/users", methods=["POST"])
def create_user():
    global next_id
    data = request.get_json()
    if not data or "name" not in data:
        return jsonify({"error": "name required"}), 400
    user = {"id": next_id, "name": data["name"]}
    users[next_id] = user
    next_id += 1
    return jsonify(user), 201


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
