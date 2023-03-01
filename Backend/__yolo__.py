import torch
from torchvision import models
import torchvision.transforms as transforms
import cv2
from pickletools import read_uint1
from PIL import Image
import json

# Load YOLO Model
model = torch.hub.load('./yolov5/', 'custom',
                       path='./yolov5/runs/train/weights/best.pt', source='local')


def saveImage(file):
    file.save('./static/predictimg/' + file.filename)


def predict(imgPath):
    temp = model(imgPath)
    if str(temp).split(" ")[4].split("\n")[0] == "good" or str(temp).split(" ")[4].split("\n")[0] == "goods":
        return "g"
    else:
        return "b"
