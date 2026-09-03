import json

schemes = []

with open("assets/json/schemes.json", "w", encoding="utf-8") as f:
    json.dump(schemes, f, ensure_ascii=False, indent=2)

print("schemes.json generated.")