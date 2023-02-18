import io
import os
from flask import Flask, jsonify, request
from flask import make_response
from flask_cors import CORS, cross_origin
import json
from pickletools import read_uint1
import torch
from torchvision import models
import torchvision.transforms as transforms
from PIL import Image
import cv2

app = Flask(__name__)
CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'

# load YOLO model
model = torch.hub.load('./yolov5/', 'custom', path='./yolov5/runs/train/weights/best.pt', source='local')

# storing incoming images into POST communication
def save_image(file):
    file.save('./temp/'+ file.filename)

# storing server logs
# def create_log()

@app.route('/')
# cors error processing
@cross_origin()
def web():
    html = '''
        <h1>Animal Care Yolo API Server</h1>
    '''
    return html

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=3001, debug=True)
