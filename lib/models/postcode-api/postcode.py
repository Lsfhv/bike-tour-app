import json
import requests
import googlemaps
import os


class PostCodePull:

    def pullLatlon():
        with open(r"bike-tour-app/lib/models/postcode-api/latlon.txt", "w") as outfile:
            try:
                response = requests.get("https://api.tfl.gov.uk/BikePoint/")
                datas = json.loads(response.text)
                for data in datas:
                    lat, lon = data['lat'], data['lon']

                    latlon = str(lat) + "," + str(lon)
                    outfile.write(latlon + "\n")
            except requests.ConnectionError:
                print("Connection Error")
            remove_chars = len(os.linesep)
            outfile.truncate(outfile.tell() - remove_chars)

    def coordstxtToPost():
        with open(r"bike-tour-app/lib/models/postcode-api/latlon.txt", "r") as file:
            for line in file:
                PostCodePull.pullPostCode(line)

    def pullPostCode(latlng):
        client = googlemaps.Client(
            key="AIzaSyA75AqNa-yxMDYqffGrN0AqyUPumqkmuEs")
        address = client.reverse_geocode(latlng=latlng)
        postcode = address[0]['address_components'][-1]['long_name']
        with open(r"bike-tour-app/lib/models/postcode-api/postcode.txt", "a") as outfile:
            outfile.write(postcode + " => " + latlng)

    def sortPostCode():
        with open(r"bike-tour-app/lib/models/postcode-api/postcode.txt", "r") as file:
            for line in file:
                if line[0] == "N" and line[1].isnumeric():
                    with open(r"bike-tour-app/lib/models/postcode-api/n_postcode.txt", "a") as txt:
                        txt.write(line)

                elif line[0] == "N" and line[1] == "W":
                    with open(r"bike-tour-app/lib/models/postcode-api/nw_postcode.txt", "a") as txt:
                        txt.write(line)

                elif line[0] == "W" and line[1].isnumeric():
                    with open(r"bike-tour-app/lib/models/postcode-api/w_postcode.txt", "a") as txt:
                        txt.write(line)

                elif line[0] == "W" and line[1] == "C":
                    with open(r"bike-tour-app/lib/models/postcode-api/wc_postcode.txt", "a") as txt:
                        txt.write(line)

                elif line[0] == "S" and line[1] == "W":
                    with open(r"bike-tour-app/lib/models/postcode-api/sw_postcode.txt", "a") as txt:
                        txt.write(line)

                elif line[0] == "S" and line[1] == "E":
                    with open(r"bike-tour-app/lib/models/postcode-api/se_postcode.txt", "a") as txt:
                        txt.write(line)

                elif line[0] == "E" and line[1].isnumeric():
                    with open(r"bike-tour-app/lib/models/postcode-api/e_postcode.txt", "a") as txt:
                        txt.write(line)

                elif line[0] == "E" and line[1] == "C":
                    with open(r"bike-tour-app/lib/models/postcode-api/ec_postcode.txt", "a") as txt:
                        txt.write(line)

                else:
                    with open(r"bike-tour-app/lib/models/postcode-api/bug_postcode.txt", "a") as txt:
                        txt.write(line)

    def erasePostCode():
        open(r"bike-tour-app/lib/models/postcode-api/postcode.txt", "w").close

    def eraseSortPostCode():
        open(r"bike-tour-app/lib/models/postcode-api/n_postcode.txt", "w").close
        open(r"bike-tour-app/lib/models/postcode-api/nw_postcode.txt", "w").close
        open(r"bike-tour-app/lib/models/postcode-api/w_postcode.txt", "w").close
        open(r"bike-tour-app/lib/models/postcode-api/wc_postcode.txt", "w").close
        open(r"bike-tour-app/lib/models/postcode-api/sw_postcode.txt", "w").close
        open(r"bike-tour-app/lib/models/postcode-api/se_postcode.txt", "w").close
        open(r"bike-tour-app/lib/models/postcode-api/e_postcode.txt", "w").close
        open(r"bike-tour-app/lib/models/postcode-api/ec_postcode.txt", "w").close
        open(r"bike-tour-app/lib/models/postcode-api/bug_postcode.txt", "w").close


if __name__ == "__main__":
    # Step 1:
    # PostCodePull.pullLatlon()

    # Step 2:
    # Wait for all the postcodes
    # PostCodePull.erasePostCode()
    # PostCodePull.coordstxtToPost()

    # Step 3:
    # PostCodePull.eraseSortPostCode()
    PostCodePull.sortPostCode()
