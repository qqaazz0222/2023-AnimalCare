import pymysql

db = pymysql.connect(host="svc.gksl2.cloudtype.app", port=31535, user="root",
                     passwd="4uvg2mlenu33f1", db="main", charset="utf8")
cur = db.cursor()

sql = """SELECT * FROM user"""
cur.execute(sql)
result = cur.fetchall()
print(result)
db.commit()
db.close()
