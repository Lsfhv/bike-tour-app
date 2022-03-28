from flask import Flask, jsonify
import json
import requests

app = Flask(__name__)

@app.route('/')
def returnPoints():
    json_file = {}
    try:
        datas = json.loads(requests.get("https://api.tfl.gov.uk/BikePoint/").text)
        for data in datas:
            common_names, lat, lon, bike_available, bike_space =  data['commonName'], \
                                                                  data['lat'], \
                                                                  data['lon'], \
                                                                  data['additionalProperties'][6]['value'], \
                                                                  data['additionalProperties'][7]['value']
            arr = [lat, lon, str(bike_available), str(bike_space)]
            json_file[common_names] = arr
    except requests.ConnectionError:
        print("error")
    print(json_file)
    return jsonify(json_file)

if __name__ == '__main__':
    app.run()