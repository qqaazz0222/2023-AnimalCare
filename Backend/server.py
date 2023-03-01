import io
import os
from flask import Flask, jsonify, request, render_template
from flask import make_response
from flask_cors import CORS, cross_origin
import pymysql
import json
from operator import itemgetter

# Load Functions
import __user__
import __pet__
# import __yolo__


app = Flask(__name__)
CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'

config_db = json.load(open('db.json', encoding="utf-8"))
db = pymysql.connect(host=config_db["host"], port=config_db["port"], user=config_db["user"],
                     passwd=config_db["password"], db=config_db["db"], charset=config_db["charset"])
cur = db.cursor()


@app.route('/')
# cors error processing
@cross_origin()
# main page loading
def web():
    return render_template('index.html')

# incomimg images processing with YOLOv5, GET methods for test


# @app.route('/test', methods=['GET', 'POST'])
# def predict():
#     if request.method == 'POST':
#         file = request.files['file']
#         save_image(file)
#         train_img = './static/predictimg/' + file.filename
#     else:
#         train_img = './static/predictimg/' + 'test(iphone).jpg'
#     temp = model(train_img)
#     print(temp)
#     if str(temp).split(" ")[4].split("\n")[0] == "good" or str(temp).split(" ")[4].split("\n")[0] == "goods":
#         # result = "<img src='./images/%s'/><h1>좋을 확률이 높음</h1><a href='/'>홈으로</a>" % file.filename
#         result = "좋을 확률이 높음"
#     else:
#         # result = "<img src='./images/%s'/><h1>나쁠 확률이 높음</h1><a href='/'>홈으로</a>" % file.filename
#         result = "나쁠 확률이 높음"
#     return render_template('result.html', img=file.filename, msg=result)


@app.route('/dev', methods=['GET'])
def dev():
    return render_template('dev.html')


@app.route('/user/signin', methods=['POST'])
def userSignIn():
    uid, upw = itemgetter('uid', 'upw')(request.form)
    return __user__.signIn(uid, upw)


@app.route('/user/signup', methods=['POST'])
def userSignUp():
    uid, upw, uname, uemail = itemgetter(
        'uid', 'upw', 'uname', 'uemail')(request.form)
    return __user__.signUp(uid, upw, uname, uemail)


@app.route('/pet/register', methods=['POST'])
def petRegister():
    petName, petSex, petBirthYear, petBirthMonth, petAdoptYear, petAdoptMonth, petWeight, uid = itemgetter(
        'petName', 'petSex', 'petBirthYear', 'petBirthMonth', 'petAdoptYear', 'petAdoptMonth', 'petWeight', 'uid')(request.form)
    return __pet__.register(petName, petSex, petBirthYear, petBirthMonth, petAdoptYear, petAdoptMonth, petWeight, uid)


@app.route('/pet/getlist', methods=['POST'])
def petGetList():
    uid = itemgetter('uid')(request.form)
    return __pet__.getList(uid)


@app.route('/pet/getinfo', methods=['POST'])
def petGetInfo():
    petid = itemgetter('petid')(request.form)
    return __pet__.getInfo(petid)


@app.route('/pet/modify', methods=['POST'])
def petModify():
    petid, petName, petSex, petBirthYear, petBirthMonth, petAdoptYear, petAdoptMonth, petWeight, uid = itemgetter(
        'petid', 'petName', 'petSex', 'petBirthYear', 'petBirthMonth', 'petAdoptYear', 'petAdoptMonth', 'petWeight', 'uid')(request.form)
    return __pet__.modify(petid, petName, petSex, petBirthYear, petBirthMonth, petAdoptYear, petAdoptMonth, petWeight, uid)


@app.route('/pet/uploadimg', methods=['POST'])
def petUploadImg():
    petid = request.form['petid']
    img = request.files['img']
    return __pet__.uploadImg(petid, img)


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=3001, debug=True)
