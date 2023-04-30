import io
from flask import Flask, jsonify, request, render_template
from flask import make_response
import pymysql
import server
from datetime import datetime
import __yolo__
from PIL import Image
import base64

resMsg = {
    "code": -9999,
    "msg": "empty",
}


def getList(petid):
    try:
        sql = "SELECT * FROM log WHERE petid = '%s'" % (petid)
        server.cur.execute(sql)
        result = server.cur.fetchall()
        return jsonify(result)
    except pymysql.err.IntegrityError as e:
        code, msg = e.args
        resMsg["code"] = code
        resMsg["msg"] = msg
        return resMsg


def getInfo(petid, year, month, day):
    try:
        sql = "SELECT * FROM log WHERE petid = '%s' and logyear = %s and logmonth = %s and logday = %s" % (
            petid, year, month, day)
        server.cur.execute(sql)
        result = server.cur.fetchone()
        return jsonify(result)
    except pymysql.err.IntegrityError as e:
        code, msg = e.args
        resMsg["code"] = code
        resMsg["msg"] = msg
        return resMsg


def healthCheck(petid, img):
    try:
        t = datetime.today()
        year, month, day = t.year, t.month, t.day

        # Open bytes image and save to the path for prediction
        my_img = Image.open(io.BytesIO(img))
        path = './static/checkimg/%s_%d_%d_%d.png' % (
            petid, year, month, day)
        my_img.save(path)
        # make a prediction of feces image
        pResult = __yolo__.predict(path)
        # convert bytes image into base64 image to put into database
        img_base64 = base64.b64encode(img).decode('utf-8')

        sql = """INSERT INTO log VALUES (null, %s, %s, %s, %s, %s, %s)"""
        server.cur.execute(sql, (year, month, day, img, pResult, petid))
        server.db.commit()
        resMsg["code"] = 0
        resMsg["msg"] = "Success!"
        resMsg["date"] = '%d/%d/%d' % (year, month, day)
        resMsg["img"] = img_base64
        resMsg["predictResult"] = pResult
        return jsonify(resMsg)
    except pymysql.err.IntegrityError as e:
        code, msg = e.args
        resMsg["code"] = code
        resMsg["msg"] = msg
        return resMsg
