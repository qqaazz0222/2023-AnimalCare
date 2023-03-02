from flask import Flask, jsonify, request, render_template
from flask import make_response
import pymysql
import json
import server

resMsg = {
    "code": -9999,
    "msg": "empty",
}


def signIn(uid, upw):
    try:
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
        server.cur.execute(sql)
        server.db.commit()
        result = server.cur.fetchone()
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


def signUp(uid, upw, uname, uemail):
    try:

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
        sql = "INSERT INTO user VALUES('%s', '%s', '%s', '%s', null)" % (
            uid, upw, uname, uemail)
        server.cur.execute(sql)
        server.db.commit()
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


def getInfo(uid):
    try:
        # -----------------------------------------------------------------
        #              Not Include User PW Data(recommended)
        # -----------------------------------------------------------------
        sql = "SELECT uid, uname, uemail, uimg FROM user WHERE uid = '%s'" % (
            uid)
        server.cur.execute(sql)
        result = server.cur.fetchone()
        resMsg["code"] = 0
        resMsg["msg"] = "Success!"
        resMsg["uid"] = result[0]
        resMsg["uname"] = result[1]
        resMsg["uemail"] = result[2]
        resMsg["uimg"] = result[3]
        # -----------------------------------------------------------------
        #                        Include User PW Data
        # -----------------------------------------------------------------
        # sql = "SELECT * FROM user WHERE uid = '%s'" % (
        #     uid)
        # server.cur.execute(sql)
        # result = server.cur.fetchone()
        # resMsg["code"] = 0
        # resMsg["msg"] = "Success!"
        # resMsg["uid"] = result[0]
        # resMsg["upw"] = result[1]
        # resMsg["uname"] = result[2]
        # resMsg["uemail"] = result[3]
        # resMsg["uimg"] = result[4]
        # -----------------------------------------------------------------
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


def modify(uid, upw, uname, uemail):
    try:
        sql = "SELECT upw, uname, uemail FROM user WHERE uid = '%s'" % (uid)
        server.cur.execute(sql)
        result = server.cur.fetchone()
        if not upw:
            upw = result[0]
        if not uname:
            uname = result[1]
        if not uemail:
            uemail = result[2]
        sql = "UPDATE user SET upw = '%s', uname = '%s', uemail = '%s' WHERE uid = '%s';" % (
            upw, uname, uemail, uid)
        server.cur.execute(sql)
        server.db.commit()
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


def uploadImg(uid, img):
    try:
        path = './static/userimg/' + uid + '.' + img.mimetype.split('/')[1]
        img.save(path)
        sql = "UPDATE user SET uimg = '%s' WHERE uid = '%s'" % (path, uid)
        server.cur.execute(sql)
        server.db.commit()
        resMsg["code"] = 0
        resMsg["msg"] = "Success!"
        return jsonify(resMsg)
    except pymysql.err.IntegrityError as e:
        code, msg = e.args
        resMsg["code"] = code
        resMsg["msg"] = msg
        return resMsg
