import requests
from flask import Flask,jsonify
from io import BytesIO
from PIL import Image

app = Flask(__name__)

@app.route('/receive_image', methods=['GET'])
def receive_image():
    image_url = "http://192.168.0.55:8000/static/image/captured_image.jpg"  # 이미지가 전송되는 서버의 URL
    image_path = 'static/Jetbot_image/captured_image.jpg'  # 이미지를 저장할 경로

    # 이미지 다운로드
    response = requests.get(image_url)
    img = Image.open(BytesIO(response.content))
    if response.status_code == 200:
        with open(image_path, 'wb') as f:
            f.write(response.content)
        return jsonify({"msg" : "Image saved successfully"})
    else:
        return jsonify({"msg" : "Failed to receive image"})

if __name__ == '__main__':
    app.run("0.0.0.0",debug=True, port=8000)