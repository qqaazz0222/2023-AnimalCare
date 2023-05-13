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


def getList(petid, limit=0):
    try:
        if limit > 0:
            sql = """SELECT `logid`, `logyear`, `logmonth`, `logday`, TO_BASE64(logimg), `logresult`, `petid` 
            FROM log WHERE petid = %s ORDER BY `logid` DESC LIMIT %s""" % (petid, limit)
            server.cur.execute(sql)
            result = server.cur.fetchall()
            try: 
                print("Get limited list:", result[0][:4]+result[:][5:])
            except:
                print("No records limited list")
            return jsonify(result)
        else:
            sql = """SELECT `logid`, `logyear`, `logmonth`, `logday`, TO_BASE64(logimg), `logresult`, `petid` 
            FROM log WHERE petid = '%s' ORDER BY `logid`""" % (petid)
            server.cur.execute(sql)
            result = server.cur.fetchall()
            try:
                print("Get whole list:", result[:][:4]+result[:][5:])
            except:
                print("No records whole list")
            return jsonify(result)
    except pymysql.err.IntegrityError as e:
        code, msg = e.args
        resMsg["code"] = code
        resMsg["msg"] = msg
        return resMsg


def getInfo(petid, year, month, day):
    try:
        sql = """SELECT `logid`, `logyear`, `logmonth`, `logday`, TO_BASE64(logimg), `logresult`, `petid` FROM log 
        WHERE petid = '%s' and logyear = %s and logmonth = %s and logday = %s""" % (petid, year, month, day)
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
        # print(pResult)
        # convert bytes image into base64 image to put into database
        img_base64 = base64.b64encode(img).decode('utf-8')

        sql = """INSERT INTO log VALUES (null, %s, %s, %s, %s, %s, %s)"""
        server.cur.execute(sql, (year, month, day, img, pResult, petid))
        server.db.commit()
        resMsg["code"] = 0
        resMsg["msg"] = "Success!"
        resMsg["year"] = year
        resMsg["month"] = month
        resMsg["day"] = day
        resMsg["img"] = img_base64
        resMsg["predictResult"] = pResult
        return jsonify(resMsg)
    except pymysql.err.IntegrityError as e:
        code, msg = e.args
        resMsg["code"] = code
        resMsg["msg"] = msg
        return resMsg
