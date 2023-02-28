import json

config_db = json.load(open('db.json', encoding="utf-8"))
print(config_db["host"])
