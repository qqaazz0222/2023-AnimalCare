from flask import Flask, render_template
from flask_socketio import SocketIO, emit

app = Flask(__name__)
socketio = SocketIO(app)

@app.route('/websocket')
def index():
    return render_template('index.html')

@socketio.on('connect')
def handle_connect():
    print('Client connected')

@socketio.on('disconnect')
def handle_disconnect():
    print('Client disconnected')

@socketio.on('response')
def handle_response(response_data):
    # Process the response data received from the websocket server
    message = response_data.get('message')
    print('Response:', message)

def start():
    socketio.run(app, host='0.0.0.0', port='3002')