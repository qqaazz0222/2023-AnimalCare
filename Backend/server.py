import io
import os
from flask import Flask, jsonify, request, render_template
from flask import make_response
from flask_cors import CORS, cross_origin
import pymysql
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

db = pymysql.connect(host="svc.gksl2.cloudtype.app", port=31535, user="root",
                     passwd="4uvg2mlenu33f1", db="main", charset="utf8")
cur = db.cursor()

# load YOLO model
model = torch.hub.load('./yolov5/', 'custom',
                       path='./yolov5/runs/train/weights/best.pt', source='local')


# storing incoming images into POST communication
# all incoming images store in "./images"
def save_image(file):
    file.save('./static/img/' + file.filename)


@app.route('/')
# cors error processing
@cross_origin()
# main page loading
def web():
    return render_template('index.html')

# incomimg images processing with YOLOv5, GET methods for test


@app.route('/test', methods=['GET', 'POST'])
def predict():
    # save incoming images and load images
    if request.method == 'POST':
        file = request.files['file']
        save_image(file)
        train_img = './static/img/' + file.filename
    # for dev & test, it will be remove...
    else:
        train_img = './static/img/' + 'test(iphone).jpg'
    temp = model(train_img)
    print(temp)
    if str(temp).split(" ")[4].split("\n")[0] == "good" or str(temp).split(" ")[4].split("\n")[0] == "goods":
        # result = "<img src='./images/%s'/><h1>좋을 확률이 높음</h1><a href='/'>홈으로</a>" % file.filename
        result = "좋을 확률이 높음"
    else:
        # result = "<img src='./images/%s'/><h1>나쁠 확률이 높음</h1><a href='/'>홈으로</a>" % file.filename
        result = "나쁠 확률이 높음"
    return render_template('result.html', img=file.filename, msg=result)


@app.route('/dev', methods=['GET'])
def dev():
    return render_template('dev.html')


@app.route('/user/signin', methods=['POST'])
def signin():
    resMsg = {
        "code": -9999,
        "msg": "empty",
    }
    try:
        uid = request.form['uid']
        upw = request.form['upw']
        if uid == "":
            resMsg["code"] = 1
            resMsg["msg"] = "You did not enter an ID."
            return resMsg
        if upw == "":
            resMsg["code"] = 2
            resMsg["msg"] = "You did not enter an PW."
            return resMsg
        sql = "SELECT upw FROM user WHERE uid = '%s'" % (
            uid)
        cur.execute(sql)
        db.commit()
        result = cur.fetchone()
        if type(result) == type(None):
            resMsg["code"] = 3
            resMsg["msg"] = "This ID does not exist."
            return resMsg
        elif result[0] != upw:
            resMsg["code"] = 4
            resMsg["msg"] = "Invalid password."
            return resMsg
        else:
            resMsg["code"] = 0
            resMsg["msg"] = "Success"
            return resMsg
    except pymysql.err.IntegrityError as e:
        code, msg = e.args
        resMsg["code"] = code
        resMsg["msg"] = msg
        return resMsg


@app.route('/user/signup', methods=['POST'])
def signup():
    resMsg = {
        "code": -9999,
        "msg": "empty",
    }
    try:
        uid = request.form['uid']
        upw = request.form['upw']
        uname = request.form['uname']
        uemail = request.form['uemail']
        if uid == "":
            resMsg["code"] = 1
            resMsg["msg"] = "You did not enter an ID."
            return resMsg
        if upw == "":
            resMsg["code"] = 2
            resMsg["msg"] = "You did not enter an PW."
            return resMsg
        if uname == "":
            resMsg["code"] = 3
            resMsg["msg"] = "You did not enter an Name."
            return resMsg
        if uemail == "":
            resMsg["code"] = 4
            resMsg["msg"] = "You did not enter an Email."
            return resMsg
        sql = "INSERT INTO user VALUES('%s', '%s', '%s', '%s')" % (
            uid, upw, uname, uemail)
        cur.execute(sql)
        db.commit()
        result = cur.fetchone()
        resMsg["code"] = 0
        resMsg["msg"] = "Success!"
        return resMsg
    except pymysql.err.IntegrityError as e:
        code, msg = e.args
        if code == 1062:
            resMsg["code"] = 5
            resMsg["msg"] = "The ID is already in use."
        else:
            resMsg["code"] = code
            resMsg["msg"] = msg
        return resMsg


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=3001, debug=True)
