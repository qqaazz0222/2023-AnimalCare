db = {
    'user': 'root',
    'password': '4uvg2mlenu33f1',
    'host': 'svc.gksl2.cloudtype.app',
    'port': '31535',
    'database': 'main'
}

DB_URL = f"mysql+mysqlconnector://{db['user']}:{db['password']}@{db['host']}:{db['port']}/{db['database']}?charset=utf8"
