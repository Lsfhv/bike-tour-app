from flask import Flask, jsonify
import json
import requests

app = Flask(__name__)

@app.route('/')
def returnPoints():
    datas = json.loads(requests.get("https://api.tfl.gov.uk/BikePoint/").text)
    print(datas)
    return jsonify(datas)

if __name__ == '__main__':
    app.run()