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
import __log__
# import __yolo__


app = Flask(__name__)
CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'

config_db = json.load(open('db.json', encoding="utf-8"))
db = pymysql.connect(host=config_db["host"], port=config_db["port"], user=config_db["user"],
                     passwd=config_db["password"], db=config_db["db"], charset=config_db["charset"])
cur = db.cursor()


@app.route('/')
@cross_origin()
def web():
    return render_template('index.html')

# -----------------------------------------------------------------
#                         User Fuctions
# -----------------------------------------------------------------


@app.route('/user/signin', methods=['POST'])
@cross_origin()
def userSignIn():
    uid, upw = itemgetter('uid', 'upw')(request.json)
    return __user__.signIn(uid, upw)


@app.route('/user/signup', methods=['POST'])
@cross_origin()
def userSignUp():
    uid, upw, uname, uemail = itemgetter(
        'uid', 'upw', 'uname', 'uemail')(request.json)
    return __user__.signUp(uid, upw, uname, uemail)


@app.route('/user/getinfo', methods=['POST'])
@cross_origin()
def userGetInfo():
    uid = itemgetter('uid')(request.json)
    return __user__.getInfo(uid)


@app.route('/user/modify', methods=['POST'])
@cross_origin()
def userModify():
    uid, upw, uname, uemail = itemgetter(
        'uid', 'upw', 'uname', 'uemail')(request.json)
    return __user__.modify(uid, upw, uname, uemail)


@app.route('/user/uploadimg', methods=['POST'])
@cross_origin()
def userUploadImg():
    uid = request.form['uid']
    img = request.files['img']
    return __user__.uploadImg(uid, img)

# -----------------------------------------------------------------
#                         Pet Fuctions
# -----------------------------------------------------------------


@app.route('/pet/register', methods=['POST'])
@cross_origin()
def petRegister():
    petName, petSex, petBirthYear, petBirthMonth, petAdoptYear, petAdoptMonth, petWeight, uid = itemgetter(
        'petName', 'petSex', 'petBirthYear', 'petBirthMonth', 'petAdoptYear', 'petAdoptMonth', 'petWeight', 'uid')(request.json)
    return __pet__.register(petName, petSex, petBirthYear, petBirthMonth, petAdoptYear, petAdoptMonth, petWeight, uid)


@app.route('/pet/getlist', methods=['POST'])
@cross_origin()
def petGetList():
    uid = itemgetter('uid')(request.json)
    return __pet__.getList(uid)

@app.route('/pet/getlist/countpets', methods=['POST'])
@cross_origin()
def petGetListCountPets():
    uid = itemgetter('uid')(request.json)
    return __pet__.getListCountPets(uid)


@app.route('/pet/getinfo', methods=['POST'])
@cross_origin()
def petGetInfo():
    petid = itemgetter('petid')(request.form)
    return __pet__.getInfo(petid)


@app.route('/pet/modify', methods=['POST'])
@cross_origin()
def petModify():
    petid, petName, petSex, petBirthYear, petBirthMonth, petAdoptYear, petAdoptMonth, petWeight, uid = itemgetter(
        'petid', 'petName', 'petSex', 'petBirthYear', 'petBirthMonth', 'petAdoptYear', 'petAdoptMonth', 'petWeight', 'uid')(request.json)
    return __pet__.modify(petid, petName, petSex, petBirthYear, petBirthMonth, petAdoptYear, petAdoptMonth, petWeight, uid)


@app.route('/pet/delinfo', methods=['POST'])
@cross_origin()
def petDelInfo():
    petid = itemgetter('petid')(request.json)
    return __pet__.delinfo(petid)


@app.route('/pet/delall', methods=['POST'])
@cross_origin()
def deleteAllPets():
    uid = itemgetter('uid')(request.form)
    return __pet__.deleteAllPets(uid)


@app.route('/pet/uploadimg', methods=['POST'])
@cross_origin()
def petUploadImg():
    print("I'm Here")
    petid = request.json['petid']
    img = request.files['img']
    print(img)
    return __pet__.uploadImg(petid, img)

# -----------------------------------------------------------------
#                         Log Fuctions
# -----------------------------------------------------------------


@app.route('/log/getlist', methods=['POST'])
@cross_origin()
def logGetList():
    petid = itemgetter('petid')(request.json)
    return __log__.getList(petid)


@app.route('/log/getinfo', methods=['POST'])
@cross_origin()
def logGetInfo():
    petid, year, month, day = itemgetter(
        'petid', 'year', 'month', 'day')(request.json)
    return __log__.getInfo(petid, year, month, day)


@app.route('/log/healthcheck', methods=['POST'])
@cross_origin()
def logHealthCheck():
    petid = request.json['petid']
    img = request.files['img']
    return __log__.healthCheck(petid, img)


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=3001, debug=True)
