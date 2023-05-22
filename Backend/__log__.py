import io
import os
from flask import Flask, jsonify, request, render_template
from flask import make_response
import pymysql
import json
import server
from datetime import datetime
import __yolo__

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
        path = './static/checkimg/%s_%d_%d_%d.%s' % (
            petid, year, month, day, img.mimetype.split('/')[1])
        img.save(path)
        pResult = __yolo__.predict(path)
        sql = "INSERT INTO log VALUES(null, %d, %d, %d, '%s', '%s', %s)" % (
            year, month, day, path, pResult, petid)
        server.cur.execute(sql)
        server.db.commit()
        resMsg["code"] = 0
        resMsg["msg"] = "Success!"
        resMsg["date"] = '%d/%d/%d' % (year, month, day)
        resMsg["img"] = path
        resMsg["predictResult"] = pResult
        return jsonify(resMsg)
    except pymysql.err.IntegrityError as e:
        code, msg = e.args
        resMsg["code"] = code
        resMsg["msg"] = msg
        return resMsg
