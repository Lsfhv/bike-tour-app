import json
import requests
import googlemaps
import os


class PostCodePull:
    def __init__(self, url="https://api.tfl.gov.uk/BikePoint/"):
        self.url = url

    def pullLatlon(self):
        with open(r"bike-tour-app/lib/models/postcode-api/latlon.txt", "w") as outfile:
            try:
                response = requests.get(self.url)
                datas = json.loads(response.text)
                for data in datas:
                    lat, lon = data['lat'], data['lon']
                    latlon = str(lat) + ", " + str(lon)
                    outfile.write(latlon + "\n")
            except requests.ConnectionError:
                print("Connection Error")
            remove_chars = len(os.linesep)
            outfile.truncate(outfile.tell() - remove_chars)

    def coordstxtToPost(self):
        with open(r"bike-tour-app/lib/models/postcode-api/latlon.txt", "r+") as file:
            for line in file:
                PostCodePull.pullPostCode(line)

    def pullPostCode(latlng):
        client = googlemaps.Client(
            key="AIzaSyDN4RDUVv8lX81W1CeoqKVIAObUdAA0mQI")
        address = client.reverse_geocode(latlng=latlng)
        postcode = address[0]['address_components'][-1]['long_name']
        with open(r"bike-tour-app/lib/models/postcode-api/postcode.txt", "r+") as outfile:
            outfile.write(postcode + "=> " + latlng + "\n")
            remove_chars = len(os.linesep)
            outfile.truncate(outfile.tell() - remove_chars)

    # def map_postcode_to_lanlng(data):
    #     mappings = {}
    #     for d in data.keys():
    #         mappings[PostCodePull.pullPostCode(d)] = d

    def sortPostCode():
        pass


if __name__ == "__main__":
    obj = PostCodePull()
    obj.pullLatlon()
    obj.coordstxtToPost()
