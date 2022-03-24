import json
import requests
import googlemaps


class PostCodePull:
    def __init__(self, url="https://api.tfl.gov.uk/BikePoint/", coords=None):
        self.url = url
        if not coords:
            coords = {}
        self.coords = coords

    def pullLatlon(self):
        outfile = open(
            r"bike-tour-app/lib/models/postcode-api/latlon.txt", "r+")
        try:
            response = requests.get(self.url)
            datas = json.loads(response.text)
            for data in datas:
                lat, lon = data['lat'], data['lon']
                self.coords = lat, lon
                # print(self.coords)
                stringCoords = str(self.coords)
                outfile.write(stringCoords + "\n")
        except requests.ConnectionError:
            print("Connection Error")

    def coordstxtToPost(self):
        with open(r"bike-tour-app/lib/models/postcode-api/latlon.txt", "r+") as file:
            for line in file:
                PostCodePull.pullPostCode(line)

    def pullPostCode(latlng):
        client = googlemaps.Client(
            key="AIzaSyDN4RDUVv8lX81W1CeoqKVIAObUdAA0mQI")
        address = client.reverse_geocode(latlng=latlng)
        postcode = address[0]['address_components'][-1]['long_name']
        # outfile = open(r"bike-tour-app/lib/models/postcode-api/postcode.txt", "r+")
        # outfile.write(postcode + "\n")
        return postcode

    def map_postcode_to_lanlng(data):
        mappings = {}
        for d in data.keys():
            mappings[PostCodePull.postcode(d)] = d
            print(d)


if __name__ == "__main__":

    PostCodePull.pullPostCode("51.487285, -0.217995")
